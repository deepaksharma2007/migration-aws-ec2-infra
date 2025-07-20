provider "aws" {
    region = var.aws_region
}

terraform {
  backend "s3" {
    bucket = "terraform-state-file-mumbai"
    key    = "prod-terraform-state"
    region = "ap-south-1"
  }
}
