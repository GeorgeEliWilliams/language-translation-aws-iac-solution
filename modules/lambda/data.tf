# This data block compresses the lambda_translate.py script into a ZIP file.
data "archive_file" "this" {
  type        = "zip"
  source_file = "${path.module}/lambda_translate.py"  # Path to the Lambda function script
  output_path = "${path.module}/lambda_translate.zip" # Path for the generated ZIP file
}

# Fetches the AWS caller identity (account ID, ARN, user ID)
data "aws_caller_identity" "this" {}

# IAM policy document that defines a trust relationship for Lambda execution role
data "aws_iam_policy_document" "this" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"] # Allows AWS Lambda to assume the role
    }
    actions = ["sts:AssumeRole"]
  }
}
