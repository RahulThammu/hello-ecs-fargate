########################################
# Security Group
########################################
resource "aws_security_group" "ecs_sg" {
  name   = "ecs-sg"
  vpc_id = local.vpc_id # replace with your VPC ID

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}