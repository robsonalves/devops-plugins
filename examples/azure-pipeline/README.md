# Azure DevOps Pipeline Example

This example demonstrates how to create, validate, and manage Azure DevOps pipelines using the DevOps Toolkit.

## Scenario

You're setting up a CI/CD pipeline for a Node.js application that:
- Runs tests on pull requests
- Builds Docker images
- Deploys to Kubernetes
- Runs in multiple stages (Build → Test → Deploy)

## Step-by-Step Workflow

### 1. Create Pipeline YAML

Create `azure-pipelines.yml` in your repository root:

```yaml
trigger:
  branches:
    include:
    - main
    - develop

pr:
  branches:
    include:
    - main
    - develop

variables:
  dockerRegistry: 'myacr.azurecr.io'
  imageName: 'myapp/backend'
  imageTag: '$(Build.BuildId)'

stages:
- stage: Build
  displayName: 'Build and Test'
  jobs:
  - job: BuildJob
    displayName: 'Build Application'
    pool:
      vmImage: 'ubuntu-latest'
    steps:
    - task: NodeTool@0
      inputs:
        versionSpec: '18.x'
      displayName: 'Install Node.js'

    - script: |
        npm ci
        npm run build
      displayName: 'Install and Build'

    - script: |
        npm run test
        npm run test:coverage
      displayName: 'Run Tests'

    - task: PublishTestResults@2
      inputs:
        testResultsFormat: 'JUnit'
        testResultsFiles: '**/test-results.xml'
      displayName: 'Publish Test Results'

- stage: DockerBuild
  displayName: 'Build Docker Image'
  dependsOn: Build
  condition: succeeded()
  jobs:
  - job: DockerBuildJob
    displayName: 'Build and Push Docker Image'
    pool:
      vmImage: 'ubuntu-latest'
    steps:
    - task: Docker@2
      inputs:
        containerRegistry: 'MyACR'
        repository: '$(imageName)'
        command: 'buildAndPush'
        Dockerfile: '**/Dockerfile'
        tags: |
          $(imageTag)
          latest

- stage: DeployDev
  displayName: 'Deploy to Development'
  dependsOn: DockerBuild
  condition: and(succeeded(), eq(variables['Build.SourceBranch'], 'refs/heads/develop'))
  jobs:
  - deployment: DeployDev
    displayName: 'Deploy to Dev Cluster'
    pool:
      vmImage: 'ubuntu-latest'
    environment: 'development'
    strategy:
      runOnce:
        deploy:
          steps:
          - task: KubernetesManifest@0
            inputs:
              action: 'deploy'
              kubernetesServiceConnection: 'k8s-dev'
              namespace: 'myapp-dev'
              manifests: |
                k8s/deployment.yaml
                k8s/service.yaml

- stage: DeployProd
  displayName: 'Deploy to Production'
  dependsOn: DockerBuild
  condition: and(succeeded(), eq(variables['Build.SourceBranch'], 'refs/heads/main'))
  jobs:
  - deployment: DeployProd
    displayName: 'Deploy to Prod Cluster'
    pool:
      vmImage: 'ubuntu-latest'
    environment: 'production'
    strategy:
      runOnce:
        deploy:
          steps:
          - task: KubernetesManifest@0
            inputs:
              action: 'deploy'
              kubernetesServiceConnection: 'k8s-prod'
              namespace: 'myapp-prod'
              manifests: |
                k8s/deployment.yaml
                k8s/service.yaml
```

### 2. Validate Pipeline

```bash
# Validate the pipeline YAML before committing
/pipeline-validate
```

Claude Code will:
- Check YAML syntax
- Validate pipeline structure
- Verify task versions
- Check variable usage
- Suggest improvements

### 3. Commit Pipeline Configuration

```bash
/commit-feat
```

Example commit:
```
feat(ci): add Azure DevOps CI/CD pipeline

Implemented complete CI/CD pipeline with following stages:
- Build: Compile application and run tests
- Docker Build: Create and push container images to ACR
- Deploy Dev: Auto-deploy develop branch to dev cluster
- Deploy Prod: Auto-deploy main branch to production

Features:
- Automated testing with coverage reports
- Docker multi-stage builds
- Kubernetes deployment to AKS
- Environment-specific deployments
- PR validation

Closes #156
```

### 4. Trigger Pipeline Run

```bash
# After pushing to Azure DevOps, trigger a pipeline run
/pipeline-run
```

### 5. Monitor Pipeline Status

```bash
# Check pipeline execution status
/pipeline-status
```

This shows:
- Current stage
- Job statuses
- Duration
- Success/failure status

### 6. View Logs on Failure

If the pipeline fails:

```bash
# View and analyze pipeline logs
/pipeline-logs
```

Claude Code will:
- Fetch logs from failed jobs
- Highlight errors
- Suggest potential fixes
- Provide troubleshooting steps

## Complete Workflow Example

```bash
# 1. Create/edit azure-pipelines.yml
vim azure-pipelines.yml

# 2. Validate before committing
/pipeline-validate

# 3. Commit the pipeline
/commit-feat

# 4. Push to Azure DevOps
git push origin feature/add-pipeline

# 5. Monitor the pipeline
/pipeline-status

# 6. If failed, check logs
/pipeline-logs

# 7. Fix issues and commit
/commit-fix
```

## Common Scenarios

### Scenario 1: Pipeline Validation Fails

```bash
# Validate your pipeline
/pipeline-validate

# Common issues found:
# - Missing required parameters
# - Invalid task version
# - Incorrect YAML indentation
# - Variable reference errors

# Fix issues in azure-pipelines.yml

# Validate again
/pipeline-validate

# Commit when valid
/commit-fix
```

