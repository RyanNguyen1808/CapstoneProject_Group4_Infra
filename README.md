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
    --table-name {OUTPUT cards_table_name} \
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
aws s3 sync . s3://{OUTPUT s3_bucket_name}

aws cloudfront create-invalidation --distribution-id {OUTPUT cloudfront_distribution_id} --path "/index.html"

## Create User in Cognito
aws cognito-idp admin-create-user \
  --user-pool-id <YOUR_USER_POOL_ID> \
  --username <EMAIL_OR_USERNAME> \
  --user-attributes Name=email,Value=<EMAIL_ADDRESS>

## Change Password
aws cognito-idp admin-set-user-password \
  --user-pool-id <YOUR_USER_POOL_ID> \
  --username <EMAIL_OR_USERNAME> \
  --password "<STRONG_PASSWORD>" \
  --permanent

## Get Token Access
aws cognito-idp initiate-auth \
  --auth-flow USER_PASSWORD_AUTH \
  --client-id <YOUR_APP_CLIENT_ID> \
  --auth-parameters USERNAME=<USERNAME>,PASSWORD=<PASSWORD>