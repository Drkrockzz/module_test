provider "aws" {
  region = us-east-1
}

resource "aws_instance" "m_ec2" {
  ami = var.instance_ami
  associate_public_ip_address = true
  instance_type = var.instance_type
}