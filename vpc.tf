module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${var.name_prefix}-${local.workspace_safe}-vpc"
  cidr = "10.0.0.0/16"

  azs = var.azs

  public_subnets = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]

  private_subnets = [
    "10.0.101.0/24",
    "10.0.102.0/24"
  ]

  # Internet Gateway
  create_igw = true

  # Disable NAT completely
  enable_nat_gateway = false

  # DNS (recommended even without NAT)
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Environment = local.workspace_safe
  }

  public_subnet_tags = {
    Tier = "public"
  }

  private_subnet_tags = {
    Tier = "private"
  }
}
