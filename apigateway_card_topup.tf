# API Resource for /cards
resource "aws_api_gateway_resource" "cards" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "cards"
}

# API Resource for /cards/{cardId}
resource "aws_api_gateway_resource" "card_id" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_resource.cards.id
  path_part   = "{cardId}"
}

# API Resource for /cards/{cardId}/topup
resource "aws_api_gateway_resource" "topup" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_resource.card_id.id
  path_part   = "topup"
}

# POST method
resource "aws_api_gateway_method" "topup_post" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.topup.id
  http_method   = "POST"
  authorization = "NONE"
}

# Integration with Lambda
resource "aws_api_gateway_integration" "topup_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.topup.id
  http_method             = aws_api_gateway_method.topup_post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.topup_card.invoke_arn
}

# Lambda permission
resource "aws_lambda_permission" "apigw_topup" {
  statement_id  = "AllowAPIGatewayInvokeTopup"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.topup_card.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/POST/cards/*/topup"
}
