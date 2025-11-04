# CapstoneProject_Group4_Infra

## REPO SECRETS
* AWS_ACCESS_KEY_ID_NTU = **your-access-key-id**
* AWS_SECRET_ACCESS_KEY_NTU = **your-secret-access-key**
* AWS_REGION = **us-east-1**
* DEV_ALLOWED_ORIGIN = *
* PROD_ALLOWED_ORIGIN = *

## REPO VARIABLES
* S3_BUCKET_FOR_TF_STATE_FILE = **ce11-capstone-group4**

## INSERT INTO DYNAMO DB TABLE
aws dynamodb put-item \
    --table-name ce11-capstone-group4-cards-sandbox-ryannguyen1808 \
    --item '{
        "CARD_NUMBER": {"S": "123456789"},
        "BALANCE": {"N": "0"}
    }' \
    --region us-east-1

## TEST API
curl -X POST \
  https://jkqz42pkd2.execute-api.us-east-1.amazonaws.com/sandbox-ryannguyen1808/cards/123456789/topup \
  -H "Content-Type: application/json" \
  -d '{"amount": 50}'