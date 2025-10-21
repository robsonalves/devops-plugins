# Chore Commit (Conventional Commits)

You are helping create a chore commit following Conventional Commits. This is for maintenance tasks, dependency updates, and tooling changes that don't affect production code behavior.

Follow these steps:

1. Review changes with `git status` and `git diff --staged`
2. Verify changes are maintenance/tooling related
3. Identify the scope if applicable (deps, config, build, etc.)
4. Create commit with format: `chore(<scope>): <description>`

Guidelines:
- Use imperative mood: "update" not "updated" or "updates"
- Clearly state what maintenance task is being done
- Keep subject under 50 characters
- Add body for dependency updates with version info

Common chore scenarios:
- Dependency updates
- Build tool configuration
- Development tool setup
- .gitignore updates
- IDE configuration
- Linter/formatter configuration
- Version bumps

Examples:
```
chore(deps): upgrade terraform providers to latest versions

Updated provider versions:
- AWS provider: 4.67.0 -> 5.31.0
- Azure provider: 3.75.0 -> 3.84.0
- Kubernetes provider: 2.23.0 -> 2.24.0

Tested compatibility with existing modules.
```

```
chore(config): add pre-commit hooks for terraform validation

Configured pre-commit to run:
- terraform fmt check
- terraform validate
- tflint
- tfsec security scanning

This will catch issues before they reach CI/CD.
```

```
chore(build): update Azure DevOps agent pool configuration

Switched from Microsoft-hosted to self-hosted agents for
improved performance and cost optimization.

Updated pipeline YAML to use 'DevOps-Pool' instead of 'ubuntu-latest'.
```

```
chore: update .gitignore for terraform and IDE files

Added patterns for:
- .terraform/ directories
- *.tfstate files
- .terragrunt-cache/
- VSCode and IntelliJ settings
```

```
chore(deps): bump kubectl to v1.29.0

BREAKING CHANGE: minimum Kubernetes version is now 1.27
```

Remember: Chores are for MAINTENANCE. If you're changing application code behavior, use `feat`, `fix`, or `refactor`. Use `ci` specifically for CI/CD pipeline changes.
