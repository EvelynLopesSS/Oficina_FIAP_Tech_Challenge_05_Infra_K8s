variable "region" {
  default = "us-east-1"
}

variable "terraform_admin_arn" {
  description = "ARN da Role (LabRole) da AWS Academy"
  type        = string
  sensitive   = true
}