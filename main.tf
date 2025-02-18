# ---------------------------------------------------------------------------------------------------------------------
# S3 BUCKETS - REQUEST & RESPONSE STORAGE
# These modules create two Amazon S3 buckets:
# 1. `request_bucket`: Stores original translation requests.
# 2. `response_bucket`: Stores translated responses and logs.
# Both buckets are encrypted using AWS KMS for security.
# ---------------------------------------------------------------------------------------------------------------------

module "request_bucket" {
  source                = "./modules/s3"                     # Path to the S3 module
  bucket_name           = var.request_bucket                # Name of the request bucket
  kms_key_id            = module.kms_key.key_arn            # KMS encryption key for bucket encryption
  tags                  = var.tags                          # Tags for resource identification
  project               = var.project                       # Project name for grouping resources
  environment           = var.environment                   # Environment (e.g., dev, staging, prod)
  region                = var.region                        # AWS region where the bucket will be deployed
  bucket_policy_actions = var.request_bucket_policy_actions # List of allowed actions for bucket policy
}

module "response_bucket" {
  source                = "./modules/s3"                     # Path to the S3 module
  bucket_name           = var.response_bucket                # Name of the response bucket
  kms_key_id            = module.kms_key.key_arn             # KMS encryption key for bucket encryption
  tags                  = var.tags                           # Tags for resource identification
  project               = var.project                        # Project name for grouping resources
  environment           = var.environment                    # Environment (e.g., dev, staging, prod)
  region                = var.region                         # AWS region where the bucket will be deployed
  bucket_policy_actions = var.reponse_bucket_policy_actions  # List of allowed actions for bucket policy
}

# ---------------------------------------------------------------------------------------------------------------------
# AWS LAMBDA FUNCTION - TRANSLATION PROCESSOR
# This module deploys an AWS Lambda function that:
# - Reads text input from API Gateway.
# - Translates text using AWS Translate.
# - Saves translation requests to the "requests" bucket.
# - Saves translation results and logs to the "responses" bucket.
# ---------------------------------------------------------------------------------------------------------------------

module "lambda" {
  source              = "./modules/lambda"       # Path to the Lambda module
  function_name       = var.function_name        # Name of the Lambda function
  function_handler    = var.function_handler     # Handler function inside the Lambda script
  request_bucket      = module.request_bucket.bucket_name   # Pass the request bucket name to Lambda
  response_bucket     = module.response_bucket.bucket_name  # Pass the response bucket name to Lambda
  request_bucket_arn  = module.request_bucket.bucket_arn    # ARN of the request bucket
  response_bucket_arn = module.response_bucket.bucket_arn   # ARN of the response bucket
  tags                = var.tags                 # Tags for resource identification
  project             = var.project              # Project name for grouping resources
  environment         = var.environment          # Environment (e.g., dev, staging, prod)
  region              = var.region               # AWS region where the Lambda function is deployed
  kms_key_id          = module.kms_key.key_arn   # KMS encryption key for secure storage
}

# ---------------------------------------------------------------------------------------------------------------------
# AWS KMS - KEY MANAGEMENT SERVICE
# This module creates a KMS key to:
# - Encrypt S3 bucket data at rest.
# - Provide secure key management and access control.
# - Allow defined users and services to use the encryption key.
# ---------------------------------------------------------------------------------------------------------------------

module "kms_key" {
  source      = "./modules/kms"      # Path to the KMS module
  tags        = var.tags             # Tags for resource identification
  project     = var.project          # Project name for grouping resources
  environment = var.environment      # Environment (e.g., dev, staging, prod)
  region      = var.region           # AWS region where the key is deployed
  kms_vars    = var.kms_vars         # KMS-specific configuration variables
  aliases     = var.aliases          # Aliases for easier key management
  key_owners  = var.key_owners       # Users or roles with full key management rights
  key_admins  = var.key_admins       # Users or roles with administrative access
  key_users   = var.key_users        # Users or roles with encryption and decryption permissions
}

# ---------------------------------------------------------------------------------------------------------------------
# API GATEWAY - PUBLIC ENDPOINT FOR TRANSLATION REQUESTS
# This module sets up an API Gateway to:
# - Expose the Lambda function as a publicly accessible HTTP endpoint.
# - Route incoming translation requests to Lambda.
# - Secure the endpoint using KMS.
# ---------------------------------------------------------------------------------------------------------------------

module "api_gateway" {
  source                 = "./modules/api_gateway"         # Path to the API Gateway module
  tags                   = var.tags                        # Tags for resource identification
  project                = var.project                     # Project name for grouping resources
  environment            = var.environment                 # Environment (e.g., dev, staging, prod)
  region                 = var.region                      # AWS region where API Gateway is deployed
  lambaFunctionInvokeArn = module.lambda.function_invoke_arn  # ARN of the Lambda function for API invocation
  lambdaFunctionName     = module.lambda.function_name        # Name of the Lambda function
  kms_key_id             = module.kms_key.key_arn             # KMS encryption key for API security
  api_gateway_method     = var.api_gateway_method            # HTTP method (e.g., POST)
  api_gateway_route      = var.api_gateway_route             # API route (e.g., "/translate")
}
