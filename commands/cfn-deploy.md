# CloudFormation Stack Deployment

You are helping deploy AWS CloudFormation stacks. Follow these steps:

1. Verify template is validated
2. Determine deployment method:
   - Create new stack
   - Update existing stack
   - Deploy with change set (recommended)
3. Prepare parameters and tags
4. Deploy stack with appropriate capabilities
5. Monitor deployment progress
6. Handle any errors or rollbacks

Deployment commands:

**Create new stack:**
```bash
aws cloudformation create-stack \
  --stack-name my-stack \
  --template-body file://template.yaml \
  --parameters ParameterKey=Param1,ParameterValue=Value1 \
  --tags Key=Environment,Value=Production \
  --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM

# Create stack from S3
aws cloudformation create-stack \
  --stack-name my-stack \
  --template-url https://s3.amazonaws.com/bucket/template.yaml \
  --parameters file://parameters.json \
  --capabilities CAPABILITY_IAM
```

**Update existing stack:**
```bash
aws cloudformation update-stack \
  --stack-name my-stack \
  --template-body file://template.yaml \
  --parameters file://parameters.json \
  --capabilities CAPABILITY_IAM

# Update with no changes to parameters
aws cloudformation update-stack \
  --stack-name my-stack \
  --template-body file://template.yaml \
  --use-previous-template
```

**Deploy with change set (recommended):**
```bash
# 1. Create change set
aws cloudformation create-change-set \
  --stack-name my-stack \
  --template-body file://template.yaml \
  --change-set-name my-changeset \
  --parameters file://parameters.json \
  --capabilities CAPABILITY_IAM

# 2. Describe and review changes
aws cloudformation describe-change-set \
  --stack-name my-stack \
  --change-set-name my-changeset

# 3. Execute change set
aws cloudformation execute-change-set \
  --stack-name my-stack \
  --change-set-name my-changeset
```

**Monitor deployment:**
```bash
# Wait for stack operation to complete
aws cloudformation wait stack-create-complete --stack-name my-stack

# Monitor events during deployment
aws cloudformation describe-stack-events \
  --stack-name my-stack \
  --max-items 20

# Check stack status
aws cloudformation describe-stacks --stack-name my-stack

# Get stack outputs
aws cloudformation describe-stacks \
  --stack-name my-stack \
  --query 'Stacks[0].Outputs'
```

Parameters file format (parameters.json):
```json
[
  {
    "ParameterKey": "InstanceType",
    "ParameterValue": "t3.micro"
  },
  {
    "ParameterKey": "KeyName",
    "ParameterValue": "my-keypair"
  }
]
```

**Capabilities to consider:**
- `CAPABILITY_IAM`: Required if creating IAM resources
- `CAPABILITY_NAMED_IAM`: Required if creating named IAM resources
- `CAPABILITY_AUTO_EXPAND`: Required if using macros or nested stacks

**Deployment best practices:**

1. **Use change sets**: Always review changes before applying
2. **Tag resources**: Add meaningful tags for organization
3. **Enable termination protection**: For production stacks
   ```bash
   aws cloudformation update-termination-protection \
     --stack-name my-stack \
     --enable-termination-protection
   ```
4. **Set stack policy**: Prevent accidental updates/deletes
5. **Use parameters**: Don't hardcode environment-specific values
6. **Rollback configuration**: Set up automatic rollback triggers
7. **Notifications**: Configure SNS for stack events

**Handle deployment errors:**
```bash
# Check failure reason
aws cloudformation describe-stack-events \
  --stack-name my-stack \
  --query 'StackEvents[?ResourceStatus==`CREATE_FAILED`]'

# Rollback failed create
aws cloudformation delete-stack --stack-name my-stack

# Continue update rollback (if stuck)
aws cloudformation continue-update-rollback --stack-name my-stack

# Cancel update (must be in UPDATE_IN_PROGRESS)
aws cloudformation cancel-update-stack --stack-name my-stack
```

**Stack drift detection:**
```bash
# Detect drift
aws cloudformation detect-stack-drift --stack-name my-stack

# Check drift status
aws cloudformation describe-stack-drift-detection-status \
  --stack-drift-detection-id <drift-id>

# View drift details
aws cloudformation describe-stack-resource-drifts \
  --stack-name my-stack
```

**Using AWS CloudFormation CLI (rain):**
```bash
# Modern alternative with better UX
brew install rain

# Deploy with rain
rain deploy template.yaml my-stack

# Watch stack in real-time
rain watch my-stack

# Delete stack
rain rm my-stack
```
