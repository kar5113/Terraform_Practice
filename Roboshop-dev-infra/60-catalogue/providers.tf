terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.22.1"
    }
  }
   backend "s3" {
    bucket    = "kardev-remote-state"
    key       = "Roboshop-dev-infra-catalogue"
    region    = "us-east-1"
    use_lockfile = true
    encrypt= true
   }
}

provider "aws" {
  region = "us-east-1"
}