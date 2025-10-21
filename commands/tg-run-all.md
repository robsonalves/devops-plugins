# Terragrunt Run-All Command

You are helping execute Terragrunt commands across multiple modules. Follow these steps:

1. Verify we're in a Terragrunt directory (look for terragrunt.hcl files)
2. Understand the module structure and dependencies
3. Run the requested terragrunt command:
   - `terragrunt run-all plan` for planning all modules
   - `terragrunt run-all apply` for applying all modules
   - `terragrunt run-all destroy` for destroying all modules
   - `terragrunt run-all validate` for validating all modules
4. Analyze the dependency graph if issues occur
5. Handle errors in specific modules appropriately

Safety considerations:
- Review dependency order before bulk operations
- Use `--terragrunt-ignore-dependency-errors` cautiously
- Consider `--terragrunt-non-interactive` for automation
- Always review plan output before apply

Options available:
- `--terragrunt-working-dir` to specify directory
- `--terragrunt-include-dir` to target specific modules
- `--terragrunt-exclude-dir` to skip specific modules
- `--terragrunt-strict-include` for precise targeting
