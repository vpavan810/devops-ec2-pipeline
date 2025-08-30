provider "aws" {
  region = var.aws_region
}

resource "aws_ecs_cluster" "devops_cluster" {
  name = "devops-ecs-cluster"
}

resource "aws_ecs_task_definition" "app_task" {
  family                   = "devops-app-task"
  network_mode            = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                     = "256"
  memory                  = "512"
  execution_role_arn      = var.execution_role_arn
  container_definitions   = jsonencode([
    {
      name      = "devops-app"
      image     = var.container_image
      essential = true
      portMappings = [
        {
          containerPort = 80
          
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "app_service" {
  name            = "devops-app-service"
  cluster         = aws_ecs_cluster.devops_cluster.id
  task_definition = aws_ecs_task_definition.app_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.subnet_ids
    security_groups = [var.security_group_id]
    assign_public_ip = true
  }
}