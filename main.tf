resource "aws_s3_bucket" "s3bucket" {
    bucket = "group1mofor"
    acl = "private"
      server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.mykms1.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
  
}

resource "aws_kms_key" "mykms1" {
  description             = "KMS key for group1mofor"
  enable_key_rotation = true
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

resource "aws_instance" "s3instance" {
      ami  = "ami-0ed9277fb7eb570c9"
      instance_type = "t2.micro"
      key_name = "kp-mbpm1pro-nova"
      iam_instance_profile = aws_iam_instance_profile.ec2Instaceprof.id
      associate_public_ip_address = true
      user_data = <<EOF
       #!/bin/bash
        sudo chown ec2-user /var/log
       aws s3 cp /var/log s3://group1mofor --recursive
EOF
  tags = {
    Name = "Instancegrp1"
  }
} 


resource "aws_iam_instance_profile" "ec2Instaceprof" {
  name = "ec2Instaceprof"
  role = aws_iam_role.s3accessRoleforEC2.name

  
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