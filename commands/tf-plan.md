# Terraform Plan Command

You are helping create a Terraform execution plan. Follow these steps:

1. Check if we're in a Terraform directory (look for .tf files)
2. Run `terraform init` if needed (check for .terraform directory)
3. Run `terraform plan` with appropriate flags
4. Analyze the output and summarize:
   - Resources to be created (green +)
   - Resources to be modified (yellow ~)
   - Resources to be destroyed (red -)
   - Any warnings or errors
5. If there are errors, help diagnose and fix them

Additional options you can use:
- `-out=tfplan` to save the plan
- `-var-file=<file>` if using variable files
- `-target=<resource>` for targeted plans

Always explain the changes in clear terms before suggesting to apply.
