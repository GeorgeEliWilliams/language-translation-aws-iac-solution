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

variable "lambaFunctionInvokeArn" {
  description = "ARN of the Lambda function to invoke"
  type        = string
}

variable "lambdaFunctionName" {
  description = "Name of the Lambda function"
  type        = string
}

variable "kms_key_id" {
  description = "The KMS key ID to use for server-side encryption"
  type        = string
}

variable "api_gateway_method" {
  description = "HTTP method for the API Gateway"
  type        = string
}

variable "api_gateway_route" {
  description = "Route key for the API Gateway"
  type        = string
}