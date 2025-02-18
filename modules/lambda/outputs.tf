# Outputs the ARN of the Lambda function
output "function_arn" {
  description = "The ARN of the created Lambda function"
  value       = aws_lambda_function.this.arn
}

# Outputs the name of the Lambda function
output "function_name" {
  description = "The name of the Lambda function"
  value       = aws_lambda_function.this.function_name
}

# Outputs the invoke ARN for API Gateway integrations
output "function_invoke_arn" {
  description = "Invoke ARN of the Lambda function"
  value       = aws_lambda_function.this.invoke_arn
}
