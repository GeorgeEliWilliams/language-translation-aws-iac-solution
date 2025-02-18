# General project settings
variable "project" {
  description = "Project name for tagging and resource organization"
  type        = string
  default     = "aws-translate"
}

variable "environment" {
  description = "Deployment environment (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "region" {
  description = "AWS region where resources will be deployed"
  type        = string
  default     = "eu-west-1"
}

# Tags for resource identification and tracking
variable "tags" {
  description = "Metadata tags to apply to all resources for better organization"
  type        = map(string)
  default = {
    CreatedBy = "George"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# KMS CONFIGURATION - MANAGE ENCRYPTION SETTINGS FOR SECURING S3 BUCKETS & OTHER RESOURCES
# ---------------------------------------------------------------------------------------------------------------------

variable "kms_vars" {
  description = "Configuration settings for the AWS Key Management Service (KMS) key"
  type        = map(any)
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

# IAM permissions for KMS key access
variable "key_owners" {
  description = "List of IAM principal ARNs that have full control over the KMS key"
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

# ---------------------------------------------------------------------------------------------------------------------
# AWS LAMBDA CONFIGURATION - TRANSLATION FUNCTION SETTINGS
# ---------------------------------------------------------------------------------------------------------------------

variable "function_name" {
  description = "The name of the AWS Lambda function responsible for translations"
  type        = string
  default     = "translate-function"
}

variable "function_handler" {
  description = "The handler function within the Lambda script (module.function)"
  type        = string
  default     = "lambda_translate.lambda_handler"
}

# ---------------------------------------------------------------------------------------------------------------------
# S3 BUCKET CONFIGURATION - STORAGE FOR TRANSLATION REQUESTS & RESPONSES
# ---------------------------------------------------------------------------------------------------------------------

variable "request_bucket" {
  description = "The S3 bucket for storing translation request payloads"
  type        = string
  default     = "request-bucket-store007"
}

variable "response_bucket" {
  description = "The S3 bucket for storing translation responses and logs"
  type        = string
  default     = "response-bucket-store007"
}

# Permissions for accessing S3 buckets
variable "request_bucket_policy_actions" {
  description = "List of allowed actions for the translation request bucket"
  type        = list(string)
  default     = ["s3:PutObject"]
}

variable "reponse_bucket_policy_actions" {
  description = "List of allowed actions for the translation response bucket"
  type        = list(string)
  default     = ["s3:PutObject", "s3:GetObject"]
}

# ---------------------------------------------------------------------------------------------------------------------
# API GATEWAY CONFIGURATION - EXPOSE LAMBDA FUNCTION VIA HTTP REQUESTS
# ---------------------------------------------------------------------------------------------------------------------

variable "api_gateway_method" {
  description = "The HTTP method to be used for API Gateway (e.g., GET, POST)"
  type        = string
  default     = "POST"
}

variable "api_gateway_route" {
  description = "The route path for the API Gateway endpoint"
  type        = string
  default     = "/translate"
}