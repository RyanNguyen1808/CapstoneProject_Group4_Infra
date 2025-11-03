import json


def lambda_handler(event, context):
    # Example response
    return {"statusCode": 200, "body": json.dumps({"message": "Top-up successful"})}
