data "terraform_remote_state" "vpc" {
  backend = "local"
<<<<<<< HEAD

  config = {
    path = "/home/jilna/terraform-learning/01-task/vpc/.terraform/terraform.tfstate"
  }
}

resource "aws_instance" "test" {
  ami           = "ami-00385a401487aefa4"
  instance_type = "t3.micro"
  subnet_id     = data.terraform_remote_state.vpc.outputs.subnet_public_1_id
=======
  config = {
    path = "/home/jilna/terraform-learning/trial-1/vpc/terraform.tfstate"
  }
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow HTTP inbound traffic and all outbound traffic"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_http"
  }
}

resource "aws_instance" "lab-ec2" {
  ami                         = "ami-00385a401487aefa4"
  instance_type               = "t3.micro"
  subnet_id                   = data.terraform_remote_state.vpc.outputs.public_subnet_1_id
  security_groups             = [aws_security_group.allow_http.id]
  associate_public_ip_address = true
  key_name                    = "newkeypair" 
 

  user_data = <<-EOF
  
    #!/bin/bash
    sudo yum update -y
    sudo yum install nginx -y
    sudo systemctl start nginx
    sudo systemctl enable nginx
  EOF

>>>>>>> 94b39bc (Second commit)

  tags = {
    Name = "HelloWorld"
  }
<<<<<<< HEAD
}
=======
}




>>>>>>> 94b39bc (Second commit)
