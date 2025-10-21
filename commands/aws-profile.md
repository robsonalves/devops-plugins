# AWS Profile Management

You are helping manage AWS CLI profiles and credentials. Follow these steps:

1. Understand current AWS configuration
2. List available profiles
3. Help switch between profiles
4. Configure new profiles if needed
5. Verify credentials are working

Profile management commands:

**List and view profiles:**
```bash
# List all configured profiles
aws configure list-profiles

# Show current default configuration
aws configure list

# Show specific profile configuration
aws configure list --profile myprofile

# View credentials file
cat ~/.aws/credentials

# View config file
cat ~/.aws/config
```

**Switch profiles:**
```bash
# Set environment variable (temporary for session)
export AWS_PROFILE=myprofile

# Verify current profile
echo $AWS_PROFILE
aws sts get-caller-identity

# Unset profile (use default)
unset AWS_PROFILE

# Use profile for single command
aws s3 ls --profile myprofile
```

**Configure new profile:**
```bash
# Interactive configuration
aws configure --profile myprofile

# Set specific values
aws configure set aws_access_key_id AKIAIOSFODNN7EXAMPLE --profile myprofile
aws configure set aws_secret_access_key wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY --profile myprofile
aws configure set region us-east-1 --profile myprofile
aws configure set output json --profile myprofile

# Set default region
aws configure set region us-east-1 --profile myprofile
```

**Profile formats:**

Credentials file (~/.aws/credentials):
```ini
[default]
aws_access_key_id = AKIAIOSFODNN7EXAMPLE
aws_secret_access_key = wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY

[myprofile]
aws_access_key_id = AKIAIOSFODNN7EXAMPLE
aws_secret_access_key = wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY

[with-session]
aws_access_key_id = AKIAIOSFODNN7EXAMPLE
aws_secret_access_key = wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
aws_session_token = FwoGZXIvYXdzEJr...
```

Config file (~/.aws/config):
```ini
[default]
region = us-east-1
output = json

[profile myprofile]
region = us-west-2
output = table

[profile assume-role]
role_arn = arn:aws:iam::123456789012:role/MyRole
source_profile = default
region = us-east-1
```

**Assume role configuration:**
```bash
# Add assume role profile to config
cat >> ~/.aws/config << EOF
[profile myrole]
role_arn = arn:aws:iam::123456789012:role/MyRole
source_profile = default
region = us-east-1
duration_seconds = 3600
EOF

# Use assumed role
export AWS_PROFILE=myrole
aws sts get-caller-identity
```

**SSO configuration:**
```bash
# Configure SSO profile
aws configure sso --profile mysso

# Follow prompts:
# SSO start URL: https://my-sso-portal.awsapps.com/start
# SSO Region: us-east-1
# Account ID: 123456789012
# Role name: MyRole
# CLI default region: us-east-1
# CLI default output: json

# Login to SSO
aws sso login --profile mysso

# Logout
aws sso logout --profile mysso
```

**MFA configuration:**
```bash
# Add MFA device ARN to profile
aws configure set mfa_serial arn:aws:iam::123456789012:mfa/myuser --profile myprofile

# Get temporary credentials with MFA
aws sts get-session-token \
  --serial-number arn:aws:iam::123456789012:mfa/myuser \
  --token-code 123456 \
  --duration-seconds 129600
```

**Verify credentials:**
```bash
# Get caller identity
aws sts get-caller-identity

# Show account ID
aws sts get-caller-identity --query Account --output text

# Show user ARN
aws sts get-caller-identity --query Arn --output text

# Test credentials with simple API call
aws s3 ls

# Check credential expiration (for temporary creds)
aws sts get-caller-identity --profile myprofile
```

**Common profile scenarios:**

**Multi-account setup:**
```bash
# Development account
export AWS_PROFILE=dev-account
aws sts get-caller-identity

# Production account
export AWS_PROFILE=prod-account
aws sts get-caller-identity
```

**Terraform with profiles:**
```bash
# Set profile for Terraform
export AWS_PROFILE=terraform-account
terraform init
terraform plan
```

**Profile in scripts:**
```bash
#!/bin/bash
# Always use specific profile in script
export AWS_PROFILE=automation-account

aws s3 sync ./backup s3://my-bucket/
```

**Troubleshooting:**
```bash
# Clear cached credentials
rm -rf ~/.aws/cli/cache/

# Verify credentials file permissions (should be 600)
chmod 600 ~/.aws/credentials

# Debug credential resolution
aws configure list --profile myprofile

# Enable AWS CLI debug output
aws s3 ls --debug --profile myprofile 2>&1 | grep -i credential
```

**Best practices:**
1. Never commit credentials to git
2. Use IAM roles for EC2/ECS instead of credentials
3. Use SSO for human users when possible
4. Rotate access keys regularly
5. Use least privilege IAM policies
6. Enable MFA for sensitive operations
7. Use separate profiles for different environments
8. Set short session durations for assumed roles
