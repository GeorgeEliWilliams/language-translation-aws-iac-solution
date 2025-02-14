import json
import boto3
import os
import logging

# Configure logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Initialize AWS service clients
translate = boto3.client("translate")
s3 = boto3.client("s3")


def lambda_handler(event, context):
    try:
        # Retrieve S3 bucket names from environment variables using os.getenv to avoid KeyErrors.
        request_bucket = os.getenv("REQUEST_BUCKET")
        response_bucket = os.getenv("RESPONSE_BUCKET")
        if not request_bucket or not response_bucket:
            logger.error(
                "Missing required environment variables: REQUEST_BUCKET or RESPONSE_BUCKET")
            return {
                "statusCode": 500,
                "body": json.dumps({"error": "Missing required environment variables"})
            }

        # Validate event structure and extract S3 event details.
        records = event.get("Records", [])
        if not records:
            logger.error("Event does not contain any records")
            return {
                "statusCode": 400,
                "body": json.dumps({"error": "Event does not contain any records"})
            }

        record = records[0]
        input_bucket = record.get("s3", {}).get("bucket", {}).get("name")
        input_key = record.get("s3", {}).get("object", {}).get("key")
        if not input_bucket or not input_key:
            logger.error("Input bucket or object key missing in event")
            return {
                "statusCode": 400,
                "body": json.dumps({"error": "Missing S3 bucket or key in event"})
            }

        logger.info(
            f"Processing file '{input_key}' from bucket '{input_bucket}'")

        # Download and decode the input file from S3.
        s3_response = s3.get_object(Bucket=input_bucket, Key=input_key)
        text_data = json.loads(s3_response["Body"].read().decode("utf-8"))

        # Validate the input JSON for required fields.
        source_lang = text_data.get("source_language")
        target_lang = text_data.get("target_language")
        text = text_data.get("text")
        if not (source_lang and target_lang and text):
            logger.error(
                "Invalid input JSON: Missing one or more required fields (source_language, target_language, text)")
            return {
                "statusCode": 400,
                "body": json.dumps({"error": "Invalid input JSON format"})
            }

        # Perform translation using AWS Translate.
        translation_result = translate.translate_text(
            Text=text,
            SourceLanguageCode=source_lang,
            TargetLanguageCode=target_lang
        )
        translated_text = translation_result.get("TranslatedText")
        if not translated_text:
            logger.error("Translation failed or returned no result")
            return {
                "statusCode": 500,
                "body": json.dumps({"error": "Translation failed"})
            }

        # Save the translated text to the response bucket.
        output_key = f"translated_{input_key}"
        s3.put_object(
            Bucket=response_bucket,
            Key=output_key,
            Body=json.dumps({"translated_text": translated_text}),
            ContentType="application/json"
        )
        logger.info(
            f"Translation complete. Output stored as '{output_key}' in bucket '{response_bucket}'")

        return {
            "statusCode": 200,
            "body": json.dumps({
                "message": "Translation complete",
                "translated_text": translated_text
            })
        }

    except Exception as e:
        logger.exception("Error processing the translation")
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})
        }
