terraform {
  required_providers {
    aws = {
      version = "~> 5.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  #profile = "learnerlab"
}
