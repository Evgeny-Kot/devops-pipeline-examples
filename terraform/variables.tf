variable "aws_region" {
  description = "AWS region for all resources."
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Deployment environment used in names and tags."
  type        = string
  default     = "development"

  validation {
    condition     = contains(["development", "staging", "production"], var.environment)
    error_message = "Environment must be development, staging, or production."
  }
}

variable "project_name" {
  description = "Sanitized project identifier."
  type        = string
  default     = "example-platform"

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{2,30}$", var.project_name))
    error_message = "Project name must be 3-31 lowercase alphanumeric or hyphen characters and begin with a letter."
  }
}

variable "artifact_retention_days" {
  description = "Days before noncurrent artifact versions expire."
  type        = number
  default     = 30

  validation {
    condition     = var.artifact_retention_days >= 7
    error_message = "Artifact retention must be at least seven days."
  }
}

variable "additional_tags" {
  description = "Additional resource tags."
  type        = map(string)
  default     = {}
}

