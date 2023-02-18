resource "aws_iam_instance_profile" "ecs_instance_profile" {
  name = "ecsInstanceProfile"
  role = aws_iam_role.ecs_role.name
}

resource "tls_private_key" "dev_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "dev_key" {
  key_name   = var.dev_key_name
  public_key = tls_private_key.dev_key.public_key_openssh

  provisioner "local-exec" {    # Generate "terraform-key-pair.pem" in current directory
    command = <<-EOT
      echo '${tls_private_key.dev_key.private_key_pem}' > ./'${var.dev_key_name}'.pem
      chmod 400 ./'${var.dev_key_name}'.pem
    EOT
  }
}

resource "aws_instance" "ecs_ec2" {
  ami           = "ami-05e7fa5a3b6085a75"
  instance_type = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.ecs_instance_profile.name
  security_groups = [aws_security_group.web_server.name, aws_security_group.ssh.name]
  key_name        = "${aws_key_pair.dev_key.key_name}"
  user_data = <<EOT
  #!/bin/bash
  echo "ECS_CLUSTER=single-cluster" >> /etc/ecs/ecs.config
  EOT
}
