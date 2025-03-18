data "terraform_remote_state" "vpc" {
  backend = "local"
  config = {
    path = "/home/jilna/terraform-learning/03-tas/aws-infra/vpc/terraform.tfstate"
  }
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow http inbound traffic and all outbound traffic"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_instance" "web" {
  ami                         = "ami-00385a401487aefa4"
  instance_type               = "t3.micro"
  associate_public_ip_address = true
  security_groups             = [aws_security_group.allow_http.id]
  subnet_id                   = data.terraform_remote_state.vpc.outputs.publicsubnet_1_id
  key_name                    = "newkeypair"
  iam_instance_profile        = aws_iam_instance_profile.ec2_ecr_instance_profile.name

  user_data = <<-EOF
  #!/bin/bash
  sudo yum update -y
  sudo yum install -y docker 
  sudo systemctl start docker
  sudo systemctl enable docker
  sudo usermod -aG docker ec2-user
  sudo aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin 625753448117.dkr.ecr.eu-west-1.amazonaws.com
  sudo docker pull 625753448117.dkr.ecr.eu-west-1.amazonaws.com/nginx-hello-repo:latest
  sudo docker run -d -p 80:80 625753448117.dkr.ecr.eu-west-1.amazonaws.com/nginx-hello-repo:latest
EOF

  tags = {
    Name = "nginx-hello-instance"
  }
}

resource "aws_iam_role" "ec2_role" {
  name = "EC2_ECR_Access"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "tag-value"
  }
}


resource "aws_iam_policy" "ecr_access" {
  name = "ECR_Access_Policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_instance_profile" "ec2_ecr_instance_profile" {
  name = "EC2_ECR_Instance_Profile"
  role = aws_iam_role.ec2_role.name
}

resource "aws_ecr_repository" "nginx_hello_repo" {
  name                 = "nginx-hello-repo"
  image_tag_mutability = "MUTABLE"

}

resource "aws_iam_role_policy_attachment" "ecr_access_attachment" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ecr_access.arn
}
