resource "aws_iam_role" "lambda_exec" {
  name = "${var.name_prefix}-lambda-api-executionrole-${local.workspace_safe}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_exec_role" {
  # checkov:skip=CKV_AWS_355:Ensure no IAM policies documents allow "*" as a statement's resource for restrictable actions - Not Compliant
  # checkov:skip=CKV_AWS_290:Ensure IAM policies does not allow write access without constraints - Not Compliant
  name = "${var.name_prefix}-lamda-api-ddbaccess-${local.workspace_safe}"

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "dynamodb:GetItem",
                "dynamodb:PutItem",
                "dynamodb:DeleteItem",
                "dynamodb:Scan"
            ],
            "Resource": [
                "${aws_dynamodb_table.cards.arn}"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "*"
        }
    ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.lambda_exec_role.arn
}