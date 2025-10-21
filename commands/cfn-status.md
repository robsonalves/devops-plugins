# CloudFormation Stack Status

You are helping check AWS CloudFormation stack status and health. Follow these steps:

1. Identify the stack to check
2. Get current stack status
3. Review recent events and changes
4. Check resource status
5. Identify any issues or drift
6. Provide summary and recommendations

Status commands:

**Check stack status:**
```bash
# List all stacks
aws cloudformation list-stacks

# List active stacks only
aws cloudformation list-stacks \
  --stack-status-filter CREATE_COMPLETE UPDATE_COMPLETE

# Describe specific stack
aws cloudformation describe-stacks --stack-name my-stack

# Get stack status in table format
aws cloudformation describe-stacks \
  --stack-name my-stack \
  --query 'Stacks[0].[StackName,StackStatus,CreationTime]' \
  --output table
```

**Stack statuses:**
- **CREATE_IN_PROGRESS**: Stack is being created
- **CREATE_COMPLETE**: Stack created successfully
- **CREATE_FAILED**: Stack creation failed
- **UPDATE_IN_PROGRESS**: Stack is being updated
- **UPDATE_COMPLETE**: Stack updated successfully
- **UPDATE_ROLLBACK_IN_PROGRESS**: Update failed, rolling back
- **UPDATE_ROLLBACK_COMPLETE**: Rolled back to previous state
- **DELETE_IN_PROGRESS**: Stack is being deleted
- **DELETE_COMPLETE**: Stack deleted successfully
- **ROLLBACK_IN_PROGRESS**: Create failed, rolling back
- **ROLLBACK_COMPLETE**: Rolled back after failed create

**Check stack events:**
```bash
# Get recent events
aws cloudformation describe-stack-events \
  --stack-name my-stack \
  --max-items 20

# Get failed events
aws cloudformation describe-stack-events \
  --stack-name my-stack \
  --query 'StackEvents[?contains(ResourceStatus, `FAILED`)]'

# Watch events in real-time
watch -n 5 'aws cloudformation describe-stack-events \
  --stack-name my-stack \
  --max-items 10 \
  --query "StackEvents[].[Timestamp,ResourceStatus,ResourceType,LogicalResourceId]" \
  --output table'
```

**Check resources:**
```bash
# List all resources in stack
aws cloudformation list-stack-resources --stack-name my-stack

# Get detailed resource info
aws cloudformation describe-stack-resources --stack-name my-stack

# Check specific resource
aws cloudformation describe-stack-resource \
  --stack-name my-stack \
  --logical-resource-id MyResource
```

**Get stack outputs:**
```bash
# All outputs
aws cloudformation describe-stacks \
  --stack-name my-stack \
  --query 'Stacks[0].Outputs'

# Specific output
aws cloudformation describe-stacks \
  --stack-name my-stack \
  --query 'Stacks[0].Outputs[?OutputKey==`MyOutput`].OutputValue' \
  --output text
```

**Check drift:**
```bash
# Detect drift
DRIFT_ID=$(aws cloudformation detect-stack-drift \
  --stack-name my-stack \
  --query 'StackDriftDetectionId' \
  --output text)

# Wait for drift detection to complete
aws cloudformation wait \
  stack-drift-detection-complete \
  --stack-drift-detection-id $DRIFT_ID

# Get drift results
aws cloudformation describe-stack-drift-detection-status \
  --stack-drift-detection-id $DRIFT_ID

# Get resource drift details
aws cloudformation describe-stack-resource-drifts \
  --stack-name my-stack \
  --stack-resource-drift-status-filters MODIFIED DELETED
```

**Check stack policy:**
```bash
# Get stack policy
aws cloudformation get-stack-policy --stack-name my-stack

# Check termination protection
aws cloudformation describe-stacks \
  --stack-name my-stack \
  --query 'Stacks[0].EnableTerminationProtection'
```

**Dependencies and exports:**
```bash
# List stack exports
aws cloudformation list-exports

# List stacks importing a value
aws cloudformation list-imports --export-name MyExport

# Find dependencies
aws cloudformation describe-stacks \
  --stack-name my-stack \
  --query 'Stacks[0].Parameters[?ParameterKey==`ParentStack`]'
```

**Quick health check script:**
```bash
#!/bin/bash
STACK_NAME=$1

echo "=== Stack Status ==="
aws cloudformation describe-stacks \
  --stack-name $STACK_NAME \
  --query 'Stacks[0].[StackName,StackStatus,CreationTime]' \
  --output table

echo -e "\n=== Recent Events ==="
aws cloudformation describe-stack-events \
  --stack-name $STACK_NAME \
  --max-items 5 \
  --query 'StackEvents[].[Timestamp,ResourceStatus,LogicalResourceId,ResourceStatusReason]' \
  --output table

echo -e "\n=== Failed Resources ==="
aws cloudformation describe-stack-events \
  --stack-name $STACK_NAME \
  --query 'StackEvents[?contains(ResourceStatus, `FAILED`)].[Timestamp,LogicalResourceId,ResourceStatusReason]' \
  --output table

echo -e "\n=== Outputs ==="
aws cloudformation describe-stacks \
  --stack-name $STACK_NAME \
  --query 'Stacks[0].Outputs' \
  --output table
```

**Common issues to look for:**

1. **Stack stuck in progress**: May need manual intervention
2. **Drift detected**: Resources modified outside CloudFormation
3. **Failed resources**: Check ResourceStatusReason in events
4. **Circular dependencies**: Check DependsOn relationships
5. **Resource limits**: AWS service quotas exceeded
6. **IAM permissions**: Insufficient permissions for operations
7. **Parameter issues**: Invalid or missing parameter values

**Using rain for better visibility:**
```bash
# Watch stack in real-time with color coding
rain watch my-stack

# Show stack tree structure
rain tree my-stack

# Get stack logs
rain logs my-stack
```
