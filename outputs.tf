# Output the name of the S3 bucket where translation requests are stored
output "request_bucket_name" {
  description = "The name of the S3 bucket used for storing translation requests"
  value       = module.request_bucket.bucket_name
}

# Output the name of the S3 bucket where translation responses and logs are stored
output "response_bucket_name" {
  description = "The name of the S3 bucket used for storing translation responses"
  value       = module.response_bucket.bucket_name
}

# Output the name of the deployed AWS Lambda function
output "lambda_function_name" {
  description = "The name of the AWS Lambda function responsible for translation processing"
  value       = module.lambda.function_name
}

# Output the API Gateway endpoint URL for making translation requests
output "api_gateway_url" {
  description = "The base URL of the API Gateway used to invoke the Lambda function"
  value       = module.api_gateway.api_gateway_endpoint
}