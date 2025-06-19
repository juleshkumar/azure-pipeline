terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.43.0"
    }
  }
}


provider "aws" {
  region = "us-east-1"
  #assume_role {
    #role_arn = "arn:aws:iam::296062546708:role/terraform-deployment-test-role"
  #}

}

  
