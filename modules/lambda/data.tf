data "archive_file" "this" {
  type        = "zip"
  source_file = "${path.module}/lambda_translate.py"
  output_path = "${path.module}/lambda_translate.zip"
}

data "aws_caller_identity" "this" {

}

data "aws_iam_policy_document" "this" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}
