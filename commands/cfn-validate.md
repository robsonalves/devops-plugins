# CloudFormation Template Validation

You are helping validate AWS CloudFormation templates. Follow these steps:

1. Locate CloudFormation template files (YAML or JSON)
2. Perform syntax validation
3. Validate template with AWS CloudFormation API
4. Check for common issues and best practices
5. Suggest improvements

Validation commands:
```bash
# Validate template syntax with AWS CLI
aws cloudformation validate-template --template-body file://template.yaml

# Validate with S3 URL
aws cloudformation validate-template --template-url https://s3.amazonaws.com/bucket/template.yaml

# Lint with cfn-lint (more comprehensive)
cfn-lint template.yaml

# Lint with specific rules
cfn-lint template.yaml --ignore-checks W

# Check all templates in directory
cfn-lint templates/*.yaml
```

Install cfn-lint if not available:
```bash
pip install cfn-lint
# or
brew install cfn-lint
```

Validation checklist:

**Syntax and Structure:**
- Valid YAML/JSON format
- Required sections: AWSTemplateFormatVersion, Resources
- Optional: Description, Parameters, Mappings, Conditions, Outputs
- Proper indentation and formatting
- No duplicate keys

**Parameters:**
- Appropriate parameter types
- Default values where sensible
- Constraints (AllowedValues, Min/Max Length, etc.)
- Descriptions for all parameters
- No hardcoded sensitive values

**Resources:**
- Valid resource types
- Required properties defined
- Logical resource names (PascalCase convention)
- Proper references with !Ref and !GetAtt
- DeletionPolicy for critical resources (esp. databases, S3)
- UpdateReplacePolicy where appropriate

**Outputs:**
- Useful output values (IDs, ARNs, endpoints)
- Export names for cross-stack references
- Descriptions for all outputs

**Security best practices:**
- No hardcoded credentials
- Use of AWS Secrets Manager or Parameter Store
- Proper IAM roles and policies (least privilege)
- Security groups with minimal required access
- Encryption enabled for data at rest
- SSL/TLS for data in transit

**Cost optimization:**
- Appropriate instance types
- Auto-scaling configurations
- Lifecycle policies for S3
- Resource tagging for cost allocation

**Common issues to check:**
- Circular dependencies
- Missing dependencies (DependsOn when needed)
- Incorrect !Ref or !GetAtt usage
- Resource limits (200 resources per template)
- Template size limits (51,200 bytes for direct upload)
- Intrinsic function nesting limits

Example validation workflow:
```bash
# 1. Check syntax with cfn-lint
cfn-lint template.yaml

# 2. Validate with AWS API
aws cloudformation validate-template --template-body file://template.yaml

# 3. Check for security issues
cfn-lint template.yaml --ignore-checks W3

# 4. Generate change set to preview
aws cloudformation create-change-set \
  --stack-name my-stack \
  --template-body file://template.yaml \
  --change-set-name my-changes \
  --capabilities CAPABILITY_IAM

# 5. Review change set
aws cloudformation describe-change-set \
  --stack-name my-stack \
  --change-set-name my-changes
```

Tools to consider:
- **cfn-lint**: Comprehensive linting
- **cfn-nag**: Security-focused scanning
- **taskcat**: Multi-region/account testing
- **AWS CloudFormation Designer**: Visual editor
- **rain**: Modern CLI for CloudFormation
