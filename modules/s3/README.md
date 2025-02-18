# S3 Module

This Terraform module provisions an Amazon S3 bucket with server-side encryption using AWS KMS and applies an IAM policy to control access.


# Features
- Creates an S3 bucket with a unique name.
- Configures server-side encryption with an AWS KMS key for data security.
- Enforces IAM bucket policies to restrict access.
- Blocks public access to the bucket.
- Supports environment-specific deployments through variables.

## **📌 Usage**
To use this module, include it in your Terraform configuration:

```hcl
module "s3_bucket" {
  source                = "./modules/s3"
  bucket_name           = "example-bucket"
  kms_key_id            = module.kms_key.key_arn
  tags                  = var.tags
  project               = var.project
  environment           = var.environment
  region                = var.region
  bucket_policy_actions = ["s3:PutObject", "s3:GetObject"]
}