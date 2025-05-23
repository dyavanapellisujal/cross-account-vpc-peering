#you need to run this terraform script twice on the first run since this is a two stage terraform script, the first time you run
#apply command it will give a error that role not found, then re run terraform apply the connection for peering will be accepted.

provider "aws" {
  alias   = "requestor_vpc_creation"
  region  = "us-east-1"
  profile = "requestor"
}
provider "aws" {
    alias = "acceptor-provider"
  region  = "us-east-1"
  profile = "acceptor"
}


# data "aws_iam_role" "vpc-peer-role" { 
#   name = "vpc-peer-role" #replace with your exsiting role name  "Use this for scenario if IAM role is already available"
# }





module "acceptor_account_vpc_module" {
    source = "./modules/account_B"
    cidr_block = "192.168.2.0/24"
    vpc_tag = "acceptor-vpc"
    
    aws_peering_region = var.peer_initiation_region
    profile = var.acceptor_profile
    



}


module "IAM_Module" {
  providers = {
    aws = aws.acceptor-provider
  }
  depends_on = [ module.acceptor_account_vpc_module ]
  source = "./modules/IAM"
  acceptor_account_id = module.acceptor_account_vpc_module.peer_account_id
  aws_peering_region = module.acceptor_account_vpc_module.peer_region
  acceptor_vpc_arn = module.acceptor_account_vpc_module.acceptor_vpc_arn
  aws_peer_requester_user_arn = var.aws_requestor_account_arn
}


module "requestor_account_vpc_module" {
    depends_on = [ module.IAM_Module , module.acceptor_account_vpc_module  ]
  source = "./modules/account_A"
  providers = {
    aws = aws.requestor_vpc_creation  
  }


  cidr_block          = "192.168.1.0/24"
  vpc_tag             = "requester-vpc"
  accepter_account_id = module.acceptor_account_vpc_module.peer_account_id
  peer_vpc_id         = module.acceptor_account_vpc_module.peer_vpc_id
}

module "peering_grants" {
# depends_on = [ module.IAM_Module ]
  
  source = "./modules/peering_grants"
   role_arn = module.IAM_Module.role_arn
    region = "us-east-1"
  vpc_peering_connection_id = module.requestor_account_vpc_module.vpc_peering_connection_id
}





resource "aws_route" "requestor_to_acceptor" {
    
    route_table_id = module.requestor_account_vpc_module.requestor_route_table_id
    destination_cidr_block = "192.168.2.0/24"
    vpc_peering_connection_id = module.peering_grants.vpc_peering_connection_id

  
}

resource "aws_route" "acceptor_to_requestor" {
    provider = aws.acceptor-provider
    route_table_id = module.acceptor_account_vpc_module.acceptor_route_table_id
    destination_cidr_block = "192.168.1.0/24"
    vpc_peering_connection_id = module.peering_grants.vpc_peering_connection_id
  
}




