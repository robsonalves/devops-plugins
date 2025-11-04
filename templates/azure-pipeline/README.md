# Azure DevOps Pipeline Template

Production-ready CI/CD pipeline template for Azure DevOps.

## Features

- **Multi-stage pipeline**: Build → Docker → Deploy (Dev/Prod)
- **Automated testing**: Unit tests with coverage reports
- **Docker support**: Build and push to Azure Container Registry
- **Kubernetes deployment**: Deploy to AKS clusters
- **Environment-based deployment**: Separate dev and prod stages
- **Security scanning**: Container vulnerability scanning with Trivy
- **Caching**: NPM package caching for faster builds

## Pipeline Stages

### 1. Build and Test
- Install dependencies with caching
- Run linting
- Build application
- Run tests with coverage
- Publish test results and artifacts

### 2. Docker Build
- Build Docker image
- Push to Azure Container Registry
- Run security scan

### 3. Deploy to Development
- Triggered on `develop` branch
- Deploy to dev Kubernetes cluster
- Update ConfigMaps
- Deploy application with new image
- Verify deployment

### 4. Deploy to Production
- Triggered on `main` branch
- Deploy to prod Kubernetes cluster
- Update ConfigMaps
- Deploy application with new image
- Verify deployment and rollout status

## Prerequisites

### Azure DevOps Setup

1. **Service Connections**:
   - Azure Container Registry (Docker Registry)
   - Kubernetes clusters (dev and prod)

2. **Variable Groups** (optional):
   Create variable groups for environment-specific values:
   - `dev-variables`
   - `prod-variables`

3. **Environments**:
   - Create `development` environment
   - Create `production` environment
   - Add approval checks on production

### Repository Setup

1. **Dockerfile** in repository root
2. **Kubernetes manifests** in `k8s/` directory
3. **package.json** with scripts:
   - `lint`
   - `build`
   - `test`

## Customization

### Update Variables

```yaml
variables:
  dockerRegistry: 'your-registry.azurecr.io'
  imageName: 'your-app-name'
  k8sNamespace: 'your-namespace'
```

### Add Environment Variables

```yaml
- task: KubernetesManifest@0
  inputs:
    action: 'deploy'
    manifests: |
      k8s/deployment.yaml
    containers: |
      $(dockerRegistry)/$(imageName):$(imageTag)
    # Add environment variables
    env:
      DATABASE_URL: $(DATABASE_URL)
      API_KEY: $(API_KEY)
```

### Add Approval Gates

In Azure DevOps:
1. Go to Environments → Production
2. Add approvals and checks
3. Configure approval groups

### Multi-Region Deployment

```yaml
- stage: DeployProdEast
  displayName: 'Deploy to Prod (East)'
  jobs:
  - deployment: DeployProdEast
    environment: 'production-east'
    # ... deploy steps

- stage: DeployProdWest
  displayName: 'Deploy to Prod (West)'
  dependsOn: DeployProdEast
  jobs:
  - deployment: DeployProdWest
    environment: 'production-west'
    # ... deploy steps
```

## Using DevOps Toolkit

```bash
# Validate pipeline before committing
/pipeline-validate

# Trigger pipeline run
/pipeline-run

# Check status
/pipeline-status

# View logs if failed
/pipeline-logs

# Commit pipeline changes
/commit-feat
```

## Testing the Pipeline

1. **Create a feature branch**:
   ```bash
   git checkout -b feature/test-pipeline
   ```

2. **Commit the pipeline**:
   ```bash
   /commit-feat
   ```

3. **Push and create PR**:
   ```bash
   git push origin feature/test-pipeline
   ```

4. **Monitor the pipeline**:
   ```bash
   /pipeline-status
   ```

## Troubleshooting

### Pipeline Fails at Build

```bash
# Check build logs
/pipeline-logs

# Common issues:
# - Missing dependencies
# - Test failures
# - Lint errors
```

### Docker Build Fails

```bash
# Common issues:
# - Invalid Dockerfile
# - Missing files in build context
# - Registry authentication
```

### Deployment Fails

```bash
# Check Kubernetes cluster
/k8s-status

# Common issues:
# - Invalid manifests
# - Missing secrets/configmaps
# - Service connection not configured
# - Insufficient cluster resources
```

## Advanced Features

### Parallel Jobs

```yaml
jobs:
- job: TestNode14
  pool:
    vmImage: 'ubuntu-latest'
  steps:
  - script: npm test
    displayName: 'Test on Node 14'

- job: TestNode16
  pool:
    vmImage: 'ubuntu-latest'
  steps:
  - script: npm test
    displayName: 'Test on Node 16'
```

### Template Usage

Create reusable templates:

```yaml
# templates/build-template.yml
parameters:
  - name: buildConfiguration
    type: string
    default: 'Release'

steps:
- script: npm run build
  displayName: 'Build Application'
```

Use in main pipeline:

```yaml
steps:
- template: templates/build-template.yml
  parameters:
    buildConfiguration: 'Release'
```

### Matrix Strategy

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
```

## Best Practices

1. **Use caching**: Speed up builds with dependency caching
2. **Run tests in parallel**: Reduce build time
3. **Security scanning**: Scan container images
4. **Approval gates**: Protect production deployments
5. **Environment separation**: Use different configs per environment
6. **Version tagging**: Tag images with build ID
7. **Rollback strategy**: Keep previous versions for quick rollback
8. **Monitoring**: Set up notifications for pipeline failures

## Next Steps

1. Add integration tests
2. Set up staging environment
3. Implement canary deployments
4. Add performance tests
5. Set up monitoring and alerting
6. Configure backup and disaster recovery

## License

MIT
