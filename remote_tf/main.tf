provider "aws" {
  region = us-east-1
}

/*resource "aws_instance" "ec2_instance" {
   ami = "ami-05b10e08d247fb927"
   instance_type = "t3.micro"
   tags = {
    "Name" = "backend"
   }

}*/

resource "aws_s3_bucket" "drk_back" {
  bucket = "drk_back"
}

/*resource "aws_dynamodb_table" "terraform_lock" {
  name           = "terraform-lock"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}*/
