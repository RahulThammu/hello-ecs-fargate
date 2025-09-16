data "terraform_remote_state" "iam" {
  backend = "s3"

  config = {
    bucket = "rahul1456aws"
    key    = "Level2/iam.tfstate"
    region = "us-east-1"
  }
}
locals {
  codebuild_role_arn   = data.terraform_remote_state.iam.outputs.codebuild_role_arn
  codedeploy_role_arn = data.terraform_remote_state.iam.outputs.codedeploy_role_arn
  codepipeline_role_arn = data.terraform_remote_state.iam.outputs.codepipeline_role_arn
  ecs_task_execution_role_arn = data.terraform_remote_state.iam.outputs.ecs_task_execution_role_arn
  ecs_task_role_arn = data.terraform_remote_state.iam.outputs.ecs_task_role_arn
}
data "aws_ecr_repository" "multicloud" {
  name = "multicloud/ecrbuild"
}
locals {
  repo_name = data.aws_ecr_repository.multicloud.name
  repo_arn  = data.aws_ecr_repository.multicloud.arn
  repo_url  = data.aws_ecr_repository.multicloud.repository_url
}
data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket = "rahul1456aws"
    key    = "Level1/vpc.tfstate"
    region = "us-east-1"
  }
}

locals {
  vpc_id = data.terraform_remote_state.network.outputs.vpc_id
  public_subnet_ids = data.terraform_remote_state.network.outputs.public_subnet_ids
  private_subnet_ids = data.terraform_remote_state.network.outputs.private_subnet_ids
   
}
