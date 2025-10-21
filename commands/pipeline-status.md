# Azure DevOps Pipeline Status

You are helping check Azure DevOps pipeline status. Follow these steps:

1. Verify Azure DevOps CLI is configured
2. Identify the pipeline run to check:
   - Run ID (if known)
   - Pipeline name to get latest run
   - Specific build number
3. Get pipeline run status:
   ```
   az pipelines runs show --id <run-id> --organization <org-url> --project <project>
   ```
4. Display key information:
   - Status (inProgress, completed, cancelling, etc.)
   - Result (succeeded, failed, canceled, partiallySucceeded)
   - Start time and duration
   - Triggered by
   - Source branch and commit
   - Stages/jobs status breakdown
5. For failed runs, identify which stage/job failed
6. Provide link to view logs in browser

List recent runs:
```
az pipelines runs list --pipeline-name <name> --top 10 --organization <org-url> --project <project>
```

Useful filters:
- `--status` to filter by status (inProgress, completed, etc.)
- `--result` to filter by result (succeeded, failed, etc.)
- `--branch` to filter by branch
- `--reason` to filter by trigger reason (manual, pullRequest, CI, etc.)

Output formats:
- Use `--output table` for quick overview
- Use `--output json` for detailed information
