resource "aws_apigatewayv2_api" "this" {
  name          = "${var.project}-${var.environment}-APIGateway"
  protocol_type = "HTTP"

  tags = merge(
    var.tags,
    {
      Name = "${var.project}-${var.environment}-APIGateway"
    }
  )
}

resource "aws_apigatewayv2_stage" "this" {
  api_id      = aws_apigatewayv2_api.this.id
  name        = var.environment
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.this.arn

    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
    })
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.project}-${var.environment}-APIGatewayStage"
    }
  )

  depends_on = [aws_cloudwatch_log_group.this]
}

resource "aws_apigatewayv2_integration" "this" {
  api_id             = aws_apigatewayv2_api.this.id
  integration_type   = "AWS_PROXY"
  integration_method = var.api_gateway_method
  integration_uri    = var.lambaFunctionInvokeArn
}

resource "aws_apigatewayv2_route" "this" {
  api_id    = aws_apigatewayv2_api.this.id
  route_key = "${var.api_gateway_method} ${var.api_gateway_route}"
  target    = "integrations/${aws_apigatewayv2_integration.this.id}"
}

resource "aws_lambda_permission" "this" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.lambdaFunctionName
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.this.execution_arn}/*/*${var.api_gateway_route}"
}

resource "aws_api_gateway_account" "this" {
  cloudwatch_role_arn = aws_iam_role.this.arn
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/api-gw/${aws_apigatewayv2_api.this.name}"
  retention_in_days = 7
  kms_key_id        = var.kms_key_id

  tags = merge(
    var.tags,
    {
      Name = "${var.project}-${var.environment}-APIGateWay-LogGroup"
    }
  )
}
