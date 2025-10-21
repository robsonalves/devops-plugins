# Azure DevOps Pipeline Logs

You are helping view Azure DevOps pipeline logs. Follow these steps:

1. Verify Azure DevOps CLI is configured
2. Identify the pipeline run and optionally the specific task
3. Download or view logs:
   ```
   # View all logs for a run
   az pipelines runs show --id <run-id> --open

   # Get task logs
   az pipelines runs task show --id <run-id> --task-id <task-id>
   ```
4. Analyze logs for:
   - Error messages and stack traces
   - Warning messages
   - Failed commands or tests
   - Timeout issues
   - Authentication/permission errors
   - Resource constraints
5. Summarize findings and suggest fixes

Common issues to look for:
- **Build failures**: Compilation errors, missing dependencies
- **Test failures**: Failed test cases, timeout issues
- **Deployment failures**: Authentication, network, configuration errors
- **Task failures**: Missing parameters, invalid configurations
- **Timeout**: Slow tasks, infinite loops, hanging processes
- **Resource issues**: Out of memory, disk space, agent capacity

Helpful commands:
```bash
# List all runs for a pipeline
az pipelines runs list --pipeline-name <name> --top 10

# Show specific run details
az pipelines runs show --id <run-id>

# Show build log (artifact)
az pipelines runs artifact download --artifact-name <name> --run-id <run-id> --path ./logs
```

For quick troubleshooting:
1. Check the last failed stage/job
2. Look at the last successful task before failure
3. Check environment variables and secrets (redacted in logs)
4. Verify service connections and permissions
