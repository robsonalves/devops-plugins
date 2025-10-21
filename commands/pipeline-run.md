# Azure DevOps Pipeline Run

You are helping trigger an Azure DevOps pipeline run. Follow these steps:

1. Verify Azure DevOps CLI is installed (`az --version` and check for azure-devops extension)
2. Check if user is logged in (`az devops configure --list`)
3. Identify the pipeline to run:
   - Pipeline ID or name
   - Branch to run against
   - Project and organization
4. Trigger the pipeline using:
   ```
   az pipelines run --name <pipeline-name> --branch <branch> --organization <org-url> --project <project>
   ```
5. Provide the run ID and URL for monitoring
6. Optionally watch the pipeline progress

Required information:
- Organization URL (e.g., https://dev.azure.com/your-org)
- Project name
- Pipeline name or ID
- Branch (default: current branch)

Optional parameters:
- `--variables` to pass runtime variables
- `--open` to open in browser
- `--folder-path` if pipeline is in a folder

If Azure CLI is not configured:
```bash
# Install azure-devops extension
az extension add --name azure-devops

# Configure defaults
az devops configure --defaults organization=https://dev.azure.com/your-org project=your-project

# Login
az login
```
