resource "aws_ecs_task_definition" "grafana_task" {
  family = "grafanaTasks"
  container_definitions = jsonencode([
    {
      name = "grafana"
      memoryReservation = 256
      image = "grafana/grafana-oss:latest"
      portMappings = [
        {
          containerPort = 3000
          hostPort = 80
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "grafana_service" {
  name = "grafanaService"
  cluster = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.grafana_task.arn
  desired_count = 1
  depends_on = [
    aws_instance.ecs_ec2
  ]
}
