# ---------------------------------------------------------------------------------------------------------------------
# IAM POLICY DOCUMENT - DEFINE ACCESS CONTROL FOR THE S3 BUCKET
# This policy allows AWS Lambda to perform the specified actions (e.g., s3:PutObject)
# on objects within the bucket. The policy ensures that only Lambda has write access.
# ---------------------------------------------------------------------------------------------------------------------

data "aws_iam_policy_document" "this" {
  statement {
    actions   = var.bucket_policy_actions # Allowed actions (e.g., "s3:PutObject", "s3:GetObject")
    resources = ["${aws_s3_bucket.this.arn}/*"] # Grant access to all objects in the bucket

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"] # Restrict access to AWS Lambda only
    }
  }
}
