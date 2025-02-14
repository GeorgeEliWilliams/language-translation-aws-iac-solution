resource "aws_iam_role" "this" {
  name = "${var.project}-${var.environment}-LambdaRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })

  tags = merge(
    var.tags,
    {
      Name = "${var.project}-${var.environment}-LambdaRole"
    }
  )
}

resource "aws_iam_policy" "this" {
  name = "${var.project}-${var.environment}-LambdaPolicy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid = "LogPolicies"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Effect   = "Allow",
        Resource = "arn:aws:logs:${var.region}:${data.aws_caller_identity.this.account_id}:log-group:/aws/lambda/${aws_lambda_function.this.function_name}:*"
      },
      {
        Sid = "S3Policies"
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ],
        Effect = "Allow",
        Resource = [
          "${var.request_bucket_arn}/*",
          "${var.response_bucket_arn}/*",
          "${var.request_bucket_arn}",
          "${var.response_bucket_arn}",
        ]
      },
      {
        Sid = "TranslatePolicies"
        Action = [
          "translate:TranslateText"
        ],
        Effect   = "Allow",
        Resource = "*" # Lambda can translate any text
      },
      {
        Sid = "KMSPolicies"
        Action = [
          "kms:Decrypt",
          "kms:GenerateDataKey"
        ],
        Effect   = "Allow",
        Resource = "*" # Lambda can translate any text
      }
    ]
  })

  tags = {
    Name = "this-TeamsAlert-lambdaPolicy"
  }
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
