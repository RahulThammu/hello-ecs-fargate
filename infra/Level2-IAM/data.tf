# Get the current AWS account ID
data "aws_caller_identity" "current" {}

# Fetch outputs from the VPC state
data "terraform_remote_state" "level1_network_tfstate" {
  backend = "s3"
  config = {
    bucket = "rahul1456aws"
    key    = "Level1/vpc.tfstate"
    region = "us-east-1"
  }
}

# Extract useful locals for reuse
locals {
  aws_region = "us-east-1"
  account_id = 548929081456
  kms_key_arn = aws_kms_key.ecs_key.arn
}
