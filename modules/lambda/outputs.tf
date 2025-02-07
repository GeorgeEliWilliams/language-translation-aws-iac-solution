output "lambda_arn" {
  description = "The ARN of the created Lambda function"
  value       = aws_lambda_function.translate_lambda.arn
}

output "lambda_function_name" {
  description = "The name of the Lambda function"
  value       = aws_lambda_function.translate_lambda.function_name
}

output "lambda_invoke_arn" {
  description = "Invoke ARN of the Lambda function"
  value       = aws_lambda_function.translate_lambda.invoke_arn
}
