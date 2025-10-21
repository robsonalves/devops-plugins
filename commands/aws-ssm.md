# AWS Systems Manager (SSM) Helper

You are helping use AWS Systems Manager for parameter management, session management, and operations. Follow these steps:

1. Identify the SSM operation needed:
   - Parameter Store access
   - Session Manager (SSH alternative)
   - Run Command execution
   - Patch management
2. Execute appropriate SSM commands
3. Handle results and provide guidance

**Parameter Store:**

```bash
# Get parameter value
aws ssm get-parameter --name /my/parameter --with-decryption

# Get parameter value only
aws ssm get-parameter \
  --name /my/parameter \
  --with-decryption \
  --query 'Parameter.Value' \
  --output text

# Get multiple parameters
aws ssm get-parameters \
  --names /my/param1 /my/param2 \
  --with-decryption

# Get parameters by path
aws ssm get-parameters-by-path \
  --path /my/app/ \
  --recursive \
  --with-decryption

# Put parameter (String)
aws ssm put-parameter \
  --name /my/parameter \
  --value "my-value" \
  --type String \
  --description "My parameter"

# Put parameter (SecureString with KMS)
aws ssm put-parameter \
  --name /my/secret \
  --value "secret-value" \
  --type SecureString \
  --key-id alias/aws/ssm \
  --description "My secret"

# Update parameter
aws ssm put-parameter \
  --name /my/parameter \
  --value "new-value" \
  --overwrite

# Delete parameter
aws ssm delete-parameter --name /my/parameter

# List parameters
aws ssm describe-parameters

# List parameters by path
aws ssm describe-parameters \
  --parameter-filters "Key=Name,Option=BeginsWith,Values=/my/app/"
```

**Parameter Store - Batch operations:**
```bash
# Export all parameters to JSON
aws ssm get-parameters-by-path \
  --path / \
  --recursive \
  --with-decryption \
  --query 'Parameters[*].[Name,Value]' \
  --output json > parameters.json

# Import parameters from file
while IFS= read -r line; do
  name=$(echo $line | jq -r '.[0]')
  value=$(echo $line | jq -r '.[1]')
  aws ssm put-parameter --name "$name" --value "$value" --type String --overwrite
done < parameters.json
```

**Session Manager (SSH alternative):**

```bash
# Start interactive session
aws ssm start-session --target i-1234567890abcdef0

# Start session with specific document
aws ssm start-session \
  --target i-1234567890abcdef0 \
  --document-name AWS-StartPortForwardingSession \
  --parameters '{"portNumber":["80"],"localPortNumber":["8080"]}'

# Port forwarding
aws ssm start-session \
  --target i-1234567890abcdef0 \
  --document-name AWS-StartPortForwardingSession \
  --parameters 'portNumber=3306,localPortNumber=3306'

# SSH through Session Manager (in ~/.ssh/config)
# Host i-* mi-*
#   ProxyCommand sh -c "aws ssm start-session --target %h --document-name AWS-StartSSHSession --parameters 'portNumber=%p'"
```

**Run Command:**

```bash
# Run shell command on instance
aws ssm send-command \
  --instance-ids i-1234567890abcdef0 \
  --document-name "AWS-RunShellScript" \
  --parameters 'commands=["echo Hello World","date"]'

# Run command on multiple instances by tag
aws ssm send-command \
  --targets "Key=tag:Environment,Values=Production" \
  --document-name "AWS-RunShellScript" \
  --parameters 'commands=["systemctl restart nginx"]'

# Run command and wait for result
COMMAND_ID=$(aws ssm send-command \
  --instance-ids i-1234567890abcdef0 \
  --document-name "AWS-RunShellScript" \
  --parameters 'commands=["uptime"]' \
  --query 'Command.CommandId' \
  --output text)

# Get command status
aws ssm get-command-invocation \
  --command-id $COMMAND_ID \
  --instance-id i-1234567890abcdef0

# Get command output
aws ssm get-command-invocation \
  --command-id $COMMAND_ID \
  --instance-id i-1234567890abcdef0 \
  --query 'StandardOutputContent' \
  --output text
```

