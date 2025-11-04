# Terraform Workflow Example

This example demonstrates a complete Terraform workflow using the DevOps Toolkit commands.

## Scenario

You're deploying AWS infrastructure for a web application with:
- VPC and networking
- EC2 instances with Auto Scaling
- RDS database
- S3 bucket for static assets

## Step-by-Step Workflow

### 1. Initial Setup and Validation

```bash
# Navigate to your terraform directory
cd infrastructure/terraform/production

# Validate and format your Terraform code
/tf-validate
```

Claude Code will:
- Check formatting with `terraform fmt -check`
- Validate syntax with `terraform validate`
- Suggest fixes for any issues

### 2. Review Changes

```bash
# Create an execution plan
/tf-plan
```

This will:
- Initialize Terraform if needed
- Generate an execution plan
- Show what resources will be created/modified/destroyed
- Highlight any potential issues

### 3. Generate Documentation

```bash
# Generate module documentation
/tf-docs
```

Creates/updates documentation for your Terraform modules, including:
- Input variables
- Output values
- Resource descriptions

### 4. Apply Changes

```bash
# Apply the changes
/tf-apply
```

Claude Code will:
- Show a final review of changes
- Ask for confirmation
- Apply the changes
- Show output values
- Suggest verification steps

### 5. Commit Your Work

```bash
# Commit infrastructure changes
/commit-feat
```

Example commit:
```
feat(terraform): add production VPC and networking

Implemented complete network infrastructure for production environment:
- VPC with public and private subnets across 3 AZs
- NAT gateways for private subnet internet access
- Security groups for web and database tiers
- Network ACLs for additional security layer

Closes #123
```

## Complete Example

```bash
# Full workflow in sequence
cd infrastructure/terraform/production

# 1. Validate code
/tf-validate

# 2. Format code if needed
/tf-fmt

# 3. Generate docs
/tf-docs

# 4. Review plan
/tf-plan

# 5. Apply changes (after review)
/tf-apply

# 6. Commit changes
/commit-feat
```

## Terragrunt Multi-Module Example

For projects using Terragrunt with multiple modules:

```bash
# Navigate to terragrunt root
cd infrastructure/terragrunt/production

# Run plan across all modules
/tg-run-all plan

# Review each module's plan, then apply
/tg-run-all apply

# Commit the infrastructure changes
/commit-feat
```

## Best Practices

1. **Always validate before planning**: Catch syntax errors early
2. **Review plans carefully**: Look for unexpected changes
3. **Document your modules**: Keep docs up to date with /tf-docs
4. **Use meaningful commits**: Explain WHY the infrastructure changed
5. **Test in dev first**: Apply to development before production

## Common Scenarios

### Adding a New Resource

```bash
# Edit your .tf files to add the new resource

/tf-validate  # Ensure syntax is correct
/tf-plan      # Review what will be added
/tf-apply     # Create the resource
/commit-feat  # Commit with message like "feat(ec2): add cache server"
```

### Fixing a Configuration Issue

```bash
# Fix the issue in your .tf files

/tf-validate  # Verify the fix
/tf-plan      # Ensure only intended changes
/tf-apply     # Apply the fix
/commit-fix   # Commit with message like "fix(rds): correct backup window"
```

### Refactoring Infrastructure

```bash
# Make your refactoring changes

/tf-validate
/tf-plan      # Important: verify no resources are destroyed
/tf-apply
/commit-refactor  # Commit with message like "refactor(modules): extract networking module"
```

## Troubleshooting

### State Lock Issues

If you encounter state lock errors:
```bash
# Check who has the lock
terraform force-unlock <LOCK_ID>

# Then retry
/tf-apply
```

### Provider Version Conflicts

```bash
# Update provider versions in versions.tf
/tf-validate  # Will catch version conflicts
terraform init -upgrade
/tf-plan
```

### Drift Detection

```bash
# Create a plan to see drift
/tf-plan

# If drift detected, decide:
# Option 1: Import changes made outside Terraform
# Option 2: Revert manual changes by applying
/tf-apply
```

## Next Steps

- Explore the [Kubernetes deployment example](../k8s-deployment/)
- Learn about [CI/CD integration](../azure-pipeline/)
- Check the [AWS infrastructure example](../aws-infrastructure/)
