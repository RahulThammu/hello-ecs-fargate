terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"  # Update this to your desired AWS region
}

terraform {
  backend "s3" {
    bucket = "rahul1456aws"
    key    = "Level1/vpc.tfstate"  # Path within the S3 bucket
    region = "us-east-1"                # Specify the AWS region
    #dynamodb_table = "aws_dynamodb_table.terralock.name"   # Optional: specify DynamoDB table for state locking
    encrypt = true                           # Optional: Enable server-side encryption for state file
  }
}