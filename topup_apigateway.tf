# API Resource for /card/topup
resource "aws_api_gateway_resource" "topup" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_resource.card.id
  path_part   = "topup"
}

# # POST method
resource "aws_api_gateway_method" "topup_post" {
  # checkov:skip=CKV_AWS_59:Ensure there is no open access to back-end resources through API - Not Compliant
  # checkov:skip=CKV2_AWS_53:Ensure AWS API gateway request is validated - Not Compliant
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.topup.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito.id
}

# Integration with Lambda
resource "aws_api_gateway_integration" "topup_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.topup.id
  http_method             = aws_api_gateway_method.topup_post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.topup_lambda.invoke_arn
}

resource "aws_api_gateway_method" "topup_options" {
  # checkov:skip=CKV2_AWS_53: "Ensure AWS API gateway request is validated"
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.topup.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "topup_options_mock" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.topup.id
  http_method = aws_api_gateway_method.topup_options.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_method_response" "topup_options_response_200" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.topup.id
  http_method = aws_api_gateway_method.topup_options.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
  }
}

resource "aws_api_gateway_integration_response" "topup_options_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.topup.id
  http_method = aws_api_gateway_method.topup_options.http_method
  status_code = aws_api_gateway_method_response.topup_options_response_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = "'${var.allowed_origin}'"
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS,POST'"
  }

  response_templates = {
    "application/json" = ""
  }
}