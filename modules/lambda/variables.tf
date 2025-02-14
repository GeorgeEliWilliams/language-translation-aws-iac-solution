variable "function_name" {
  description = "The name of the Lambda function"
  type        = string
}

variable "function_handler" {
  description = "The name of the function handler"
  type        = string
}

variable "request_bucket" {
  description = "The name of the S3 bucket where translation request are stored"
  type        = string
}

variable "response_bucket" {
  description = "The name of the S3 bucket where translation response are stored"
  type        = string
}

variable "request_bucket_arn" {
  description = "The name of the S3 bucket where translation request are stored"
  type        = string
}

variable "response_bucket_arn" {
  description = "The name of the S3 bucket where translation response are stored"
  type        = string
}

variable "tags" {
  description = "Additional tags for the resource"
  type        = map(string)
}

variable "project" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "region" {
  description = "AWS region to deploy the resources"
  type        = string
}

variable "kms_key_id" {
  description = "The KMS key ID to use for server-side encryption"
  type        = string
}
