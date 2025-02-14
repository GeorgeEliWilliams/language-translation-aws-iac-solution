module "request_bucket" {
  source                = "./modules/s3"
  bucket_name           = var.request_bucket
  kms_key_id            = module.kms_key.key_arn
  tags                  = var.tags
  project               = var.project
  environment           = var.environment
  region                = var.region
  bucket_policy_actions = var.request_bucket_policy_actions
}

module "response_bucket" {
  source                = "./modules/s3"
  bucket_name           = var.response_bucket
  kms_key_id            = module.kms_key.key_arn
  tags                  = var.tags
  project               = var.project
  environment           = var.environment
  region                = var.region
  bucket_policy_actions = var.reponse_bucket_policy_actions
}

# Lambda Module - Deploys the function that performs translations
module "lambda" {
  source              = "./modules/lambda"
  function_name       = var.function_name
  function_handler    = var.function_handler
  request_bucket      = module.request_bucket.bucket_name
  response_bucket     = module.response_bucket.bucket_name
  request_bucket_arn  = module.request_bucket.bucket_arn
  response_bucket_arn = module.response_bucket.bucket_arn
  tags                = var.tags
  project             = var.project
  environment         = var.environment
  region              = var.region
  kms_key_id          = module.kms_key.key_arn
}

module "kms_key" {
  source      = "./modules/kms"
  tags        = var.tags
  project     = var.project
  environment = var.environment
  region      = var.region
  kms_vars    = var.kms_vars
  aliases     = var.aliases
  key_owners  = var.key_owners
  key_admins  = var.key_admins
  key_users   = var.key_users
}

# API Gateway Module - Exposes the Lambda function via an HTTP endpoint
module "api_gateway" {
  source                 = "./modules/api_gateway"
  tags                   = var.tags
  project                = var.project
  environment            = var.environment
  region                 = var.region
  lambaFunctionInvokeArn = module.lambda.function_invoke_arn
  lambdaFunctionName     = module.lambda.function_name
  kms_key_id             = module.kms_key.key_arn
}
