resource "aws_api_gateway_rest_api" "api" {
  # checkov:skip=CKV_AWS_237:Ensure Create before destroy for API Gateway - Not Compliant
  name        = "${var.name_prefix}-api-${local.workspace_safe}"
  description = "API for Capstone Project"
}