terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.5.0"
    }
  }
}

provider "aws" {
  region     = "us-east-1"
  access_key = "AKIAYU7CIYPPYQAXZEX6"
  secret_key = "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"
}