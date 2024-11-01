resource "aws_codedeploy_app" "frontend" {
  compute_platform = "ECS"
  name             = "frontend-deploy"
}

resource "aws_codedeploy_deployment_group" "frontend" {
  app_name               = aws_codedeploy_app.frontend.name
  deployment_group_name  = "frontend-deploy-group"
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
  service_role_arn       = aws_iam_role.codedeploy.arn

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }
    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 1
    }
  }

  ecs_service {
    cluster_name = aws_ecs_cluster.app_cluster.name
    service_name = aws_ecs_service.frontend[0].name
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }
}
