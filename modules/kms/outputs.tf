output "key_id" {
  description = "The ID of the created KMS key"
  value       = aws_kms_key.this.id
}

output "key_arn" {
  description = "The ARN of the created KMS key"
  value       = aws_kms_key.this.arn
}
