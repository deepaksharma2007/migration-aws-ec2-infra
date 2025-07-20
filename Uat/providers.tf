provider "aws" {
    region = var.aws_region
}

terraform {
  backend "s3" {
    bucket = "terraform-state-file-mumbai"
    key    = "uat-terraform-state"
    region = "ap-south-1"
  }
}
