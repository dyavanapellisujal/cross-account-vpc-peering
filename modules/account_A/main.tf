

resource "aws_vpc" "requester_vpc" {
   
    cidr_block = var.cidr_block
    tags = {
      "Name" = var.vpc_tag
    }

}

resource "aws_vpc_peering_connection" "cross_account_peering" {
    vpc_id = aws_vpc.requester_vpc.id
    peer_vpc_id = var.peer_vpc_id

    peer_owner_id = var.accepter_account_id

    tags = {
      "Name" = "cross_account_peering" 
    }
}

resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.requester_vpc.id
    cidr_block = "192.168.1.0/25"
  map_public_ip_on_launch = true

    tags = {
      "Name" = "public-subnet"

    }
}

resource "aws_route_table" "public_route_table" {
    vpc_id = aws_vpc.requester_vpc.id
    tags = {
      "Name" = "public-route-table" 
    }
}

resource "aws_route_table_association" "public_subnet_route" {
    route_table_id = aws_route_table.public_route_table.id
    subnet_id = aws_subnet.public_subnet.id
    
}

resource "aws_internet_gateway" "internet_gateway" {
    vpc_id = aws_vpc.requester_vpc.id
    tags = {
      "Name" =  "Requestor_Gateway"

    }
  
}

resource "aws_route" "default_route" {
    route_table_id = aws_route_table.public_route_table.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  
}
