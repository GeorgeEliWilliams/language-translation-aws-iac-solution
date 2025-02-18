# ---------------------------------------------------------------------------------------------------------------------
# S3 BUCKET CONFIGURATION - STORES TRANSLATION REQUESTS AND RESPONSES
# This section defines an S3 bucket with encryption, public access restrictions, and 
# an IAM bucket policy to control access.
# ---------------------------------------------------------------------------------------------------------------------

# Create the S3 bucket with the specified name and tags
resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name # Assign the name from the module input variable

  # Tagging the bucket for better resource management
  tags = merge(
    var.tags,
    {
      Name = "${var.project}-${var.environment}-Bucket" # Standardized naming convention
    }
  )
}

# ---------------------------------------------------------------------------------------------------------------------
# SERVER-SIDE ENCRYPTION - ENFORCE DATA SECURITY USING KMS
# Enables encryption for all objects stored in the S3 bucket using an AWS KMS key.
# This ensures that all data at rest remains secure.
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_key_id # Use the provided KMS key for encryption
      sse_algorithm     = "aws:kms" # Use AWS Key Management Service (KMS)
    }
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# PUBLIC ACCESS BLOCK - RESTRICT PUBLIC ACCESS TO THE S3 BUCKET
# Enforces security best practices by blocking any public access to the bucket.
# This ensures the data is only accessible through IAM policies.
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = true  # Prevent public ACLs from being added
  block_public_policy     = true  # Prevent a public bucket policy
  ignore_public_acls      = true  # Ignore any public ACLs that may exist
  restrict_public_buckets = true  # Ensure that the bucket is not publicly accessible
}

# ---------------------------------------------------------------------------------------------------------------------
# S3 BUCKET POLICY - ATTACH CUSTOM POLICY TO CONTROL ACCESS
# Attaches the IAM policy defined in `data.tf` to the S3 bucket.
# This policy allows AWS Lambda to write objects to the bucket.
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.this.json # Attach the generated IAM policy
}
