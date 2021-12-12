resource "aws_s3_bucket" "s3bucket" {
    bucket = "group1mofor"
    acl = "private"
  
}



resource "aws_iam_role_policy" "s3rolepolicy" {
    name = "s3rolepolicy"
    role = aws_iam_role.s3accessRoleforEC2.id
    policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "Stmt1639201113952",
        "Action": [
          "s3:CreateBucket",
          "s3:DeleteObject",
          "s3:GetObject",
          "s3:PutObject"
        ],
        "Effect": "Allow",
        "Resource": "arn:aws:s3:::group1mofor/*"
      }
    ]
  }
    )
  
}





resource "aws_iam_role" "s3accessRoleforEC2" {
  name = "s3accessRoleforEC2"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}