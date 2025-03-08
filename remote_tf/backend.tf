terraform {
  backend "s3" {
    bucket = "drkback"
    key = "drkback/terraform"
    region = "us-east-1"
  }
}
