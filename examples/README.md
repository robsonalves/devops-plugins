# DevOps Toolkit Examples

This directory contains real-world examples and workflows demonstrating how to use the DevOps Toolkit plugin for Claude Code.

## Available Examples

### [Terraform Workflow](./terraform-workflow/)
Complete guide to managing infrastructure as code with Terraform and Terragrunt.

**What you'll learn:**
- Validate and format Terraform code
- Create and review execution plans
- Apply infrastructure changes safely
- Generate module documentation
- Work with Terragrunt for multi-module projects
- Commit infrastructure changes following best practices

**Use cases:**
- Deploying AWS infrastructure
- Managing multi-environment setups
- Terraform module development
- Infrastructure refactoring

### [Kubernetes Deployment](./k8s-deployment/)
End-to-end Kubernetes application deployment and troubleshooting.

**What you'll learn:**
- Deploy applications to Kubernetes clusters
- Monitor pod status and logs
- Debug common issues (CrashLoopBackOff, OOMKilled, etc.)
- Perform rolling updates and rollbacks
- Implement health checks and resource limits
- Handle service connectivity issues

**Use cases:**
- Microservices deployment
- Application troubleshooting
- Blue-green and canary deployments
- Production incident response

### [Azure DevOps Pipeline](./azure-pipeline/)
CI/CD pipeline creation and management with Azure DevOps.

**What you'll learn:**
- Create and validate Azure pipeline YAML
- Set up multi-stage pipelines (Build → Test → Deploy)
- Configure Docker build and push
- Deploy to Kubernetes from pipelines
- Troubleshoot pipeline failures
- Use pipeline templates and caching

**Use cases:**
- Automated testing and deployment
- Multi-environment CD workflows
- Container image builds
- Infrastructure deployment automation

### [AWS Infrastructure Management](./aws-infrastructure/)
Manage AWS resources using CloudFormation, SSM, and AWS CLI.

**What you'll learn:**
- Deploy infrastructure with CloudFormation
- Manage secrets with Parameter Store
- Switch between AWS profiles
- Detect and fix configuration drift
- Use Session Manager for secure access
- Monitor stack status and resources

**Use cases:**
- AWS infrastructure deployment
- Multi-region deployments
- Secret and configuration management
- Production infrastructure updates

## Quick Start

1. **Choose an example** that matches your current task
2. **Follow the step-by-step guide** in each example
3. **Use the plugin commands** as shown in the examples
4. **Adapt the patterns** to your specific needs

## Example Structure

Each example includes:
- **Scenario**: Real-world context for the example
- **Step-by-step workflow**: Detailed instructions
- **Complete examples**: Full configuration files
- **Common scenarios**: Typical problems and solutions
- **Best practices**: Recommendations from production experience
- **Troubleshooting**: How to debug common issues

## Using Multiple Examples Together

These examples are designed to work together in a complete DevOps workflow:

```
1. Infrastructure (Terraform/AWS)
   ↓
2. Application Code
   ↓
3. CI/CD Pipeline (Azure DevOps)
   ↓
4. Deployment (Kubernetes)
   ↓
5. Monitoring & Operations
```

### Example: Complete Application Deployment

```bash
# 1. Deploy AWS infrastructure
cd infrastructure/terraform
/tf-validate
/tf-plan
/tf-apply
/commit-feat

# 2. Configure application
/aws-profile production
/aws-ssm  # Store configuration

# 3. Set up CI/CD pipeline
cd ../../
/pipeline-validate
/commit-feat
/pipeline-run

# 4. Deploy to Kubernetes
/k8s-status
/k8s-apply
/k8s-logs
/commit-feat

# 5. Verify deployment
/k8s-status
/cfn-status
```

## Learning Path

### Beginner
Start here if you're new to DevOps or these tools:
1. [Git Conventional Commits](../README.md#version-control) - Learn commit standards
2. [Terraform Workflow](./terraform-workflow/) - Infrastructure basics
3. [Kubernetes Deployment](./k8s-deployment/) - Container orchestration basics

### Intermediate
Ready for more complex workflows:
1. [Azure Pipeline](./azure-pipeline/) - Automated CI/CD
2. [AWS Infrastructure](./aws-infrastructure/) - Cloud management
3. Multi-stack deployments across examples

### Advanced
Complex production scenarios:
1. Multi-region deployments
2. Blue-green and canary strategies
3. GitOps workflows
4. Disaster recovery procedures

## Common Workflows

### Daily Operations

```bash
# Morning health check
/k8s-status
/cfn-status

# Review and deploy changes
/tf-validate
/tf-plan
/tf-apply

# Monitor deployments
/pipeline-status
/k8s-logs
```

### New Feature Deployment

```bash
# 1. Update infrastructure if needed
/tf-plan
/tf-apply

# 2. Update configuration
/aws-ssm

# 3. Deploy application
/pipeline-run
/k8s-apply

# 4. Verify and commit
/k8s-status
/commit-feat
```

### Incident Response

```bash
# 1. Check status
/k8s-status
/k8s-logs

# 2. Debug issues
/k8s-debug

# 3. Fix and redeploy
/k8s-apply

# 4. Verify fix
/k8s-logs
/k8s-status

# 5. Document fix
/commit-fix
```

### Infrastructure Update

```bash
# 1. Update templates
# Edit CloudFormation or Terraform files

# 2. Validate
/tf-validate  # or /cfn-validate

# 3. Review changes
/tf-plan  # or /cfn-deploy with change set

# 4. Apply
/tf-apply  # or /cfn-deploy

# 5. Verify
/cfn-status  # or /tf-validate

# 6. Commit
/commit-feat
```

## Tips for Success

1. **Read the scenario first**: Understand the context before following steps
2. **Adapt to your environment**: Change resource names, regions, etc.
3. **Test in dev first**: Always validate in non-production
4. **Use version control**: Commit all infrastructure and configuration as code
5. **Document your changes**: Use conventional commits with detailed descriptions
6. **Monitor after changes**: Always verify deployments succeeded
7. **Learn from examples**: Understand the patterns, don't just copy-paste

## Contributing Examples

Have a useful workflow or pattern? Contributions are welcome!

1. Create a new directory under `examples/`
2. Include a detailed README with:
   - Scenario description
   - Step-by-step instructions
   - Complete configuration files
   - Common issues and solutions
3. Test the example end-to-end
4. Submit a pull request

See [CONTRIBUTING.md](../CONTRIBUTING.md) for guidelines.

## Need Help?

- **Command reference**: See main [README.md](../README.md)
- **Issues**: Open an issue on GitHub
- **Discussions**: Start a discussion for questions
- **Documentation**: Check [Claude Code docs](https://docs.claude.com/en/docs/claude-code/plugins)

## Additional Resources

- [Terraform Documentation](https://www.terraform.io/docs)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Azure DevOps Pipelines](https://docs.microsoft.com/en-us/azure/devops/pipelines/)
- [AWS CloudFormation](https://docs.aws.amazon.com/cloudformation/)
- [Conventional Commits](https://www.conventionalcommits.org/)

## What's Next?

After completing these examples, you might want to:
- Implement GitOps with ArgoCD or Flux
- Add monitoring with Prometheus and Grafana
- Set up disaster recovery procedures
- Implement cost optimization strategies
- Create custom automation workflows

Check the [Roadmap](../README.md#roadmap) for upcoming features and examples!
