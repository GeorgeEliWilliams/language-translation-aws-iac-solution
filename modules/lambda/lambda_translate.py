import json
import boto3
import os
import logging
import re
import uuid
from datetime import datetime

# Configure logging for debugging and monitoring
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Initialize AWS clients for Translate and S3
translate = boto3.client("translate")
s3 = boto3.client("s3")


def lambda_handler(event, context):
    """
    AWS Lambda function to translate text using AWS Translate.
    
    - Accepts input from API Gateway.
    - Extracts source and target languages, along with the text to be translated.
    - Logs requests and responses in S3 for tracking.
    - Returns translated text and logs the translation request/response.
    
    Expected JSON input:
    {
        "source_language": "en",
        "target_language": "fr",
        "sentences_file": {
            "text": "Hello. How are you? This is a test."
        }
    }

    Returns:
        JSON response with translated text and metadata.
    """

    # Log the incoming event from API Gateway
    logger.info("Lambda function triggered with event: " + json.dumps(event))

    # Generate a timestamp and unique ID for request tracking
    timestamp = datetime.utcnow().strftime("%Y%m%dT%H%M%SZ")
    unique_id = str(uuid.uuid4())
    logger.info(f"Generated timestamp: {timestamp} and unique_id: {unique_id}")

    try:
        # Parse the JSON request body
        body = json.loads(event.get("body", "{}"))
        logger.info("Parsed request body: " + json.dumps(body))

        # Extract required parameters from the request
        source_lang = body.get("source_language")
        target_lang = body.get("target_language")

        # Allow text input in both direct and nested formats
        text = body.get("text") or body.get("sentences_file", {}).get("text")

        # Validate input: Ensure source language, target language, and text are provided
        if not (source_lang and target_lang and text):
            logger.error(
                "Invalid input JSON: Missing one or more required fields (source_language, target_language, text)"
            )
            return {
                "statusCode": 400,
                "body": json.dumps({"error": "Invalid input JSON format"})
            }
        logger.info("Input validation passed.")

        # Retrieve S3 bucket names from environment variables
        request_bucket = os.getenv("REQUEST_BUCKET")
        response_bucket = os.getenv("RESPONSE_BUCKET")

        # Validate that required environment variables are set
        if not request_bucket or not response_bucket:
            logger.error("Missing required environment variables: REQUEST_BUCKET or RESPONSE_BUCKET")
            return {
                "statusCode": 500,
                "body": json.dumps({"error": "Missing required environment variables"})
            }
        logger.info(f"Using request_bucket: {request_bucket} and response_bucket: {response_bucket}")

        # Upload the original request JSON to the "requests" S3 bucket
        request_key = f"request_{timestamp}_{unique_id}.json"
        s3.put_object(
            Bucket=request_bucket,
            Key=request_key,
            Body=json.dumps(body),
            ContentType="application/json"
        )
        logger.info(f"Uploaded original request to {request_bucket}/{request_key}")

        # Split the input text into sentences using regex (preserving punctuation)
        sentences = re.split(r'(?<=[.!?]) +', text)
        logger.info(f"Split text into {len(sentences)} sentences.")

        translated_sentences = []  # Store translated sentences
        translation_errors = []  # Store any translation failures

        # Process each sentence for translation
        for sentence in sentences:
            if sentence.strip():  # Ignore empty sentences
                try:
                    logger.info(f"Translating sentence: {sentence}")
                    
                    # Call AWS Translate API to translate the sentence
                    result = translate.translate_text(
                        Text=sentence,
                        SourceLanguageCode=source_lang,
                        TargetLanguageCode=target_lang
                    )
                    translated_sentence = result.get("TranslatedText")
                    logger.info(f"Translated sentence: {translated_sentence}")

                    translated_sentences.append(translated_sentence)
                except Exception as e:
                    # Handle translation errors
                    logger.error(f"Translation failed for sentence: {sentence}. Error: {str(e)}")
                    translation_errors.append({"sentence": sentence, "error": str(e)})
                    
                    # Append the original sentence if translation fails
                    translated_sentences.append(sentence)

        # Reassemble translated sentences into one output string
        full_translated_text = " ".join(translated_sentences)
        logger.info("Reassembled full translated text.")

        # Create a structured log containing original request, translation metadata, and errors
        log_data = {
            "original_request": body,
            "translation_errors": translation_errors,
            "metadata": {
                "timestamp": timestamp,
                "unique_id": unique_id,
                "sentence_count": len(sentences)
            }
        }
        logger.info("Created comprehensive log data.")

        # Create the final response structure
        response_data = {
            "translated_text": full_translated_text,
            "translation_log": log_data
        }

        # Upload the response data and logs to the "responses" S3 bucket
        response_key = f"response_{timestamp}_{unique_id}.json"
        s3.put_object(
            Bucket=response_bucket,
            Key=response_key,
            Body=json.dumps(response_data),
            ContentType="application/json"
        )
        logger.info(f"Uploaded response to {response_bucket}/{response_key}")

        logger.info("Workflow completed successfully.")

        # Return a structured API Gateway response with the translated text
        return {
            "statusCode": 200,
            "body": json.dumps({
                "message": "Translation complete",
                "translated_text": full_translated_text,
                "translation_log": log_data
            })
        }

    except Exception as e:
        # Catch any unexpected errors
        logger.exception("Error processing the translation")
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})
        }
