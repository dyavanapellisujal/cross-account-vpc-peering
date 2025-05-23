
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

resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.acceptor_vpc.id
  cidr_block = "192.168.2.0/25"
  map_public_ip_on_launch = true

  tags = {
    "Name" = "private_subnet"
  }
  
}
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.acceptor_vpc.id
  tags = {
    "Name" = "private_route_table"
  }
  
}

resource "aws_route_table_association" "private_subnet_route" {

  route_table_id = aws_route_table.private_route_table.id
  subnet_id = aws_subnet.private_subnet.id
}








