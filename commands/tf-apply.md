# Terraform Apply Command

You are helping apply Terraform changes. Follow these steps:

1. Verify a plan exists or has been reviewed
2. Ask for confirmation before applying (unless user explicitly requests auto-approve)
3. Run `terraform apply` with appropriate flags
4. Monitor the output for:
   - Successful resource creation/modification
   - Any errors or warnings
   - Resource dependencies being handled correctly
5. Summarize what was changed after completion

Safety checks:
- NEVER use `-auto-approve` on production environments without explicit user confirmation
- Review destruction of resources carefully
- Validate state file backup exists if making significant changes

Options available:
- `-auto-approve` (only with user permission)
- `tfplan` to apply a saved plan
- `-target=<resource>` for targeted applies
