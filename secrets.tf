resource "aws_secretsmanager_secret" "registry_credentials" {
  name_prefix = "registry-credentials/${var.container_registry}"
  description = "Credentials to docker registry"
}

resource "aws_secretsmanager_secret_version" "registry_credentials" {
  secret_id     = aws_secretsmanager_secret.registry_credentials.id
  secret_string = <<EOF
  {
    "username": "${var.container_registry_username}",
    "password": "${var.container_registry_password}"
  }
  EOF
}
