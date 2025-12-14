resource "aws_secretsmanager_secret" "mysql" {
  # checkov:skip=CKV_AWS_149: "Ensure that Secrets Manager secret is encrypted using KMS CMK"
  # checkov:skip=CKV2_AWS_57: "Ensure Secrets Manager secrets should have automatic rotation enabled"
  name                    = "${var.name_prefix}-${local.workspace_safe}/rds/mysql/admin"
  description             = "RDS MySQL admin credentials"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "mysql" {
  secret_id = aws_secretsmanager_secret.mysql.id

  secret_string = jsonencode({
    username = "admin"
    password = random_password.mysql.result
    host     = aws_db_instance.mysql.address
    database = aws_db_instance.mysql.db_name
    port     = aws_db_instance.mysql.port
  })
}