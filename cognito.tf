resource "aws_cognito_user_pool" "user_pool" {
  name = "${var.name_prefix}-user-pool-${terraform.workspace}"

  username_attributes = ["email"]

  auto_verified_attributes = ["email"]

  password_policy {
    minimum_length    = 8
    require_uppercase = true
    require_lowercase = true
    require_numbers   = true
    require_symbols   = false
  }
}

resource "aws_cognito_user_pool_client" "app" {
  name         = "${var.name_prefix}-app-client-${terraform.workspace}"
  user_pool_id = aws_cognito_user_pool.user_pool.id

  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code"] # Use Authorization Code Flow
  allowed_oauth_scopes = concat(
  ["openid", "profile", "email"])

  callback_urls = [
    var.dev_callback_url, # for local dev
    var.prod_callback_url # for production
  ]

  logout_urls = [
    var.dev_logout_url,
    var.prod_logout_url
  ]

  supported_identity_providers = ["COGNITO"]

  prevent_user_existence_errors = "ENABLED"
}

resource "aws_cognito_user_pool_domain" "domain" {
  domain       = "${var.cognito_auth_domain}-auth-${terraform.workspace}"
  user_pool_id = aws_cognito_user_pool.user_pool.id
}

resource "aws_api_gateway_authorizer" "cognito" {
  name                   = "cognito-authorizer"
  rest_api_id            = "" # Link to API Resource if needed
  authorizer_uri         = "" # Not needed for Cognito, see next
  authorizer_credentials = null
  type                   = "COGNITO_USER_POOLS"
  provider_arns          = [aws_cognito_user_pool.user_pool.arn]
  identity_source        = "method.request.header.Authorization"
}