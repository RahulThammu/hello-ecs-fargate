########################################
# CodeBuild Project
########################################
resource "aws_codebuild_project" "app_build" {
  name         = "simple-app-build"
  service_role = local.codebuild_role_arn

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:5.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true # needed for Docker
  }

  source {
    type      = "GITHUB"
    location  = var.github_full_repo
    buildspec = "buildspec.yml"
  }

  artifacts {
    type = "NO_ARTIFACTS"
  }
}


########################################
# CodePipeline
########################################
resource "aws_codepipeline" "app_pipeline" {
  name     = "simple-app-pipeline"
  role_arn = local.codepipeline_role_arn

  artifact_store {
    type     = "S3"
    location = var.s3_bucket
  }

  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        Owner      = var.github_owner
        Repo       = var.github_repo_name
        Branch     = var.github_branch
        OAuthToken = var.github_oauth_token
      }
    }
  }

  stage {
    name = "Build"
    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]

      configuration = {
        ProjectName = aws_codebuild_project.app_build.name
      }
    }
  }
}