resource "aws_ssm_parameter" "cloudfront_distribution_id" {
  name        = "/${var.name_prefix}/${local.workspace_safe}/cconfig"
  description = "CloudFront distribution ID and Cognito for Frontend Usagefor ${var.name_prefix}"
  type        = "String"
  overwrite   = true

  value = jsonencode({
    cloudfront_distribution_id = aws_cloudfront_distribution.s3_distribution.id
    cognito_user_pool_id       = aws_cognito_user_pool.user_pool.id
    cognito_app_client_id      = aws_cognito_user_pool_client.app.id
  })
}