variable "environment" {
  description = "Deployment environment (stg or prod)"
  type        = string
  default     = "stg"
}

variable "aws_region" {
  description = "AWS region for the deployment"
  type        = string
  default     = "us-east-2"
}

variable "ssh_public_key_path" {
  description = "Path to the SSH public key"
  type        = string
  default     = "~/.ssh/tuai-stg-key.pub"
}

variable "ssh_private_key_path" {
  description = "Path to the SSH private key"
  type        = string
  default     = "~/.ssh/tuai-stg-key"
}
variable "ssh_user" {
  description = "SSH user for the instance"
  type        = string
  default     = "ubuntu"
}
variable "instance_type" {
  description = "Instance type for the EC2 instance"
  type        = string
  default     = "t3.micro"
}
