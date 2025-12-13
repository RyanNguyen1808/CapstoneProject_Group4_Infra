resource "random_password" "mysql" {
  length  = 20
  special = true
}

resource "aws_security_group" "mysql" {
  name        = "${var.name_prefix}-${local.workspace_safe}-mysql-sg"
  description = "Allow MySQL access from VPC"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] # Adjust to your VPC CIDR
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "mysql" {
  name       = "${var.name_prefix}-${local.workspace_safe}-mysql-subnet-group"
  subnet_ids = module.vpc.private_subnets

  tags = {
    Name = "${var.name_prefix}-${local.workspace_safe}-mysql-subnet-group"
  }
}

resource "aws_db_instance" "mysql" {
  identifier                 = "${var.name_prefix}-${local.workspace_safe}-mysql-db"
  engine                     = "mysql"
  engine_version             = "8.0"
  instance_class             = var.rds_instance_class
  allocated_storage          = 20
  storage_type               = "gp3"
  db_name                    = "${var.name_prefix}-${local.workspace_safe}-${var.db_name}"
  db_subnet_group_name       = aws_db_subnet_group.mysql.name
  vpc_security_group_ids     = [aws_security_group.mysql.id]
  publicly_accessible        = false
  skip_final_snapshot        = true
  deletion_protection        = false
  backup_retention_period    = 7
  auto_minor_version_upgrade = true

  # Get credentials from Secrets Manager
  username = jsondecode(aws_secretsmanager_secret_version.mysql.secret_string)["username"]
  password = jsondecode(aws_secretsmanager_secret_version.mysql.secret_string)["password"]

  tags = {
    Name = "${var.name_prefix}-${local.workspace_safe}-mysql-db"
  }
}