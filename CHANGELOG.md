# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Validation script for command files integrity
- Examples directory with real-world use cases
- Quick-win commands: git-cleanup, docker-prune, k8s-restart
- Templates directory with starter templates for common scenarios

## [1.0.0] - 2025-01-04

### Added

#### Infrastructure as Code (IaC)
- `/tf-plan` - Create and analyze Terraform execution plans
- `/tf-apply` - Apply Terraform changes with safety checks
- `/tf-validate` - Validate Terraform configuration and formatting
- `/tf-fmt` - Format Terraform code consistently
- `/tf-docs` - Generate module documentation
- `/tg-run-all` - Execute Terragrunt commands across modules

#### CI/CD Pipelines
- `/pipeline-validate` - Validate Azure DevOps pipeline YAML
- `/pipeline-run` - Trigger pipeline runs
- `/pipeline-status` - Check pipeline status
- `/pipeline-logs` - View and analyze pipeline logs

#### Version Control
- `/commit` - General conventional commit helper
- `/commit-feat` - Create feature commits
- `/commit-fix` - Create bug fix commits
- `/commit-docs` - Create documentation commits
- `/commit-refactor` - Create refactoring commits
- `/commit-chore` - Create maintenance/chore commits

#### Container Orchestration
- `/k8s-status` - Check Kubernetes resource status
- `/k8s-logs` - View and analyze pod logs
- `/k8s-describe` - Describe resources in detail
- `/k8s-apply` - Apply Kubernetes manifests
- `/k8s-debug` - Debug pod issues with comprehensive troubleshooting

#### Cloud Management
- `/cfn-validate` - Validate CloudFormation templates
- `/cfn-deploy` - Deploy CloudFormation stacks
- `/cfn-status` - Check stack status and drift
- `/aws-profile` - Manage AWS CLI profiles
- `/aws-ssm` - AWS Systems Manager operations (Parameter Store, Session Manager, Run Command)

#### Documentation
- Comprehensive README with usage examples
- CONTRIBUTING.md with guidelines for contributors
- MIT License
- Plugin configuration files (plugin.json, marketplace.json)

### Fixed
- Manifest repository field format changed to string
- Configuration source path corrected to start with ./
- Marketplace.json schema format validated

## [0.1.0] - 2025-01-03

### Added
- Initial project structure
- Basic plugin configuration
- Command templates

[Unreleased]: https://github.com/robsonalves/devops-plugins/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/robsonalves/devops-plugins/releases/tag/v1.0.0
[0.1.0]: https://github.com/robsonalves/devops-plugins/releases/tag/v0.1.0
