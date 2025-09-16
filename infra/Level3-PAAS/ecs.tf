########################################
# ECS Cluster
########################################
resource "aws_ecs_cluster" "app_cluster" {
  name = "simple-cluster"
}

########################################
# Task Definition
########################################
resource "aws_ecs_task_definition" "app_task" {
  family                   = "simple-app"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = local.ecs_task_execution_role_arn

  container_definitions = jsonencode([{
    name  = "simple-app"
    image = "${local.repo_url}:latest"
    portMappings = [{
      containerPort = 80
    }]
  }])
}

########################################
# ECS Service
########################################
resource "aws_ecs_service" "app_service" {
  name            = "simple-app-service"
  cluster         = aws_ecs_cluster.app_cluster.id
  task_definition = aws_ecs_task_definition.app_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = local.public_subnet_ids # replace with your subnet
    assign_public_ip = true
    security_groups  = [aws_security_group.ecs_sg.id]
  }
}