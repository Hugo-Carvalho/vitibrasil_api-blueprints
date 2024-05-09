terraform {
  required_providers {
    aws = {
      version = "5.48.0"
      source  = "hashicorp/aws"
    }
  }
  backend "s3" {
    region               = "us-east-1"
    key                  = "app/main"
    workspace_key_prefix = "app_tf"
    bucket               = "vitibrasil-terraform"
    dynamodb_table       = "vitibrasil-dynamo"
  }
}
