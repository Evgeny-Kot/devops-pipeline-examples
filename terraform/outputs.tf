output "ecr_repository_url" {
  description = "Application container repository URL."
  value       = aws_ecr_repository.application.repository_url
}

output "artifact_bucket_name" {
  description = "Build artifact bucket name."
  value       = aws_s3_bucket.artifacts.id
}

output "aws_account_id" {
  description = "AWS account where resources were created."
  value       = data.aws_caller_identity.current.account_id
}

