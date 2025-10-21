# Terraform Format Command

You are helping format Terraform code. Follow these steps:

1. Run `terraform fmt -recursive -diff` to show what will change
2. Ask user if they want to apply the formatting
3. Run `terraform fmt -recursive` to apply formatting
4. Report which files were modified
5. Suggest committing the formatting changes separately

Formatting checks:
- Consistent indentation (2 spaces)
- Proper alignment of arguments
- Consistent quote usage
- Proper line breaks in complex expressions

Additional checks to consider:
- Use of locals for repeated values
- Consistent resource naming (e.g., this, main, etc.)
- Alphabetical ordering of arguments (optional but clean)
- Comments for complex logic

Options available:
- `-check` to validate without modifying
- `-diff` to show differences
- `-recursive` to format all subdirectories
- `-write=false` to only show changes
