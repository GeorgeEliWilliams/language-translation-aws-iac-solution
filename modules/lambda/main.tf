resource "aws_lambda_function" "this" {
  function_name    = var.function_name
  handler          = var.function_handler
  kms_key_arn      = var.kms_key_id
  memory_size      = 128
  package_type     = "Zip"
  role             = aws_iam_role.this.arn
  runtime          = "python3.12"
  filename         = "${path.module}/lambda_translate.zip"
  source_code_hash = data.archive_file.this.output_base64sha256

  tracing_config {
    mode = "Active"
  }

  environment {
    variables = {
      REQUEST_BUCKET  = var.request_bucket
      RESPONSE_BUCKET = var.response_bucket
    }
  }

  logging_config {
    log_format = "Text"
    log_group  = aws_cloudwatch_log_group.this.name
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.project}-${var.environment}-LambdaFunction"
    }
  )

  depends_on = [
    aws_cloudwatch_log_group.this,
  ]
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = 1
  kms_key_id        = var.kms_key_id

  tags = merge(
    var.tags,
    {
      Name = "${var.project}-${var.environment}-Lambda-LogGroup"
    }
  )
}
