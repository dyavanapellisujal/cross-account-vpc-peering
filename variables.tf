variable "peering_region" {
    type = string
    default = "us-east-1"
}

variable "peer_initiation_region" {
    type = string
    default = "us-east-1"
  
}

variable "requestor_account_id" {
    type = string
    default = "975688691050"
  
}

variable "acceptor_profile" {
    type = string
    default = "acceptor"
  
}

variable "requestor_profile" {
    type = string
    default = "requestor"
}

variable "aws_requestor_account_arn" {
    type = string
    default = "arn_of_the_Iam_user_from_the_requestor_account"
  
}