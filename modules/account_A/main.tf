

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
