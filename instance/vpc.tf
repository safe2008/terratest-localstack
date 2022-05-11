module "vpc" {
  source               = "terraform-aws-modules/vpc/aws"
  name                 = "vpc-main"
  cidr                 = "10.0.0.0/16"
  azs                  = ["${var.aws_region}a", "${var.aws_region}b"]
  private_subnets      = ["10.0.0.0/24", "10.0.1.0/24"]
  public_subnets       = ["10.0.100.0/24", "10.0.101.0/24"]
  enable_dns_hostnames = true
  enable_dns_support   = true
  enable_nat_gateway   = false
  enable_vpn_gateway   = false
  tags                 = local.tags
}