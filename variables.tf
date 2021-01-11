variable "aws_region" {
  default = "eu-west-1"
}

variable "app_name" {
  type = string
}

variable "app_port" {
  description = "The port the container application runs on"
}

variable "app_subnets" {
  description = "The private subnets to associate with the ECS services"
}

variable "container_image" {
  type = string
}

variable "container_registry" {
  description = "The registry to source the application image from"
  type        = string
}

variable "container_registry_username" {
  description = "The username to use for the container registry"
  type        = string
}

variable "container_registry_password" {
  description = "The password to use for the container registry"
  type        = string
  sensitive   = true
}

variable "container_tag" {
  default     = "latest"
  description = "The image tag to source for the deployment"
  type        = string
}

variable "task_cpu" {
  default     = 256 
  description = "Number of CPU units to assign to app ECS task"
}

variable "task_memory" {
  default     = 1024 
  description = "Amount of memory to assign to app ECS task (in megabytes)"
}

variable "dns_zone_id" {
  description = "The ID for the dns zone in which to create an app record"
}

variable "lb_subnets" {
  description = "The public subnets to associate the ALB target group entry to"
}

variable "lb_subdomain" {
  type = string
  description = "The subdomain to map the load balancer to"
}

variable "vpc_id" {
  description = "The VPC to use for the ECS application security group"
}
