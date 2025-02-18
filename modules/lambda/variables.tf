# Lambda function name
variable "function_name" {
  description = "The name of the Lambda function"
  type        = string
}

# Lambda function handler
variable "function_handler" {
  description = "The name of the function handler"
  type        = string
}

# Request and Response S3 buckets
variable "request_bucket" {
  description = "The name of the S3 bucket where translation requests are stored"
  type        = string
}

variable "response_bucket" {
  description = "The name of the S3 bucket where translation responses are stored"
  type        = string
}

# ARN of the request and response S3 buckets
variable "request_bucket_arn" {
  description = "The ARN of the S3 bucket where translation requests are stored"
  type        = string
}

variable "response_bucket_arn" {
  description = "The ARN of the S3 bucket where translation responses are stored"
  type        = string
}

# Tags for resource identification
variable "tags" {
  description = "Additional tags for the resource"
  type        = map(string)
}

# Project and environment variables
variable "project" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

# AWS region
variable "region" {
  description = "AWS region to deploy the resources"
  type        = string
}

# KMS key ID for encryption
variable "kms_key_id" {
  description = "The KMS key ID to use for server-side encryption"
  type        = string
}
