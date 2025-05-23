

resource "aws_iam_role" "vpc_peer_role" {
  name               = "vpc-peer-role"
  assume_role_policy = templatefile("${path.module}/assume_role.tpl",{
    requester_arn = var.aws_peer_requester_user_arn
  })
  }

resource "aws_iam_policy" "allow_vpc_peer" {
    depends_on = [ aws_iam_role.vpc_peer_role ]
    policy = templatefile("${path.module}/policy.tpl",{
        peering_arn= "arn:aws:ec2:${var.aws_peering_region}:${var.acceptor_account_id}:vpc-peering-connection/*",
        resource_arn = "${var.acceptor_vpc_arn}"
    })
    name = "allow_vpc_peer"
  
}


resource "aws_iam_role_policy_attachment" "attach_role" {
    policy_arn = aws_iam_policy.allow_vpc_peer.arn
    role = aws_iam_role.vpc_peer_role.name
  
}

output "aws_iam_policy_content" {
    value = aws_iam_policy.allow_vpc_peer.policy

  
}