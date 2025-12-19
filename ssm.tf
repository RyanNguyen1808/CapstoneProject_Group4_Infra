resource "aws_ssm_parameter" "cloudfront_distribution_id" {
  # checkov:skip=CKV2_AWS_34: "AWS SSM Parameter should be Encrypted"
  name        = "/${var.name_prefix}/${local.workspace_safe}/cconfig"
  description = "CloudFront distribution ID and Cognito for Frontend Usagefor ${var.name_prefix}"
  type        = "String"
  overwrite   = true

  value = jsonencode({
    cloudfront_distribution_id = aws_cloudfront_distribution.s3_distribution.id
    cognito_user_pool_id       = aws_cognito_user_pool.user_pool.id
    cognito_app_client_id      = aws_cognito_user_pool_client.app.id
    base_url                   = "https://${aws_api_gateway_domain_name.custom.domain_name}"
  })
}