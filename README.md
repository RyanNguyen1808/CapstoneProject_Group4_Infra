# CapstoneProject_Group4_Infra

## Overal Architecture 

![Overal Architecture](/images/Capstone_Project_Infra.JPG "This is Overal Architecture.")

## REPO SECRETS
* AWS_ACCESS_KEY_ID_NTU = **your-access-key-id**
* AWS_SECRET_ACCESS_KEY_NTU = **your-secret-access-key**
* AWS_REGION = **us-east-1**
* DEV_ALLOWED_ORIGIN = *
* PROD_ALLOWED_ORIGIN = *

## REPO VARIABLES
* S3_BUCKET_FOR_TF_STATE_FILE = **ce11-capstone-group4**

## As of xxx, the following components have been done
* S3 bucket for website
* Cloudfront Distribution linked to S3 Origin
* API Gateway for Topup Card linked to Lambda Topup Card
* DynamoDB for Cards
* DNS Records for website as well as custom domain for API Gateway

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
  {OUTPUT api_invoke_custom_url}/cards/123456789/topup \
  -H "Content-Type: application/json" \
  -d '{"amount": 50}'

## Sync website and invalidate the cache
aws s3 sync . s3://BUCKET_NAME

aws cloudfront create-invalidation --distribution-id DISTRIBUTION_ID --path "/index.html"