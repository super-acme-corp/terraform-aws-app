provider "aws" {
  region = var.aws_region
}

# Cluster

resource "aws_ecs_cluster" "main" {
  name = "${var.app_name}-cluster"
}

# ECS - Task Execution Role

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.app_name}-ecsTaskExecutionRole"

  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-policy-attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


# ECS - Retreive private container credentials

data "aws_iam_policy_document" "ecs_read_secrets_role" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue"
    ]
    resources = [
      aws_secretsmanager_secret.registry_credentials.arn
    ]
  }
}

resource "aws_iam_policy" "ecs_read_secrets_role" {
  name        = "${var.app_name}-ecsReadSecretsPolicy"
  description = "Allow ECS tasks to read secrets from parameter store"
  policy      = data.aws_iam_policy_document.ecs_read_secrets_role.json
}

resource "aws_iam_role_policy_attachment" "ecs_read_secrets_role" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.ecs_read_secrets_role.arn
}
