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
#   name = "vpc-peer-role" #replace with your exsiting role name  
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
    aws = aws.requestor_vpc_creation  # ✅ no quotes
  }

  # Module inputs
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











