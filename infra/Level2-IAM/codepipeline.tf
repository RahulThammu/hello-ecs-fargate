########################################
# CODEBUILD ROLE (build & push to ECR)
########################################
resource "aws_iam_role" "codebuild" {
  name               = "${var.project_name}-codebuild"
  assume_role_policy = data.aws_iam_policy_document.codebuild_trust.json
}

data "aws_iam_policy_document" "codebuild_trust" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {      
       type = "Service" 
       identifiers = ["codebuild.amazonaws.com"]       
       }
  }
}


data "aws_iam_policy_document" "codebuild_inline" {
  statement {
    sid     = "ECRLoginAndPush"
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:PutImage",
      "ecr:BatchCheckLayerAvailability"
    ]
    resources = ["*"]
  }
  statement {
    sid     = "ECRRepoSpecific"
    actions = ["ecr:DescribeRepositories", "ecr:DescribeImages"]
    resources = [var.ecr_repo_arn]
  }
  statement {
    sid     = "Logs"
    actions = [
      "logs:CreateLogGroup","logs:CreateLogStream","logs:PutLogEvents"
    ]
    resources = ["arn:aws:logs:${local.aws_region}:${local.account_id}:*"]
  }
  statement {
    sid     = "ArtifactsS3"
    actions = ["s3:GetObject","s3:PutObject","s3:PutObjectAcl","s3:GetBucketLocation","s3:ListBucket"]
    resources = [var.bucket_arn, "${var.bucket_arn}/*"]
  }
  # Optional: decrypt with KMS if artifact bucket/ECR are KMS-encrypted
  dynamic "statement" {
    for_each = local.kms_key_arn != "" ? [1] : []
    content {
      sid       = "KMS"
      actions   = ["kms:Decrypt","kms:Encrypt","kms:GenerateDataKey*","kms:DescribeKey"]
      resources = [local.kms_key_arn]
    }
  }
}

resource "aws_iam_policy" "codebuild_policy" {
  name   = "${var.project_name}-codebuild-policy"
  policy = data.aws_iam_policy_document.codebuild_inline.json
}

resource "aws_iam_role_policy_attachment" "codebuild_attach" {
  role       = aws_iam_role.codebuild.name
  policy_arn = aws_iam_policy.codebuild_policy.arn
}

#######################################
# CODEDEPLOY ROLE (ECS deployments)
#######################################
resource "aws_iam_role" "codedeploy" {
  name               = "${var.project_name}-codedeploy"
  assume_role_policy = data.aws_iam_policy_document.codedeploy_trust.json
}

data "aws_iam_policy_document" "codedeploy_trust" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["codedeploy.amazonaws.com"]
    }
  }
}

# Managed policy purpose-built for ECS blue/green
resource "aws_iam_role_policy_attachment" "codedeploy_managed" {
  role       = aws_iam_role.codedeploy.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
}

#######################################
# CODEPIPELINE ROLE (orchestrates CI/CD)
#######################################
resource "aws_iam_role" "codepipeline" {
  name               = "${var.project_name}-codepipeline"
  assume_role_policy = data.aws_iam_policy_document.codepipeline_trust.json
}

data "aws_iam_policy_document" "codepipeline_trust" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }
  }
}

# Grant CP access to S3 artifacts, CodeBuild, CodeDeploy, ECS & PassRole to CB/CD roles
data "aws_iam_policy_document" "codepipeline_inline" {
  statement {
    sid     = "S3Artifacts"
    actions = ["s3:GetObject","s3:GetObjectVersion","s3:PutObject","s3:PutObjectAcl","s3:ListBucket"]
    resources = [var.bucket_arn, "${var.bucket_arn}/*"]
  }
  statement {
    sid     = "CodeBuild"
    actions = ["codebuild:StartBuild","codebuild:BatchGetBuilds"]
    resources = ["*"] # restrict to the specific CodeBuild project ARN when known
  }
  statement {
    sid     = "CodeDeploy"
    actions = ["codedeploy:CreateDeployment","codedeploy:Get*","codedeploy:RegisterApplicationRevision"]
    resources = ["*"] # restrict to your CodeDeploy app/deployment-group ARNs
  }
  statement {
    sid     = "ECSRead"
    actions = ["ecs:DescribeServices","ecs:DescribeTaskDefinition","ecs:RegisterTaskDefinition"]
    resources = ["*"]
  }
  statement {
    sid       = "PassRolesToStages"
    actions   = ["iam:PassRole"]
    resources = [
      aws_iam_role.codebuild.arn,
      aws_iam_role.codedeploy.arn
    ]
  }
  dynamic "statement" {
    for_each = local.kms_key_arn != "" ? [1] : []
    content {
      sid       = "KMS"
      actions   = ["kms:Decrypt","kms:Encrypt","kms:GenerateDataKey*","kms:DescribeKey"]
      resources = [local.kms_key_arn]
    }
  }
}

resource "aws_iam_policy" "codepipeline_policy" {
  name   = "${var.project_name}-codepipeline-policy"
  policy = data.aws_iam_policy_document.codepipeline_inline.json
}

resource "aws_iam_role_policy_attachment" "codepipeline_attach" {
  role       = aws_iam_role.codepipeline.name
  policy_arn = aws_iam_policy.codepipeline_policy.arn
}