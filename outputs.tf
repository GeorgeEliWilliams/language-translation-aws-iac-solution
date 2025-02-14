output "request_bucket_name" {
  value = module.request_bucket.bucket_name
}

output "response_bucket_name" {
  value = module.response_bucket.bucket_name
}

output "lambda_function_name" {
  description = "Lambda function name"
  value       = module.lambda.function_name
}

output "api_gateway_url" {
  description = "Base URL for API Gateway"
  value       = module.api_gateway.api_gateway_endpoint
}
