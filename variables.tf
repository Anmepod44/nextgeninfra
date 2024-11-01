# General AWS settings
variable "region" {
  description = "The AWS region where Terraform will deploy resources"
  type        = string
  default     = "us-west-2"
}

variable "aws_account_id" {
  description = "The AWS account ID used for ECR and IAM configurations"
  type        = string
  default     = "123456789012"  # Replace with your actual AWS account ID
}

variable "aws_account_region" {
  description = "The AWS account region for ECR"
  type        = string
  default     = "us-west-2"
}

# VPC settings
variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "enable_vpn_gateway" {
  description = "Enable a VPN gateway in your VPC"
  type        = bool
  default     = false
}

# Subnet settings
variable "public_subnet_count" {
  description = "Number of public subnets in the VPC"
  type        = number
  default     = 2
}

variable "private_subnet_count" {
  description = "Number of private subnets in the VPC"
  type        = number
  default     = 2
}

variable "public_subnet_cidr_blocks" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24",
    "10.0.4.0/24"
  ]
}

variable "private_subnet_cidr_blocks" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default = [
    "10.0.101.0/24",
    "10.0.102.0/24",
    "10.0.103.0/24",
    "10.0.104.0/24"
  ]
}

# Load Balancer settings
variable "elb_sg_ingress_ports" {
  description = "List of ingress ports for the ELB security group"
  type        = list(number)
  default     = [80, 443, 8080]
}

variable "lb_target_group_name" {
  description = "Base name for the load balancer target groups"
  type        = string
  default     = "tg"
}

variable "certificate_arn" {
  description = "ARN of the SSL certificate for HTTPS listener on port 443"
  type        = string
  default     = ""  # Add the certificate ARN if HTTPS is required
}

# Blue/Green Deployment settings
variable "enable_blue_env" {
  description = "Enable blue environment for Blue/Green deployment"
  type        = bool
  default     = true
}

variable "enable_green_env" {
  description = "Enable green environment for Blue/Green deployment"
  type        = bool
  default     = true
}

variable "blue_instance_count" {
  description = "Number of instances in the blue environment"
  type        = number
  default     = 2
}

variable "green_instance_count" {
  description = "Number of instances in the green environment"
  type        = number
  default     = 2
}

# ECS Task Definition and Service settings
variable "ecs_task_memory" {
  description = "Memory allocated for the ECS task"
  type        = number
  default     = 1800
}

variable "ecs_task_cpu" {
  description = "CPU allocated for the ECS task"
  type        = number
  default     = 512
}

variable "ecs_task_execution_role_name" {
  description = "Name of the IAM role used for ECS task execution"
  type        = string
  default     = "app-task-role"
}

variable "ecs_container_port" {
  description = "Port used by the container within the ECS task"
  type        = number
  default     = 80
}

variable "ecs_log_group_name" {
  description = "Name of the CloudWatch log group for ECS task logging"
  type        = string
  default     = "/ecs/app"
}
