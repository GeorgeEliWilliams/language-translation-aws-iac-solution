# Output the name of the translation request bucket
output "bucket_name" {
  description = "Name of S3 bucket"
  value       = aws_s3_bucket.this.id
}

# Output the ARN of the translation request bucket
output "bucket_arn" {
  description = "ARN of the translation request S3 bucket"
  value       = aws_s3_bucket.this.arn
}
