terraform {
  required_providers {
    aws = {
      source = "aws"
      version = "3.26.0"
    }
  }
  backend "s3" {
    bucket = "columnstore-tf-state"
    key    = "columnstore-s3-efs-setup"
  }
}
