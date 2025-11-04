# Terraform Module Template

This is a starter template for creating Terraform modules following best practices.

## Usage

```hcl
module "example" {
  source = "./modules/example"

  name_prefix          = "myapp"
  vpc_cidr            = "10.0.0.0/16"
  environment         = "prod"
  enable_dns_hostnames = true

  tags = {
    Project = "MyProject"
    Owner   = "DevOps"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 5.0 |

## Resources

| Name | Type |
|------|------|
| aws_vpc.main | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name_prefix | Prefix to be used for resource names | `string` | n/a | yes |
| vpc_cidr | CIDR block for the VPC | `string` | `"10.0.0.0/16"` | no |
| environment | Environment name (dev, staging, prod) | `string` | n/a | yes |
| enable_dns_hostnames | Enable DNS hostnames in the VPC | `bool` | `true` | no |
| enable_dns_support | Enable DNS support in the VPC | `bool` | `true` | no |
| tags | Additional tags to apply to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| vpc_id | ID of the VPC |
| vpc_cidr | CIDR block of the VPC |
| vpc_arn | ARN of the VPC |

## Examples

See the `examples/` directory for complete examples.

## Development

Use the DevOps Toolkit commands:

```bash
# Validate module
/tf-validate

# Format code
/tf-fmt

# Generate documentation
/tf-docs

# Test the module
cd examples/complete
/tf-plan
```

## License

MIT
