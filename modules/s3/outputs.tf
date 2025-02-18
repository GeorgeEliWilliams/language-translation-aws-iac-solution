# ---------------------------------------------------------------------------------------------------------------------
# MODULE OUTPUTS - EXPOSE S3 BUCKET DETAILS
# These outputs make it easy to reference the bucket name and ARN in other modules.
# ---------------------------------------------------------------------------------------------------------------------

# Output the name of the S3 bucket
output "bucket_name" {
  description = "Name of the created S3 bucket"
  value       = aws_s3_bucket.this.id
}

# Output the ARN of the S3 bucket
output "bucket_arn" {
  description = "ARN (Amazon Resource Name) of the S3 bucket"
  value       = aws_s3_bucket.this.arn
}
