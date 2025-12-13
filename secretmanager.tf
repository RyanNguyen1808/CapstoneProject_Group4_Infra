resource "aws_secretsmanager_secret" "mysql" {
  name        = "${var.name_prefix}-${local.workspace_safe}/rds/mysql/admin"
  description = "RDS MySQL admin credentials"
}

resource "aws_secretsmanager_secret_version" "mysql" {
  secret_id = aws_secretsmanager_secret.mysql.id

  secret_string = jsonencode({
    username = "admin"
    password = random_password.mysql.result
  })
}