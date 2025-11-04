# Main resource definitions for the module

terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Example: VPC module
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = merge(
    {
      Name = "${var.name_prefix}-vpc"
    },
    var.tags
  )
}

# Add your resources here
# Examples: aws_subnet, aws_security_group, aws_instance, etc.
