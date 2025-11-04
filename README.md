# DevOps Toolkit Plugin for Claude Code

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)](https://github.com/robsonalves/devops-plugins/releases)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-Plugin-purple.svg)](https://docs.claude.com/en/docs/claude-code/plugins)

A comprehensive DevOps plugin for Claude Code with commands for Terraform, Terragrunt, Azure DevOps, Kubernetes, AWS, CloudFormation, and Git workflow automation.

## Features

This plugin provides specialized slash commands to streamline your DevOps workflows:

### Infrastructure as Code (IaC)

**Terraform/Terragrunt:**
- `/tf-plan` - Create and analyze Terraform execution plans
- `/tf-apply` - Apply Terraform changes with safety checks
- `/tf-validate` - Validate Terraform configuration and formatting
- `/tf-fmt` - Format Terraform code consistently
- `/tf-docs` - Generate module documentation
- `/tg-run-all` - Execute Terragrunt commands across modules

### CI/CD Pipelines

**Azure DevOps:**
- `/pipeline-validate` - Validate Azure DevOps pipeline YAML
- `/pipeline-run` - Trigger pipeline runs
- `/pipeline-status` - Check pipeline status
- `/pipeline-logs` - View and analyze pipeline logs

### Version Control

**Git with Conventional Commits:**
- `/commit` - General conventional commit helper
- `/commit-feat` - Create feature commits
- `/commit-fix` - Create bug fix commits
- `/commit-docs` - Create documentation commits
- `/commit-refactor` - Create refactoring commits
- `/commit-chore` - Create maintenance/chore commits

All commit commands follow the [Conventional Commits](https://www.conventionalcommits.org/) specification and use English language.

### Container Orchestration

**Kubernetes:**
- `/k8s-status` - Check Kubernetes resource status
- `/k8s-logs` - View and analyze pod logs
- `/k8s-describe` - Describe resources in detail
- `/k8s-apply` - Apply Kubernetes manifests
- `/k8s-debug` - Debug pod issues

### Cloud Management

**AWS:**
- `/cfn-validate` - Validate CloudFormation templates
- `/cfn-deploy` - Deploy CloudFormation stacks
- `/cfn-status` - Check stack status and drift
- `/aws-profile` - Manage AWS CLI profiles
- `/aws-ssm` - AWS Systems Manager operations

### Utilities

**Quick Operations:**
- `/git-cleanup` - Clean up merged Git branches
- `/docker-prune` - Remove unused Docker resources
- `/k8s-restart` - Restart Kubernetes deployments/pods

## Quick Start

Check out the [examples/](examples/) directory for complete workflows and the [templates/](templates/) directory for production-ready starter templates.

## Installation

### Add the Marketplace

```bash
/plugin marketplace add robsonalves/devops-plugins
```

### Install the Plugin

```bash
/plugin install devops-toolkit@robsonalves
```

### Alternative: Install from Local Directory

If you've cloned this repository:

```bash
# Clone the repository
git clone https://github.com/robsonalves/devops-plugins ~/ts/devops-plugins

# Add as local marketplace
/plugin marketplace add ~/ts/devops-plugins

# Install the plugin
/plugin install devops-toolkit@local
```

## Usage Examples

### Terraform Workflow

```bash
# Validate and format code
/tf-validate

# Create execution plan
/tf-plan

# Apply changes
/tf-apply

# Generate documentation
/tf-docs
```

### Azure DevOps Pipeline

```bash
# Validate pipeline YAML
/pipeline-validate

# Run pipeline
/pipeline-run

# Check status
/pipeline-status

# View logs if failed
/pipeline-logs
```

### Kubernetes Deployment

```bash
# Check cluster status
/k8s-status

# Apply manifests
/k8s-apply

# Check pod logs
/k8s-logs

# Debug issues
/k8s-debug
```

### Git Conventional Commits

```bash
# Add a new feature
/commit-feat

# Fix a bug
/commit-fix

# Update documentation
/commit-docs

# Refactor code
/commit-refactor

# Maintenance tasks
/commit-chore
```

### AWS Operations

```bash
# Switch AWS profile
/aws-profile

# Validate CloudFormation template
/cfn-validate

# Deploy stack
/cfn-deploy

# Check stack status
/cfn-status

# Manage parameters
/aws-ssm
```

## Command Details

### Terraform Commands

Each Terraform command provides:
- Pre-execution validation
- Interactive guidance
- Error analysis and suggestions
- Best practices recommendations

### Azure DevOps Commands

Pipeline commands help with:
- YAML syntax validation
- Pipeline execution
- Status monitoring
- Log analysis and troubleshooting

### Kubernetes Commands

K8s commands assist with:
- Resource health checks
- Log analysis
- Debugging common issues
- Manifest application
- Real-time monitoring

### Git Commands

Commit commands ensure:
- Conventional Commits compliance
- English language commits
- Proper commit type selection
- Detailed commit bodies
- Breaking change notation
- No author names in commits

### AWS Commands

AWS commands cover:
- Profile management
- CloudFormation stack lifecycle
- Parameter Store operations
- Session Manager access
- Systems Manager automation

## Examples

The [examples/](examples/) directory contains complete, real-world workflows:

- **[Terraform Workflow](examples/terraform-workflow/)** - Complete infrastructure management with Terraform/Terragrunt
- **[Kubernetes Deployment](examples/k8s-deployment/)** - Deploy and troubleshoot applications on Kubernetes
- **[Azure Pipeline](examples/azure-pipeline/)** - Set up CI/CD with Azure DevOps
- **[AWS Infrastructure](examples/aws-infrastructure/)** - Manage AWS resources with CloudFormation and SSM

Each example includes step-by-step instructions, common scenarios, troubleshooting guides, and best practices from production experience.

## Templates

The [templates/](templates/) directory provides production-ready starter templates:

- **[Terraform Module](templates/terraform-module/)** - Complete module structure with variables, outputs, and documentation
- **[Kubernetes Deployment](templates/k8s-deployment/)** - Full K8s manifests with deployment, service, ingress, HPA, and more
- **[Azure Pipeline](templates/azure-pipeline/)** - Multi-stage CI/CD pipeline with testing, Docker, and K8s deployment
- **[CloudFormation Stack](templates/cloudformation-stack/)** - AWS VPC infrastructure with public/private subnets and NAT gateways

Copy a template to your project and customize it for your needs:

```bash
# Copy Terraform module template
cp -r templates/terraform-module my-new-module

# Copy Kubernetes deployment
cp -r templates/k8s-deployment my-app-k8s

# Copy Azure pipeline
cp templates/azure-pipeline/azure-pipelines.yaml .
```

## Best Practices

### Terraform/Terragrunt

1. Always run `/tf-validate` before planning
2. Review plan output carefully before applying
3. Use `/tf-docs` to keep documentation updated
4. Format code with `/tf-fmt` before committing

### Azure DevOps

1. Validate pipeline YAML with `/pipeline-validate` before committing
2. Use change sets for production deployments
3. Monitor pipeline status during deployments
4. Analyze logs immediately on failures

### Kubernetes

1. Check status with `/k8s-status` before deployments
2. Use `/k8s-apply` with dry-run first
3. Monitor logs with `/k8s-logs` during rollouts
4. Use `/k8s-debug` for systematic troubleshooting

### Git Workflow

1. Use specific commit type commands for better guidance
2. Keep commit subjects under 50 characters
3. Write detailed bodies explaining WHY, not WHAT
4. Reference issues/tickets in commit messages
5. Mark breaking changes explicitly

### AWS

1. Always validate templates before deployment
2. Use change sets for CloudFormation updates
3. Tag resources consistently
4. Use appropriate AWS profiles for different environments
5. Encrypt sensitive parameters in SSM

## Prerequisites

### Required Tools

Depending on which commands you use, you may need:

- **Terraform**: `brew install terraform` or [download](https://www.terraform.io/downloads)
- **Terragrunt**: `brew install terragrunt` or [download](https://terragrunt.gruntwork.io/docs/getting-started/install/)
- **AWS CLI**: `brew install awscli` or [install guide](https://aws.amazon.com/cli/)
- **Azure CLI**: `brew install azure-cli` or [install guide](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- **kubectl**: `brew install kubectl` or [install guide](https://kubernetes.io/docs/tasks/tools/)
- **Git**: Usually pre-installed or `brew install git`

### Optional Tools

For enhanced functionality:

- **terraform-docs**: `brew install terraform-docs`
- **cfn-lint**: `pip install cfn-lint`
- **rain**: `brew install rain` (better CloudFormation CLI)
- **jq**: `brew install jq` (JSON processing)

## Configuration

### AWS Configuration

Set up AWS profiles in `~/.aws/config` and `~/.aws/credentials`:

```ini
# ~/.aws/credentials
[default]
aws_access_key_id = YOUR_ACCESS_KEY
aws_secret_access_key = YOUR_SECRET_KEY

[dev]
aws_access_key_id = DEV_ACCESS_KEY
aws_secret_access_key = DEV_SECRET_KEY

# ~/.aws/config
[default]
region = us-east-1
output = json

[profile dev]
region = us-west-2
output = json
```

### Azure DevOps Configuration

Configure Azure DevOps CLI:

```bash
az extension add --name azure-devops
az devops configure --defaults organization=https://dev.azure.com/your-org project=your-project
```

### Kubernetes Configuration

Ensure kubectl is configured with your cluster:

```bash
kubectl config get-contexts
kubectl config use-context your-context
```

## Troubleshooting

### Plugin Not Loading

```bash
# List installed plugins
/plugin list

# Check marketplace status
/plugin marketplace list

# Reinstall if needed
/plugin uninstall devops-toolkit@robsonalves
/plugin install devops-toolkit@robsonalves
```

### Commands Not Working

1. Ensure required CLI tools are installed
2. Verify authentication/credentials are configured
3. Check you're in the correct directory for context-specific commands
4. Review command output for specific error messages

### AWS Commands Failing

```bash
# Verify credentials
aws sts get-caller-identity

# Check profile
echo $AWS_PROFILE

# Test connection
aws s3 ls
```

### Azure DevOps Commands Failing

```bash
# Verify login
az account show

# Check devops extension
az extension list

# Reconfigure defaults
az devops configure --list
```

## Contributing

Contributions are welcome! To add new commands or improve existing ones:

1. Fork the repository
2. Create a feature branch: `git checkout -b feat/new-command`
3. Add your command in the `commands/` directory
4. Update this README with command documentation
5. Commit using conventional commits: `/commit-feat`
6. Push and create a pull request

## License

MIT License - See LICENSE file for details

## Support

For issues, questions, or feature requests:

- GitHub Issues: [https://github.com/robsonalves/devops-plugins/issues](https://github.com/robsonalves/devops-plugins/issues)
- Claude Code Docs: [https://docs.claude.com/en/docs/claude-code/plugins](https://docs.claude.com/en/docs/claude-code/plugins)

## Roadmap

Future enhancements planned:

- [ ] Docker/Docker Compose commands
- [ ] GitHub Actions helpers
- [ ] Vault/Secrets management commands
- [ ] Monitoring/Observability commands (Prometheus, Grafana)
- [ ] Ansible playbook helpers
- [ ] GitOps/ArgoCD/Flux commands
- [ ] Cost optimization helpers
- [ ] Security scanning integration
- [ ] Multi-cloud support (GCP, DigitalOcean)

## Changelog

### v1.0.0 (Initial Release)

- Terraform/Terragrunt commands
- Azure DevOps pipeline commands
- Conventional Commits helpers
- Kubernetes management commands
- AWS/CloudFormation commands
- AWS Profile and SSM management

---

Made with ❤️ for the DevOps community
