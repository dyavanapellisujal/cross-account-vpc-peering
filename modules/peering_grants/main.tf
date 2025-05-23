
provider "aws" {
  alias  = "assume"
  region = var.region

  assume_role {
    role_arn     = var.role_arn
    session_name = "acceptor_session"
  }
}
resource "aws_vpc_peering_connection_accepter" "acceptor" {
    provider = aws.assume
    vpc_peering_connection_id = var.vpc_peering_connection_id
    auto_accept = true
      

  
}