Example fix:
```
fix(ci): correct pipeline YAML indentation and task versions

Fixed Azure DevOps pipeline validation errors:
- Corrected YAML indentation in Docker task
- Updated KubernetesManifest task to latest version
- Fixed variable reference syntax for imageTag

Fixes #157
```

### Scenario 2: Pipeline Fails During Build

```bash
# Check what failed
/pipeline-status

# Get detailed logs
/pipeline-logs

# Example output shows:
# "npm ERR! Missing script: 'build'"

# Fix package.json
# Add missing build script

# Commit fix
/commit-fix

# Re-run pipeline
/pipeline-run

# Monitor
/pipeline-status
```

### Scenario 3: Docker Build Fails

```bash
# Pipeline logs show Docker build failure
/pipeline-logs

# Common issues:
# - Missing Dockerfile
# - Base image not found
# - Build context issues
# - Registry authentication

# Fix Dockerfile or pipeline configuration
/pipeline-validate

# Commit fix
/commit-fix

# Trigger new run
/pipeline-run
```

### Scenario 4: Deployment Fails

```bash
# Check pipeline status
/pipeline-status

# Get deployment logs
/pipeline-logs

# Common issues:
# - Kubernetes service connection not configured
# - Invalid manifests
# - Insufficient permissions
# - Resource quota exceeded

# Fix manifest or pipeline configuration
/k8s-apply  # Test manifest locally first

# Update pipeline
/pipeline-validate
/commit-fix
```

## Pipeline Templates

### Multi-Repository Pipeline

```yaml
# azure-pipelines.yml
trigger:
  branches:
    include:
    - main

resources:
  repositories:
  - repository: shared
    type: git
    name: DevOps/shared-templates

stages:
- stage: Build
  jobs:
  - template: templates/build-template.yml@shared
    parameters:
      buildConfiguration: 'Release'
```

### Matrix Build Strategy

```yaml
strategy:
  matrix:
    node_14:
      nodeVersion: '14.x'
    node_16:
      nodeVersion: '16.x'
    node_18:
      nodeVersion: '18.x'
  maxParallel: 3

steps:
- task: NodeTool@0
  inputs:
    versionSpec: $(nodeVersion)
```

### Conditional Deployment

```yaml
- stage: DeployProd
  condition: |
    and(
      succeeded(),
      eq(variables['Build.SourceBranch'], 'refs/heads/main'),
      eq(variables['Build.Reason'], 'Manual')
    )
```

## Advanced Patterns

### Using Variable Groups

```bash
# In Azure DevOps UI, create variable group 'prod-secrets'

# Reference in pipeline:
variables:
- group: prod-secrets

# Use in tasks:
- script: echo $(secretValue)
  env:
    SECRET: $(secretValue)
```

### Using Service Connections

```bash
# For Docker Registry:
- task: Docker@2
  inputs:
    containerRegistry: 'MyDockerHub'  # Service connection name

# For Kubernetes:
- task: KubernetesManifest@0
  inputs:
    kubernetesServiceConnection: 'AKS-Prod'  # Service connection name
```

### Caching Dependencies

```yaml
- task: Cache@2
  inputs:
    key: 'npm | "$(Agent.OS)" | package-lock.json'
    path: '$(Pipeline.Workspace)/.npm'
    restoreKeys: |
      npm | "$(Agent.OS)"
  displayName: 'Cache npm packages'

- script: npm ci --cache $(Pipeline.Workspace)/.npm
  displayName: 'Install dependencies'
```

## Best Practices

1. **Always validate before committing**: Catch errors early with `/pipeline-validate`
2. **Use templates**: Reuse common pipeline patterns
3. **Implement caching**: Speed up builds with dependency caching
4. **Use service connections**: Don't hardcode credentials
5. **Set up notifications**: Get alerted on pipeline failures
6. **Use variable groups**: Manage secrets centrally
7. **Test locally first**: Validate Kubernetes manifests before pipeline
8. **Monitor pipeline metrics**: Track build times and success rates

## Troubleshooting Guide

### Issue: Pipeline Not Triggering

```bash
# Check trigger configuration
# Ensure branch is included in trigger

trigger:
  branches:
    include:
    - main
    - feature/*
```

### Issue: Task Version Not Found

```bash
# Update to latest task version
- task: Docker@2  # Was Docker@1

# Or specify exact version
- task: Docker@2.0.0
```

### Issue: Variable Not Resolved

```bash
# Use correct syntax:
$(variableName)  # Pipeline variables
${{ variables.variableName }}  # Template parameters
```

### Issue: Slow Pipeline Execution

```bash
# Add caching
- task: Cache@2

# Use parallel jobs
strategy:
  maxParallel: 3

# Use self-hosted agents for better performance
pool:
  name: 'Self-Hosted-Pool'
```

## Integration with Other Tools

### With Terraform

```yaml
- task: TerraformInstaller@0
  inputs:
    terraformVersion: '1.6.0'

- task: TerraformTaskV4@4
  inputs:
    command: 'plan'
    workingDirectory: '$(System.DefaultWorkingDirectory)/terraform'
```

### With Kubernetes

```yaml
- task: HelmDeploy@0
  inputs:
    command: 'upgrade'
    chartType: 'FilePath'
    chartPath: './helm/myapp'
    releaseName: 'myapp'
    namespace: 'production'
```

## Next Steps

- Explore [Terraform workflow](../terraform-workflow/)
- Learn about [Kubernetes deployment](../k8s-deployment/)
- Check [AWS infrastructure examples](../aws-infrastructure/)
- Set up monitoring and alerting for your pipelines
