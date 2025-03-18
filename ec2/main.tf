data "terraform_remote_state" "vpc" {
  backend = "local"

  config = {
    path = "/home/jilna/terraform-learning/01-task/vpc/.terraform/terraform.tfstate"
  }
}

resource "aws_instance" "test" {
  ami           = "ami-00385a401487aefa4"
  instance_type = "t3.micro"
  subnet_id     = data.terraform_remote_state.vpc.outputs.subnet_public_1_id

  tags = {
    Name = "HelloWorld"
  }
}