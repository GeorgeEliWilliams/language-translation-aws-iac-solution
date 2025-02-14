# IAM Policy Document for the request bucket
data "aws_iam_policy_document" "this" {
  statement {
    actions   = var.bucket_policy_actions # Allow writing files
    resources = ["${aws_s3_bucket.this.arn}/*"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"] # Only AWS Lambda can write
    }
  }
}
