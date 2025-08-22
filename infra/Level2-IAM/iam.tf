# KMS Key
resource "aws_kms_key" "ecs_key" {
  description             = "KMS key for ECS & CI/CD"
  deletion_window_in_days = 7
  enable_key_rotation     = true
}

