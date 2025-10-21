# Contributing to DevOps Toolkit Plugin

Thank you for your interest in contributing to the DevOps Toolkit Plugin for Claude Code!

## How to Contribute

### Adding New Commands

1. **Create a command file** in the `commands/` directory:
   ```bash
   touch commands/my-new-command.md
   ```

2. **Write the command prompt** following this structure:
   ```markdown
   # Command Name

   You are helping [describe what the command does]. Follow these steps:

   1. [Step 1]
   2. [Step 2]
   3. [Step 3]
   ...

   [Include examples, code snippets, and best practices]
   ```

3. **Test the command** by using it in Claude Code:
   ```bash
   /my-new-command
   ```

4. **Update README.md** with:
   - Command name in the appropriate section
   - Brief description
   - Usage example if needed

### Command Writing Guidelines

**Good command prompts:**
- Are clear and specific about the task
- Include step-by-step instructions
- Provide code examples and snippets
- Mention common issues and solutions
- Follow best practices
- Use imperative voice ("Run", "Check", not "You should run")

**Example:**
```markdown
# Terraform Plan Command

You are helping create a Terraform execution plan. Follow these steps:

1. Check if we're in a Terraform directory (look for .tf files)
2. Run `terraform init` if needed
3. Run `terraform plan` with appropriate flags
...
```

### Commit Message Convention

This project uses [Conventional Commits](https://www.conventionalcommits.org/). Use the provided commit helpers:

```bash
/commit-feat    # New features
/commit-fix     # Bug fixes
/commit-docs    # Documentation changes
/commit-refactor # Code refactoring
/commit-chore   # Maintenance
```

**Commit format:**
```
<type>(<scope>): <subject>

<body>

<footer>
```

**Rules:**
- Use English for all commits
- Keep subject line under 50 characters
- Use imperative mood ("add" not "added")
- Don't include author names in commits
- Explain WHY, not WHAT in the body

### Pull Request Process

1. **Fork the repository**
   ```bash
   gh repo fork robsonalves/devops-plugins
   ```

2. **Create a feature branch**
   ```bash
   git checkout -b feat/my-new-feature
   ```

3. **Make your changes**
   - Add/modify commands
   - Update documentation
   - Test thoroughly

4. **Commit using conventional commits**
   ```bash
   /commit-feat
   ```

5. **Push to your fork**
   ```bash
   git push origin feat/my-new-feature
   ```

6. **Create a Pull Request**
   - Provide clear description
   - Reference any related issues
   - Include examples of the new command in action

### Code of Conduct

- Be respectful and inclusive
- Focus on constructive feedback
- Help others learn and grow
- Follow the project's guidelines

### Command Categories

When adding commands, place them in the appropriate category:

- **IaC**: Terraform, Terragrunt, CloudFormation, Pulumi
- **CI/CD**: Azure DevOps, GitHub Actions, GitLab CI, Jenkins
- **Containers**: Docker, Kubernetes, Helm
- **Cloud**: AWS, Azure, GCP
- **Version Control**: Git workflows
- **Monitoring**: Prometheus, Grafana, CloudWatch
- **Security**: Vault, SOPS, scanning tools

### Testing Your Contributions

Before submitting:

1. **Test the command** in Claude Code
2. **Verify prerequisites** are documented
3. **Check examples** actually work
4. **Update README** with new command
5. **Run through the workflow** end-to-end

### Ideas for New Commands

See the [Roadmap](README.md#roadmap) section in README.md for planned features. Some ideas:

- Docker/Docker Compose helpers
- GitHub Actions workflow commands
- Vault/Secrets management
- Ansible playbook helpers
- GitOps (ArgoCD/Flux) commands
- Security scanning integration
- Cost optimization helpers

### Questions?

- Open an issue for questions
- Start a discussion for ideas
- Tag @robsonalves for review

Thank you for contributing!
