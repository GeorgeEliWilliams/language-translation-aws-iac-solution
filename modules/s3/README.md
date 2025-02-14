# S3 Module

This module creates two Amazon S3 buckets for the translation service:

- **request Bucket**: Stores incoming translation request.
- **response Bucket**: Stores translated response and logs.

## Outputs

- `request_bucket_name`: The name of the translation request bucket.
- `response_bucket_name`: The name of the translation response bucket.

## Security Features

- Blocks all public access.
- Only allows AWS Lambda to write to the request bucket.
- Only allows AWS Lambda to write and read from the response bucket.
