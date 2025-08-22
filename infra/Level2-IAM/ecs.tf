############################
# ECS TASK EXECUTION ROLE
# (pull image from ECR, push logs)
############################
resource "aws_iam_role" "ecs_task_execution" {
  name               = "${var.project_name}-ecs-task-exec"
  assume_role_policy = data.aws_iam_policy_document.ecs_tasks_trust.json
}

data "aws_iam_policy_document" "ecs_tasks_trust" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# AWS managed policy covers ECR pull + CW logs, etc.
resource "aws_iam_role_policy_attachment" "ecs_exec_managed" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

############################
# ECS TASK ROLE
# (app’s AWS permissions)
############################
resource "aws_iam_role" "ecs_task" {
  name               = "${var.project_name}-ecs-task"
  assume_role_policy = data.aws_iam_policy_document.ecs_tasks_trust.json
}

# Example: read from Secrets Manager + SSM Parameter Store (adjust as needed)
data "aws_iam_policy_document" "ecs_task_inline" {
  statement {
    sid     = "SecretsRead"
    actions = ["secretsmanager:GetSecretValue", "secretsmanager:DescribeSecret"]
    resources = ["*"] # tighten to specific secrets if known
  }
  statement {
    sid     = "SSMParamsRead"
    actions = ["ssm:GetParameter", "ssm:GetParameters", "ssm:GetParametersByPath"]
    resources = ["*"] # tighten to specific parameters if known
  }
}

resource "aws_iam_policy" "ecs_task_policy" {
  name   = "${var.project_name}-ecs-task-policy"
  policy = data.aws_iam_policy_document.ecs_task_inline.json
}

resource "aws_iam_role_policy_attachment" "ecs_task_attach" {
  role       = aws_iam_role.ecs_task.name
  policy_arn = aws_iam_policy.ecs_task_policy.arn
}