**Common SSM Documents:**
- `AWS-RunShellScript`: Run shell commands (Linux)
- `AWS-RunPowerShellScript`: Run PowerShell (Windows)
- `AWS-ConfigureDocker`: Install/configure Docker
- `AWS-UpdateSSMAgent`: Update SSM agent
- `AWS-ApplyPatchBaseline`: Apply patches
- `AWS-StartPortForwardingSession`: Port forwarding

**List instances managed by SSM:**
```bash
# List all managed instances
aws ssm describe-instance-information

# List online instances
aws ssm describe-instance-information \
  --filters "Key=PingStatus,Values=Online"

# Get specific instance info
aws ssm describe-instance-information \
  --instance-information-filter-list "key=InstanceIds,valueSet=i-1234567890abcdef0"
```

**Patch Management:**
```bash
# Create patch baseline
aws ssm create-patch-baseline \
  --name "MyPatchBaseline" \
  --operating-system "AMAZON_LINUX_2" \
  --approval-rules 'PatchRules=[{PatchFilterGroup={PatchFilters=[{Key=CLASSIFICATION,Values=[Security,Bugfix]}]},ApprovalAfterDays=7}]'

# Describe patch baselines
aws ssm describe-patch-baselines

# Get patch compliance
aws ssm describe-instance-patch-states \
  --instance-ids i-1234567890abcdef0

# Scan for patches
aws ssm send-command \
  --instance-ids i-1234567890abcdef0 \
  --document-name "AWS-RunPatchBaseline" \
  --parameters 'Operation=Scan'

# Install patches
aws ssm send-command \
  --instance-ids i-1234567890abcdef0 \
  --document-name "AWS-RunPatchBaseline" \
  --parameters 'Operation=Install'
```

**Maintenance Windows:**
```bash
# Create maintenance window
aws ssm create-maintenance-window \
  --name "MyMaintenanceWindow" \
  --schedule "cron(0 2 ? * SUN *)" \
  --duration 4 \
  --cutoff 1 \
  --allow-unassociated-targets

# Register targets
aws ssm register-target-with-maintenance-window \
  --window-id mw-1234567890abcdef0 \
  --target-type "INSTANCE" \
  --targets "Key=tag:Environment,Values=Production"

# Register task
aws ssm register-task-with-maintenance-window \
  --window-id mw-1234567890abcdef0 \
  --task-type "RUN_COMMAND" \
  --targets "Key=WindowTargetIds,Values=wt-1234567890abcdef0" \
  --task-arn "AWS-RunPatchBaseline" \
  --service-role-arn "arn:aws:iam::123456789012:role/MaintenanceWindowRole"
```

**Automation:**
```bash
# Start automation execution
aws ssm start-automation-execution \
  --document-name "AWS-RestartEC2Instance" \
  --parameters "InstanceId=i-1234567890abcdef0"

# Get automation execution
aws ssm get-automation-execution \
  --automation-execution-id 1234abcd-12ab-12ab-12ab-123456789012

# List automation executions
aws ssm describe-automation-executions \
  --filters "Key=DocumentName,Values=AWS-RestartEC2Instance"
```

**Best practices:**

1. **Parameter Store:**
   - Use path hierarchy: /env/app/service/param
   - Use SecureString for sensitive data
   - Tag parameters for organization
   - Use parameter policies for rotation

2. **Session Manager:**
   - Prefer over SSH for better auditability
   - Log sessions to S3/CloudWatch
   - Use IAM for access control
   - Enable session encryption

3. **Run Command:**
   - Use tags for targeting instances
   - Store output in S3 for large outputs
   - Set up SNS notifications
   - Use rate controls to avoid overwhelming instances

4. **Security:**
   - Use least privilege IAM policies
   - Encrypt parameters with KMS
   - Enable CloudTrail logging
   - Regularly rotate secrets
