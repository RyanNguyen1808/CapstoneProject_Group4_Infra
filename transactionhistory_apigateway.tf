# API Resource for /card/get
resource "aws_api_gateway_resource" "getTransactionHistory" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_resource.card.id
  path_part   = "get"
}

# # POST method
resource "aws_api_gateway_method" "getTransactionHistory_post" {
  # checkov:skip=CKV_AWS_59:Ensure there is no open access to back-end resources through API - Not Compliant
  # checkov:skip=CKV2_AWS_53:Ensure AWS API gateway request is validated - Not Compliant
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.getTransactionHistory.id
  http_method   = "POST"
  authorization = "NONE"
  #   authorization = "COGNITO_USER_POOLS"
  #   authorizer_id = aws_api_gateway_authorizer.cognito.id
}

# Integration with Lambda
resource "aws_api_gateway_integration" "getTransactionHistory_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.getTransactionHistory.id
  http_method             = aws_api_gateway_method.getTransactionHistory_post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.getTransactionHistory_lambda.invoke_arn
}

# Lambda permission
resource "aws_lambda_permission" "apigw_getTransactionHistory" {
  statement_id  = "AllowAPIGatewayInvokeGetTransactionHistory"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.getTransactionHistory_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/POST/card/get"
}