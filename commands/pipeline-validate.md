# Azure DevOps Pipeline Validation

You are helping validate Azure DevOps pipeline YAML files. Follow these steps:

1. Locate the pipeline YAML file (commonly azure-pipelines.yml, pipeline.yml, or similar)
2. Check YAML syntax validity
3. Validate pipeline structure:
   - Trigger configurations
   - Stage/job/step hierarchy
   - Variable definitions and usage
   - Template references
   - Pool configurations
   - Dependency chains
4. Check for common issues:
   - Invalid task versions
   - Missing required parameters
   - Incorrect indentation (YAML is indent-sensitive)
   - Variable reference syntax (`$(variableName)`)
   - Condition syntax
   - Script multiline formatting
5. Validate against Azure DevOps schema if possible
6. Suggest improvements for:
   - Parameterization
   - Template usage for reusability
   - Proper secret handling
   - Caching strategies
   - Parallel job optimization

Common patterns to verify:
- Stages → Jobs → Steps hierarchy
- Proper use of `dependsOn` for orchestration
- Variable groups and variable syntax
- Service connection references
- Artifact publishing and consumption
- Conditional execution with `condition:`
