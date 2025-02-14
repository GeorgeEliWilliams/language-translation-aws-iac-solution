variable "project" {
  description = "Project name"
  type        = string
  default     = "aws-translate"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "region" {
  description = "AWS region to deploy the resources"
  type        = string
  default     = "us-east-1"
}

variable "tags" {
  description = "Additional tags for the resource"
  type        = map(string)
  default = {
    CreatedBy = "George"
  }
}

variable "kms_vars" {
  type = map(any)
  default = {
    description              = "Project KMS key"
    deletion_window_in_days  = 30
    enable_key_rotation      = true
    key_usage                = "ENCRYPT_DECRYPT"
    customer_master_key_spec = "SYMMETRIC_DEFAULT"
  }
}

variable "aliases" {
  description = "List of aliases to assign to the KMS key (e.g., [\"alias/my-key\"])"
  type        = list(string)
  default = [
    "alias/translate-key",
  ]
}

variable "key_owners" {
  description = "List of IAM principal ARNs that will have full control over the key"
  type        = list(string)
  default = [
    "arn:aws:iam::314146303416:user/Eli_George",
  ]
}

variable "key_admins" {
  description = "List of IAM principal ARNs that can administer the key (e.g., modify key settings)"
  type        = list(string)
  default     = []
}

variable "key_users" {
  description = "List of IAM principal ARNs that are allowed to use the key for encryption/decryption"
  type        = list(string)
  default     = []
}

variable "function_name" {
  description = "The name of the Lambda function"
  type        = string
  default     = "translate-function"
}

variable "function_handler" {
  description = "The name of the function handler"
  type        = string
  default     = "lambda_translate.lambda_handler"
}

variable "request_bucket" {
  description = "The name of the S3 bucket where translation request are stored"
  type        = string
  default     = "request-bucket-store007"
}

variable "response_bucket" {
  description = "The name of the S3 bucket where translation response are stored"
  type        = string
  default     = "response-bucket-store007"
}

variable "request_bucket_policy_actions" {
  description = "List of actions to allow in the bucket policy"
  type        = list(string)
  default     = ["s3:PutObject"]
}

variable "reponse_bucket_policy_actions" {
  description = "List of actions to allow in the bucket policy"
  type        = list(string)
  default     = ["s3:PutObject", "s3:GetObject"]
}
