variable "bucket_name" {
  description = "The name of the S3 bucket to create"
  type        = string
}

variable "kms_key_id" {
  description = "The KMS key ID to use for server-side encryption"
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

variable "bucket_policy_actions" {
  description = "List of actions to allow in the bucket policy"
  type        = list(string)
}
