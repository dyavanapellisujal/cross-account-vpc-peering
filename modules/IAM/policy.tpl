{
              "Statement":[
                {
                  "Action":"ec2:acceptVpcPeeringConnection",
                  "Effect":"Allow",
                  "Resource": "${resource_arn}"
                  
                },
                {
                  "Action":"ec2:DescribeVpcPeeringConnections",
                  "Effect":"Allow",
                  "Resource": "*"

                },
                {
                  "Action":"ec2:acceptVpcPeeringConnection",
                  "Condition":{
                    "StringEquals":{
                      "ec2:AccepterVpc":
                        "${resource_arn}"
                      
                    }
                  },
                  "Effect":"Allow",
                  "Resource":
                    "${peering_arn}"
                  
                }
              ],
              "Version":"2012-10-17"
            }