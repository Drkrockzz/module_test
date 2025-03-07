provider "aws" {
  region = us-east-1
}

module "ec2_instance" {
  source = "./ec2_instance"
  instance_ami = "ami-05b10e08d247fb927"
  instance_type = "t3.micro"
}