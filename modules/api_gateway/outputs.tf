# Output API Gateway ID
output "api_gateway_id" {
  description = "The ID of the API Gateway"
  value       = aws_apigatewayv2_api.this.id
}

# Output API Gateway Endpoint URL
output "api_gateway_endpoint" {
  value = aws_apigatewayv2_stage.this.invoke_url
}
