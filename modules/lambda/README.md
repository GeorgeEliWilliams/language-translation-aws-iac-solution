# README for the Lambda Module

 **Module Name:** `lambda`  
 **Purpose:** This Terraform module provisions an **AWS Lambda function** to process **translation requests**. It integrates with **S3 buckets**, **AWS Translate**, and **KMS encryption**.

---

## ** Features**
- ✅ Creates a **Lambda function** with Python 3.12.  
- ✅ Configures **IAM roles & policies** for security.  
- ✅ Enables **logging** with CloudWatch Logs.  
- ✅ Provides **KMS encryption** for secure data handling.  
- ✅ Supports **environment-specific deployments** via variables.  

---

## ** Module Structure**

lambda/ │── data.tf # Defines dependencies like IAM policy & archive file
- iam.tf # Creates IAM roles & permissions for Lambda
─ main.tf # Creates the Lambda function & CloudWatch logging
─ outputs.tf # Exports Lambda function details
─ variables.tf # Defines input variables for customization
─ README.md # Documentation for the module
─ lambda_translate.py # Python script for translation 

## ** Usage**
To use this module, include it in your Terraform configuration:

```hcl
module "lambda_translate" {
  source              = "./modules/lambda"
  function_name       = "translate-function"
  function_handler    = "lambda_translate.lambda_handler"
  request_bucket      = module.s3_request.bucket_name
  response_bucket     = module.s3_response.bucket_name
  request_bucket_arn  = module.s3_request.bucket_arn
  response_bucket_arn = module.s3_response.bucket_arn
  kms_key_id          = module.kms_key.key_arn
  tags                = var.tags
  project             = var.project
  environment         = var.environment
  region              = var.region
}