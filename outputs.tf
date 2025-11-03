output "api_invoke_url" {
  value = "https://${aws_api_gateway_rest_api.api.id}.execute-api.${provider.aws.region}.amazonaws.com/${local.workspace_safe}"
}