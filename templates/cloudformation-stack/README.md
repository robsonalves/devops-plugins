# CloudFormation Stack Template

Production-ready AWS CloudFormation template for VPC infrastructure.

## What This Creates

- **VPC** with configurable CIDR block
- **2 Public Subnets** across different Availability Zones
- **2 Private Subnets** across different Availability Zones
- **Internet Gateway** for public internet access
- **2 NAT Gateways** for private subnet internet access (high availability)
- **Route Tables** properly configured for public and private subnets
- **Exports** for use by other stacks

## Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    VPC (10.0.0.0/16)                    │
│  ┌─────────────────────┐  ┌─────────────────────┐      │
│  │  Public Subnet 1    │  │  Public Subnet 2    │      │
│  │    10.0.1.0/24      │  │    10.0.2.0/24      │      │
│  │  ┌───────────────┐  │  │  ┌───────────────┐  │      │
│  │  │  NAT Gateway  │  │  │  │  NAT Gateway  │  │      │
│  │  └───────────────┘  │  │  └───────────────┘  │      │
│  └─────────────────────┘  └─────────────────────┘      │
│            ↑ ↓                      ↑ ↓                 │
│    ┌───────────────────────────────────────────┐        │
│    │         Internet Gateway                  │        │
│    └───────────────────────────────────────────┘        │
│  ┌─────────────────────┐  ┌─────────────────────┐      │
│  │  Private Subnet 1   │  │  Private Subnet 2   │      │
│  │   10.0.11.0/24      │  │   10.0.12.0/24      │      │
│  │  (App Servers)      │  │  (App Servers)      │      │
│  └─────────────────────┘  └─────────────────────┘      │
└─────────────────────────────────────────────────────────┘
```

## Quick Start

### Using DevOps Toolkit

```bash
# 1. Switch to correct AWS profile
/aws-profile

# 2. Validate template
/cfn-validate

# 3. Deploy stack
/cfn-deploy

# 4. Check status
/cfn-status

# 5. Commit infrastructure code
/commit-feat
```

### Manual Deployment

```bash
# Validate
aws cloudformation validate-template \
  --template-body file://vpc-stack.yaml

# Deploy
aws cloudformation create-stack \
  --stack-name myapp-production-vpc \
  --template-body file://vpc-stack.yaml \
  --parameters \
    ParameterKey=EnvironmentName,ParameterValue=production \
    ParameterKey=VpcCIDR,ParameterValue=10.0.0.0/16

# Monitor
aws cloudformation describe-stacks \
  --stack-name myapp-production-vpc \
  --query 'Stacks[0].StackStatus'

# Get outputs
aws cloudformation describe-stacks \
  --stack-name myapp-production-vpc \
  --query 'Stacks[0].Outputs'
```

## Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| EnvironmentName | production | Environment name prefix |
| VpcCIDR | 10.0.0.0/16 | VPC CIDR block |
| PublicSubnet1CIDR | 10.0.1.0/24 | Public subnet 1 CIDR |
| PublicSubnet2CIDR | 10.0.2.0/24 | Public subnet 2 CIDR |
| PrivateSubnet1CIDR | 10.0.11.0/24 | Private subnet 1 CIDR |
| PrivateSubnet2CIDR | 10.0.12.0/24 | Private subnet 2 CIDR |

## Outputs (Exports)

The stack exports these values for use by other stacks:

- `${EnvironmentName}-VPC-ID`: VPC ID
- `${EnvironmentName}-VPC-CIDR`: VPC CIDR block
- `${EnvironmentName}-Public-Subnets`: Comma-separated public subnet IDs
- `${EnvironmentName}-Private-Subnets`: Comma-separated private subnet IDs
- `${EnvironmentName}-Public-Subnet-1-ID`: Public subnet 1 ID
- `${EnvironmentName}-Public-Subnet-2-ID`: Public subnet 2 ID
- `${EnvironmentName}-Private-Subnet-1-ID`: Private subnet 1 ID
- `${EnvironmentName}-Private-Subnet-2-ID`: Private subnet 2 ID

## Using Outputs in Other Stacks

```yaml
# In another CloudFormation template
Parameters:
  VpcId:
    Type: String
    Default: !ImportValue production-VPC-ID

