resource "aws_ecs_cluster" "app_cluster" {
  name = "application_cluster"
}

resource "aws_ecs_service" "frontend" {
  name                               = "frontend"
  cluster                            = aws_ecs_cluster.app_cluster.id
  task_definition                    = aws_ecs_task_definition.frontend_task.arn
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  health_check_grace_period_seconds  = 300
  launch_type                        = "EC2"
  scheduling_strategy                = "REPLICA"
  desired_count                      = var.blue_instance_count

  load_balancer {
    target_group_arn = aws_lb_target_group.tg[0].arn
    container_name   = "app"
    container_port   = 80
  }

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  lifecycle {
    ignore_changes = [task_definition, desired_count]
  }

  count = var.enable_blue_env ? 1 : 0
}

resource "aws_ecs_task_definition" "frontend_task" {
  family                   = "frontend-task"
  requires_compatibilities = ["EC2"]
  memory                   = var.ecs_task_memory
  cpu                      = var.ecs_task_cpu
  execution_role_arn       = aws_iam_role.app_task_role.arn

  container_definitions = jsonencode([{
    name      = "app"
    image     = "${var.aws_account_id}.dkr.ecr.${var.aws_account_region}.amazonaws.com/app-ecr-repository:latest"
    essential = true
    portMappings = [{
      containerPort = var.ecs_container_port
    }]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = var.ecs_log_group_name
        awslogs-stream-prefix = "ecs"
        awslogs-region        = var.region
      }
    }
  }])
}
