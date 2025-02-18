resource "aws_iam_role" "this" {
  name               = "${var.project}-${var.environment}-API-GatewayLogRole"
  assume_role_policy = data.aws_iam_policy_document.this.json
}

resource "aws_iam_role_policy" "this" {
  name   = "${var.project}-${var.environment}-API-GatewayLogPolicy"
  role   = aws_iam_role.this.id
  policy = data.aws_iam_policy_document.logs.json
}