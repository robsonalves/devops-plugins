# Terraform Documentation Generator

You are helping generate documentation for Terraform modules. Follow these steps:

1. Check if terraform-docs is installed (`terraform-docs --version`)
2. Analyze the Terraform module structure
3. Generate documentation using terraform-docs:
   - `terraform-docs markdown table .` for README format
   - `terraform-docs markdown document .` for detailed docs
4. Update README.md with generated documentation
5. Ensure documentation includes:
   - Module description
   - Requirements (Terraform version, providers)
   - Inputs (variables) with types and descriptions
   - Outputs with descriptions
   - Usage examples

Best practices:
- Keep README.md updated with each change
- Use meaningful variable descriptions
- Include usage examples
- Document provider version constraints
- Add examples directory for common use cases

If terraform-docs is not installed, guide user to install:
- macOS: `brew install terraform-docs`
- Linux: Download from GitHub releases
- Or use Docker: `docker run --rm -v $(pwd):/terraform-docs quay.io/terraform-docs/terraform-docs`
