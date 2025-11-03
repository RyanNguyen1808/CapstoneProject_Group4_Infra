resource "aws_api_gateway_rest_api" "api" {
  # checkov:skip=CKV_AWS_237:Ensure Create before destroy for API Gateway - Not Compliant
  name        = "${var.name_prefix}-api-${local.workspace_safe}"
  description = "API for Capstone Project"
}

resource "aws_api_gateway_deployment" "vessel_tracking_api" {
  # checkov:skip=CKV_AWS_217: Ensure Create before destroy for API deployments - Not Compliant
  rest_api_id = aws_api_gateway_rest_api.api.id
  depends_on = [
    aws_api_gateway_method.topup_post,
  ]

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_method.topup_post.id,
    ]))
  }
}

resource "aws_api_gateway_stage" "api_stage" {
  # checkov:skip=CKV_AWS_76:Ensure API Gateway has Access Logging enabled - Not Compliant
  # checkov:skip=CKV_AWS_120:Ensure API Gateway caching is enabled - Not Compliant
  # checkov:skip=CKV_AWS_73:Ensure API Gateway has X-Ray Tracing enabled - Not Compliant
  # checkov:skip=CKV2_AWS_51:Ensure AWS API Gateway endpoints uses client certificate authentication - Not Compliant
  # checkov:skip=CKV2_AWS_4:Ensure API Gateway stage have logging level defined as appropriate - Not Compliant
  # checkov:skip=CKV2_AWS_29:Ensure public API gateway are protected by WAF - Not Compliant
  # Use the current workspace name for the stage name
  stage_name = terraform.workspace

  # The count argument is the key:
  # It creates this resource ONLY if the current workspace is 'dev' or 'prod'.
  # If you create another workspace like 'qa', it won't deploy a stage, 
  # but you can add it to the list here if needed.
  count = (contains(["dev", "prod"], local.workspace_safe) || startswith(local.workspace_safe, "sandbox-")) ? 1 : 0

  rest_api_id   = aws_api_gateway_rest_api.vessel_tracking_api.id
  deployment_id = aws_api_gateway_deployment.vessel_tracking_api.id
}