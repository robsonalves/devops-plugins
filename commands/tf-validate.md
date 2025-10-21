# Terraform Validate Command

You are helping validate Terraform configuration. Follow these steps:

1. Run `terraform fmt -check -recursive` to check formatting
2. Run `terraform validate` to check configuration syntax
3. Run `terraform fmt -recursive` if formatting issues are found (ask user first)
4. Check for common issues:
   - Missing required variables
   - Invalid resource references
   - Syntax errors in HCL
   - Provider version conflicts
5. Suggest fixes for any issues found

Best practices to check:
- Consistent formatting
- Proper variable definitions with descriptions
- Output definitions where appropriate
- Resource naming conventions
- Use of locals for DRY principle
