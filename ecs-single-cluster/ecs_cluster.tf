provider "aws" {
  profile    = "default"
  region     = "us-east-1"
}

resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.cluster_name
}