Resources:
  MySecurityGroup:
    Type: AWS::EC2::SecurityGroup
    Properties:
      VpcId: !Ref VpcId
```

Or import directly:

```yaml
Resources:
  MySecurityGroup:
    Type: AWS::EC2::SecurityGroup
    Properties:
      VpcId: !ImportValue production-VPC-ID
```

## Cost Estimation

**Monthly costs (us-east-1):**
- NAT Gateways: ~$65 (2 × $32.50)
- Data processing: Variable based on usage (~$0.045/GB)
- Elastic IPs: $0 (associated with NAT Gateways)

**Cost Optimization Options:**
1. Use single NAT Gateway (reduces cost but no HA)
2. Use NAT Instances instead (cheaper but more management)
3. Consider VPC Endpoints for AWS services (reduces NAT Gateway data)

## Customization

### Different CIDR Blocks

```bash
aws cloudformation create-stack \
  --stack-name myapp-prod-vpc \
  --template-body file://vpc-stack.yaml \
  --parameters \
    ParameterKey=VpcCIDR,ParameterValue=172.16.0.0/16 \
    ParameterKey=PublicSubnet1CIDR,ParameterValue=172.16.1.0/24 \
    ParameterKey=PublicSubnet2CIDR,ParameterValue=172.16.2.0/24 \
    ParameterKey=PrivateSubnet1CIDR,ParameterValue=172.16.11.0/24 \
    ParameterKey=PrivateSubnet2CIDR,ParameterValue=172.16.12.0/24
```

### Single NAT Gateway (Cost Savings)

Remove `NatGateway2`, `NatGateway2EIP`, and update `PrivateRouteTable2` to use `NatGateway1`.

### Three Availability Zones

Add third public and private subnets, NAT Gateway, and route tables.

## Updates

### Updating the Stack

```bash
# Using DevOps Toolkit
/cfn-deploy

# Manual
aws cloudformation update-stack \
  --stack-name myapp-production-vpc \
  --template-body file://vpc-stack.yaml \
  --parameters \
    ParameterKey=EnvironmentName,UsePreviousValue=true \
    ParameterKey=VpcCIDR,UsePreviousValue=true
```

### Drift Detection

```bash
# Using DevOps Toolkit
/cfn-status

# Manual
aws cloudformation detect-stack-drift \
  --stack-name myapp-production-vpc

aws cloudformation describe-stack-resource-drifts \
  --stack-name myapp-production-vpc
```

## Deletion

**Warning**: Deleting this stack will remove all networking infrastructure.

```bash
# Delete dependent stacks first!
aws cloudformation delete-stack \
  --stack-name myapp-production-app

# Then delete VPC stack
aws cloudformation delete-stack \
  --stack-name myapp-production-vpc
```

## Common Issues

### Stack Creation Fails

**Issue**: "The maximum number of VPCs has been reached"
**Solution**: Delete unused VPCs or request limit increase

**Issue**: "Invalid CIDR block"
**Solution**: Ensure CIDR blocks don't overlap with existing VPCs

### Cannot Delete Stack

**Issue**: "Export X is still imported by Y"
**Solution**: Delete dependent stacks first

**Issue**: "Resource has dependencies"
**Solution**: Check for resources created outside CloudFormation

## Best Practices

1. **Use Parameters**: Makes template reusable across environments
2. **Export Outputs**: Share resources between stacks
3. **Tag Everything**: Enable cost tracking and management
4. **Multi-AZ**: Use multiple Availability Zones for HA
5. **Version Control**: Store templates in git
6. **Change Sets**: Review changes before applying
7. **Stack Policies**: Protect critical resources

## Next Steps

After deploying this VPC:

1. **Deploy Application Stack**: Use exported VPC ID and subnet IDs
2. **Set Up VPC Flow Logs**: Monitor network traffic
3. **Configure VPC Endpoints**: Reduce NAT Gateway costs
4. **Set Up Transit Gateway**: Connect multiple VPCs
5. **Enable AWS Config**: Track configuration changes

## Additional Resources

- [AWS VPC Documentation](https://docs.aws.amazon.com/vpc/)
- [CloudFormation Best Practices](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/best-practices.html)
- [VPC Pricing](https://aws.amazon.com/vpc/pricing/)

## License

MIT
