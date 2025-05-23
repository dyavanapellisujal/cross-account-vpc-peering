

output "peer_account_id" {
    value = data.aws_caller_identity.current.account_id
  
}
output "peer_vpc_id" {
  value = aws_vpc.acceptor_vpc.id
}


output "peer_region" {
    value = data.aws_region.current.name
  
}
output "acceptor_vpc_arn" {

    value = aws_vpc.acceptor_vpc.arn
}

output "acceptor_route_table_id" {
  value = aws_route_table.private_route_table.id
}