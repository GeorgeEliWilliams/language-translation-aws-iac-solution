# API Gateway Module

## Overview
This module sets up an API Gateway to expose an HTTP endpoint (`/translate`).  
The API Gateway connects to an AWS Lambda function to process translation request.

## Resources Created
- AWS API Gateway REST API
- API Resource (`/translate`)
- POST Method
- Lambda Integration
- API Deployment Stage (`dev`)

## Inputs
| Variable         | Description                          | Type   | Default         |
|-----------------|----------------------------------|--------|---------------|
| `api_name`      | Name of the API Gateway         | string | "TranslateAPI" |
| `api_description` | API description                | string | "API Gateway for the translation service" |
| `lambda_invoke_arn` | ARN of the Lambda function | string | N/A |

## Outputs
| Output Name     | Description                          |
|----------------|----------------------------------|
| `api_gateway_id` | The ID of the created API Gateway |
| `api_gateway_url` | The URL to invoke the API Gateway |

## Usage
To invoke the API, send a `POST` request to:
