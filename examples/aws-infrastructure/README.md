# AWS Infrastructure Management Example

This example demonstrates managing AWS infrastructure using CloudFormation, AWS CLI, and Systems Manager with the DevOps Toolkit.

## Scenario

You're managing AWS infrastructure for a production application including:
- VPC and networking
- Application Load Balancer
- ECS/Fargate services
- RDS database
- ElastiCache Redis
- S3 buckets
- Parameter Store for configuration

## Step-by-Step Workflow

### 1. Switch AWS Profile

```bash
# Switch to the appropriate AWS profile
/aws-profile
```

Claude Code will:
- List available AWS profiles
- Help you switch to the correct one
- Verify credentials
- Show current region

### 2. Manage Parameters in Parameter Store

```bash
# Manage application configuration
/aws-ssm
```

Common operations:
- Store database credentials
- Retrieve API keys
- Update configuration values
- Bulk export/import parameters

### 3. Validate CloudFormation Template

```bash
# Validate your template before deployment
/cfn-validate
```

This checks:
- JSON/YAML syntax
- Resource types
- Property names
- Parameter definitions
- Output definitions

### 4. Deploy CloudFormation Stack

```bash
# Deploy or update infrastructure
/cfn-deploy
```

Claude Code will:
- Create a change set first (for updates)
- Show what will change
- Ask for confirmation
- Deploy the stack
- Monitor deployment progress
- Show stack outputs

### 5. Check Stack Status

```bash
# Monitor stack status and check for drift
/cfn-status
```

Provides:
- Stack status (CREATE_COMPLETE, UPDATE_IN_PROGRESS, etc.)
- Stack events
- Drift detection
- Resource status
- Output values

## Complete Example: Deploying a Web Application

### Step 1: Set Up AWS Profile

```bash
# Switch to production profile
/aws-profile

# Select: production
# Region: us-east-1
```

### Step 2: Store Configuration in Parameter Store

```bash
# Store database password
/aws-ssm

# Claude helps you run:
aws ssm put-parameter \
  --name /myapp/prod/db/password \
  --value "your-secure-password" \
  --type SecureString \
  --description "Production database password"

# Store other configuration
aws ssm put-parameter \
  --name /myapp/prod/api/key \
  --value "api-key-value" \
  --type SecureString

# Store non-sensitive config
aws ssm put-parameter \
  --name /myapp/prod/app/debug \
  --value "false" \
  --type String
```

### Step 3: Create CloudFormation Template

Create `infrastructure.yaml`:

```yaml
AWSTemplateFormatVersion: '2010-09-09'
Description: 'Production infrastructure for MyApp'

Parameters:
  EnvironmentName:
    Type: String
    Default: production
    Description: Environment name prefix

  VpcCIDR:
    Type: String
    Default: 10.0.0.0/16
    Description: VPC CIDR block

  DBPassword:
    Type: String
    NoEcho: true
    Description: Database password (from Parameter Store)

Resources:
  VPC:
    Type: AWS::EC2::VPC
    Properties:
      CidrBlock: !Ref VpcCIDR
      EnableDnsHostnames: true
      EnableDnsSupport: true
      Tags:
        - Key: Name
          Value: !Sub '${EnvironmentName}-VPC'

  PublicSubnet1:
    Type: AWS::EC2::Subnet
    Properties:
      VpcId: !Ref VPC
      AvailabilityZone: !Select [0, !GetAZs '']
      CidrBlock: 10.0.1.0/24
      MapPublicIpOnLaunch: true
      Tags:
        - Key: Name
          Value: !Sub '${EnvironmentName}-Public-Subnet-1'

  PublicSubnet2:
    Type: AWS::EC2::Subnet
    Properties:
      VpcId: !Ref VPC
      AvailabilityZone: !Select [1, !GetAZs '']
      CidrBlock: 10.0.2.0/24
      MapPublicIpOnLaunch: true
      Tags:
        - Key: Name
          Value: !Sub '${EnvironmentName}-Public-Subnet-2'

  PrivateSubnet1:
    Type: AWS::EC2::Subnet
    Properties:
      VpcId: !Ref VPC
      AvailabilityZone: !Select [0, !GetAZs '']
      CidrBlock: 10.0.11.0/24
      Tags:
        - Key: Name
          Value: !Sub '${EnvironmentName}-Private-Subnet-1'

  PrivateSubnet2:
    Type: AWS::EC2::Subnet
    Properties:
      VpcId: !Ref VPC
      AvailabilityZone: !Select [1, !GetAZs '']
      CidrBlock: 10.0.12.0/24
      Tags:
        - Key: Name
          Value: !Sub '${EnvironmentName}-Private-Subnet-2'

  InternetGateway:
    Type: AWS::EC2::InternetGateway
    Properties:
      Tags:
        - Key: Name
          Value: !Sub '${EnvironmentName}-IGW'

  AttachGateway:
    Type: AWS::EC2::VPCGatewayAttachment
    Properties:
      VpcId: !Ref VPC
      InternetGatewayId: !Ref InternetGateway

  DBSubnetGroup:
    Type: AWS::RDS::DBSubnetGroup
    Properties:
      DBSubnetGroupDescription: Subnet group for RDS
      SubnetIds:
        - !Ref PrivateSubnet1
        - !Ref PrivateSubnet2
      Tags:
        - Key: Name
          Value: !Sub '${EnvironmentName}-DB-Subnet-Group'

  DatabaseSecurityGroup:
    Type: AWS::EC2::SecurityGroup
    Properties:
      GroupDescription: Security group for RDS database
      VpcId: !Ref VPC
      SecurityGroupIngress:
        - IpProtocol: tcp
          FromPort: 5432
          ToPort: 5432
          SourceSecurityGroupId: !Ref AppSecurityGroup
      Tags:
        - Key: Name
          Value: !Sub '${EnvironmentName}-DB-SG'

  AppSecurityGroup:
    Type: AWS::EC2::SecurityGroup
    Properties:
      GroupDescription: Security group for application
      VpcId: !Ref VPC
      SecurityGroupIngress:
        - IpProtocol: tcp
          FromPort: 80
          ToPort: 80
          CidrIp: 0.0.0.0/0
        - IpProtocol: tcp
          FromPort: 443
          ToPort: 443
          CidrIp: 0.0.0.0/0
      Tags:
        - Key: Name
          Value: !Sub '${EnvironmentName}-App-SG'

  Database:
    Type: AWS::RDS::DBInstance
    Properties:
      DBInstanceIdentifier: !Sub '${EnvironmentName}-postgres'
      Engine: postgres
      EngineVersion: '15.4'
      DBInstanceClass: db.t3.medium
      AllocatedStorage: 100
      StorageType: gp3
      DBSubnetGroupName: !Ref DBSubnetGroup
      VPCSecurityGroups:
        - !Ref DatabaseSecurityGroup
      MasterUsername: dbadmin
      MasterUserPassword: !Ref DBPassword
      BackupRetentionPeriod: 7
      PreferredBackupWindow: '03:00-04:00'
      PreferredMaintenanceWindow: 'sun:04:00-sun:05:00'
      MultiAZ: true
      Tags:
        - Key: Name
          Value: !Sub '${EnvironmentName}-Database'

Outputs:
  VpcId:
    Description: VPC ID
    Value: !Ref VPC
    Export:
      Name: !Sub '${EnvironmentName}-VPC-ID'

  DatabaseEndpoint:
    Description: Database endpoint
    Value: !GetAtt Database.Endpoint.Address
    Export:
      Name: !Sub '${EnvironmentName}-DB-Endpoint'

  AppSecurityGroupId:
    Description: Application security group ID
    Value: !Ref AppSecurityGroup
    Export:
      Name: !Sub '${EnvironmentName}-App-SG-ID'
```

### Step 4: Validate Template

```bash
/cfn-validate
```

### Step 5: Deploy Stack

```bash
/cfn-deploy
```

Claude Code will guide you through:
- Stack name selection
- Parameter values
- Change set review
- Deployment execution

### Step 6: Monitor Deployment

```bash
# Check stack status
/cfn-status

# Output will show:
# - Stack: myapp-production
# - Status: CREATE_IN_PROGRESS
# - Resources: 15/20 created
# - Estimated time: 10 minutes remaining
```

### Step 7: Verify and Document

```bash
# Once complete, commit your infrastructure code
/commit-feat
```

Example commit:
```
feat(aws): deploy production infrastructure stack

Deployed complete AWS infrastructure for production environment:
- VPC with public and private subnets across 2 AZs
- Internet Gateway and route tables
- RDS PostgreSQL database with Multi-AZ
- Security groups for app and database tiers
- Parameter Store integration for secrets

Resources created:
- 1 VPC (10.0.0.0/16)
- 4 Subnets (2 public, 2 private)
- 1 RDS instance (db.t3.medium, Multi-AZ)
- 2 Security groups
- 1 DB subnet group

Stack outputs exported for use by application stacks.

Closes #189
```

## Common Scenarios

### Scenario 1: Update Existing Stack

```bash
# 1. Modify infrastructure.yaml

# 2. Validate changes
/cfn-validate

# 3. Deploy update
/cfn-deploy

# Claude will create a change set showing:
# - Resources to be modified
# - Resources to be added
# - Resources to be removed (if any)

# 4. Review and approve

# 5. Monitor update
/cfn-status

# 6. Commit changes
/commit-feat
```

### Scenario 2: Detect and Fix Configuration Drift

```bash
# Check for drift
/cfn-status

# Output shows:
# "Drift detected on 3 resources"
# - SecurityGroup: Port 22 added manually
# - Database: Backup window changed
# - S3Bucket: Versioning disabled

# Options:
# 1. Import drift into template (update template to match)
# 2. Fix drift by reapplying template

# To fix drift:
/cfn-deploy  # Redeploy to restore desired state

# Commit template updates if accepting drift
/commit-fix
```

Example fix:
```
fix(aws): update security group to match production changes

Updated security group configuration to include SSH access
that was added manually for troubleshooting. This change
was approved and is now codified in the template.

Fixes #191
```

### Scenario 3: Manage Secrets with Parameter Store

```bash
# Store new API key
/aws-ssm

# Example commands Claude helps with:

# 1. Put new secret
aws ssm put-parameter \
  --name /myapp/prod/stripe/api-key \
  --value "sk_live_xxx" \
  --type SecureString \
  --key-id alias/myapp-kms

# 2. Retrieve secret
aws ssm get-parameter \
  --name /myapp/prod/stripe/api-key \
  --with-decryption

# 3. Update secret
aws ssm put-parameter \
  --name /myapp/prod/stripe/api-key \
  --value "sk_live_new_xxx" \
  --type SecureString \
  --overwrite

# 4. List all parameters for app
aws ssm get-parameters-by-path \
  --path /myapp/prod/ \
  --recursive \
  --with-decryption
```

### Scenario 4: Multi-Stack Deployment

Deploy multiple related stacks:

```bash
# 1. Deploy network stack first
/cfn-deploy network-stack.yaml

# 2. Check status
/cfn-status

# 3. Deploy database stack (depends on network)
/cfn-deploy database-stack.yaml

# 4. Deploy application stack (depends on both)
/cfn-deploy application-stack.yaml

# 5. Commit all templates
/commit-feat
```

### Scenario 5: Session Manager Access

```bash
# Access EC2 instance without SSH
/aws-ssm

# Claude helps with:
aws ssm start-session --target i-1234567890abcdef0

# Port forwarding to RDS
aws ssm start-session \
  --target i-1234567890abcdef0 \
  --document-name AWS-StartPortForwardingSessionToRemoteHost \
  --parameters '{
    "host":["database.internal.com"],
    "portNumber":["5432"],
    "localPortNumber":["5432"]
  }'
```

## Advanced Patterns

### Using Stack Sets for Multi-Region

```yaml
# Deploy same infrastructure to multiple regions
aws cloudformation create-stack-set \
  --stack-set-name myapp-infrastructure \
  --template-body file://infrastructure.yaml

aws cloudformation create-stack-instances \
  --stack-set-name myapp-infrastructure \
  --regions us-east-1 us-west-2 eu-west-1
```

### Nested Stacks

```yaml
# Master stack referencing child stacks
Resources:
  NetworkStack:
    Type: AWS::CloudFormation::Stack
    Properties:
      TemplateURL: https://s3.amazonaws.com/templates/network.yaml
      Parameters:
        VpcCIDR: 10.0.0.0/16

  DatabaseStack:
    Type: AWS::CloudFormation::Stack
    DependsOn: NetworkStack
    Properties:
      TemplateURL: https://s3.amazonaws.com/templates/database.yaml
      Parameters:
        VpcId: !GetAtt NetworkStack.Outputs.VpcId
```

### Cost Optimization

```bash
# Check resource costs
aws ce get-cost-and-usage \
  --time-period Start=2025-01-01,End=2025-01-31 \
  --granularity MONTHLY \
  --metrics BlendedCost \
  --group-by Type=TAG,Key=Environment

# Right-size RDS instances
aws rds describe-db-instances \
  --query 'DBInstances[*].[DBInstanceIdentifier,DBInstanceClass]'
```

## Best Practices

1. **Use Parameter Store**: Store secrets securely, never in templates
2. **Enable drift detection**: Regular check for manual changes
3. **Use change sets**: Always review before applying updates
4. **Tag everything**: Enable cost tracking and resource management
5. **Use stack policies**: Protect critical resources from updates
6. **Export outputs**: Share values between stacks
7. **Version templates**: Keep templates in git with proper commits
8. **Test in dev first**: Validate changes in non-production

## Troubleshooting

### Stack Rollback

```bash
# Stack creation failed and rolled back
/cfn-status

# Check events to find root cause
# Common issues:
# - Insufficient IAM permissions
# - Resource limits exceeded
# - Invalid parameter values
# - Dependency errors

# Fix issue and retry
/cfn-deploy
```

### Update Requires Replacement

```bash
# Some changes require resource replacement
/cfn-deploy

# Change set shows:
# "Database - Replacement: True"

# This means:
# - New resource will be created
# - Old resource will be deleted
# - Data may be lost!

# For databases, take backup first:
aws rds create-db-snapshot \
  --db-instance-identifier mydb \
  --db-snapshot-identifier mydb-backup-20250104
```

## Monitoring and Alerts

### CloudWatch Alarms

```yaml
DatabaseCPUAlarm:
  Type: AWS::CloudWatch::Alarm
  Properties:
    AlarmDescription: Database CPU utilization high
    MetricName: CPUUtilization
    Namespace: AWS/RDS
    Statistic: Average
    Period: 300
    EvaluationPeriods: 2
    Threshold: 80
    ComparisonOperator: GreaterThanThreshold
    Dimensions:
      - Name: DBInstanceIdentifier
        Value: !Ref Database
```

## Next Steps

- Explore [Terraform workflows](../terraform-workflow/)
- Learn about [Kubernetes deployment](../k8s-deployment/)
- Check [Azure Pipeline setup](../azure-pipeline/)
- Set up AWS monitoring with CloudWatch
- Implement AWS backup strategies
- Configure AWS Config for compliance
