
provider "aws" {
  region  = var.aws_peering_region
  profile = var.profile
}

data "aws_caller_identity" "current" {}


data "aws_region" "current" {}

resource "aws_vpc" "acceptor_vpc" {

    cidr_block = var.cidr_block
    tags = {
      "Name" = var.vpc_tag
    }
  
}








