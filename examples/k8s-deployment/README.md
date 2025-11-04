# Kubernetes Deployment Example

This example shows a complete workflow for deploying and troubleshooting applications on Kubernetes.

## Scenario

You're deploying a microservices application with:
- Frontend (React app)
- Backend API (Node.js)
- Database (PostgreSQL)
- Redis cache

## Step-by-Step Workflow

### 1. Check Cluster Status

```bash
# Verify cluster health and resources
/k8s-status
```

Claude Code will check:
- Node status and resources
- Current deployments and their health
- Available resources
- Namespace overview

### 2. Apply Manifests

```bash
# Apply your Kubernetes manifests
/k8s-apply
```

This will:
- Validate YAML syntax
- Apply manifests with dry-run first (optional)
- Show what will be created/updated
- Apply the changes
- Verify deployment status

### 3. Monitor Deployment

```bash
# Check pod status and logs
/k8s-logs
```

Monitor your application startup:
- View pod logs in real-time
- Check for errors or warnings
- Verify successful startup

### 4. Debug Issues

If something goes wrong:

```bash
# Debug pod problems
/k8s-debug
```

Claude Code will:
- Identify the problem (CrashLoopBackOff, ImagePullBackOff, etc.)
- Gather diagnostic information
- Suggest specific fixes
- Help execute debugging commands

### 5. Verify Deployment

```bash
# Get detailed resource information
/k8s-describe
```

Review:
- Pod events
- Service endpoints
- Configuration and secrets
- Resource limits and requests

## Complete Example

### Database Deployment

```bash
# 1. Create namespace
kubectl create namespace myapp-prod

# 2. Apply database manifests
# Edit postgres-deployment.yaml with your configuration
/k8s-apply

# 3. Check status
/k8s-status

# 4. View logs to verify startup
/k8s-logs

# 5. Describe the deployment
/k8s-describe
```

### Application Deployment

```bash
# 1. Apply backend API
/k8s-apply

# 2. Monitor deployment
/k8s-logs

# If issues occur:
/k8s-debug

# 3. Apply frontend
/k8s-apply

# 4. Check overall status
/k8s-status

# 5. Commit your manifests
/commit-feat
```

Example commit:
```
feat(k8s): deploy microservices application to production

Deployed complete application stack to production cluster:
- PostgreSQL database with persistent volume
- Redis cache for session management
- Backend API with 3 replicas
- Frontend with horizontal pod autoscaling
- Ingress configuration for external access

Includes:
- Health checks and readiness probes
- Resource limits and requests
- ConfigMaps for environment-specific config
- Secrets for sensitive data

Closes #234
```

## Common Scenarios

### Scenario 1: Application Not Starting (CrashLoopBackOff)

```bash
# 1. Debug the issue
/k8s-debug

# Claude will help you:
# - Check previous logs
# - Verify environment variables
# - Check ConfigMaps and Secrets
# - Test startup command

# 2. Fix the issue in your manifests

# 3. Redeploy
/k8s-apply

# 4. Verify fix
/k8s-logs

# 5. Commit the fix
/commit-fix
```

Example fix:
```
fix(k8s): correct backend API startup command

Fixed CrashLoopBackOff by updating the startup command
to include proper Node.js arguments and wait for database
connection before starting server.

Fixes #235
```

### Scenario 2: Service Not Reachable

```bash
# 1. Check service status
/k8s-status

# 2. Describe the service
/k8s-describe

# 3. Debug connectivity
/k8s-debug

# Common issues found:
# - Selector labels mismatch
# - Service port vs container port mismatch
# - NetworkPolicy blocking traffic
# - Ingress misconfiguration

# 4. Fix and reapply
/k8s-apply
```

### Scenario 3: High Memory Usage (OOMKilled)

```bash
# 1. Check pod status
/k8s-status

# Will show: "Last State: Terminated (Reason: OOMKilled)"

# 2. Debug to get recommendations
/k8s-debug

# Claude will suggest:
# - Increasing memory limits
# - Checking for memory leaks
# - Reviewing resource requests

# 3. Update resources in your deployment
/k8s-apply

# 4. Monitor
/k8s-logs

# 5. Commit the fix
/commit-fix
```

### Scenario 4: Rolling Update

```bash
# 1. Update your container image tag in deployment.yaml

# 2. Check current status
/k8s-status

# 3. Apply the update
/k8s-apply

# 4. Monitor the rollout
/k8s-logs

# Watch pods rolling out:
kubectl rollout status deployment/backend-api -n myapp-prod

# 5. If issues, rollback
kubectl rollout undo deployment/backend-api -n myapp-prod

# 6. Commit successful update
/commit-feat
```

## Kubernetes Manifest Examples

### deployment.yaml
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend-api
  namespace: myapp-prod
spec:
  replicas: 3
  selector:
    matchLabels:
      app: backend-api
  template:
    metadata:
      labels:
        app: backend-api
    spec:
      containers:
      - name: api
        image: myapp/backend:v1.2.3
        ports:
        - containerPort: 3000
        env:
        - name: DATABASE_URL
          valueFrom:
            secretKeyRef:
              name: db-credentials
              key: url
        - name: REDIS_HOST
          valueFrom:
            configMapKeyRef:
              name: app-config
              key: redis_host
        resources:
          requests:
            memory: "256Mi"
            cpu: "250m"
          limits:
            memory: "512Mi"
            cpu: "500m"
        livenessProbe:
          httpGet:
            path: /health
            port: 3000
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /ready
            port: 3000
          initialDelaySeconds: 5
          periodSeconds: 5
```

### service.yaml
```yaml
apiVersion: v1
kind: Service
metadata:
  name: backend-api
  namespace: myapp-prod
spec:
  selector:
    app: backend-api
  ports:
  - protocol: TCP
    port: 80
    targetPort: 3000
  type: ClusterIP
```

## Workflow Commands

```bash
# Daily operations workflow
/k8s-status          # Morning health check
/k8s-logs           # Check application logs
/k8s-describe       # Investigate any issues

# Deployment workflow
/k8s-apply          # Deploy changes
/k8s-status         # Verify deployment
/k8s-logs           # Monitor startup
/commit-feat        # Commit successful deployment

# Troubleshooting workflow
/k8s-debug          # Identify and fix issues
/k8s-logs           # Verify fix
/k8s-describe       # Confirm proper configuration
/commit-fix         # Document the fix
```

## Best Practices

1. **Always check status before deploying**: Know your baseline
2. **Use health checks**: Implement proper liveness and readiness probes
3. **Set resource limits**: Prevent resource exhaustion
4. **Monitor logs during rollouts**: Catch issues early
5. **Use namespaces**: Separate environments (dev/staging/prod)
6. **Version your images**: Never use `:latest` in production
7. **Document your fixes**: Help future debugging with good commits

## Advanced Scenarios

### Blue-Green Deployment

```bash
# Deploy green version
/k8s-apply green-deployment.yaml

# Test green version
/k8s-logs

# Switch service to green
/k8s-apply switch-service.yaml

# Monitor
/k8s-status

# Keep blue for rollback or remove
kubectl delete deployment backend-api-blue -n myapp-prod
```

### Canary Deployment

```bash
# Deploy canary with 10% traffic
/k8s-apply canary-deployment.yaml

# Monitor metrics and logs
/k8s-logs

# If successful, gradually increase traffic
/k8s-apply  # Update replica counts

# Monitor again
/k8s-status
```

## Next Steps

- Check the [Terraform workflow example](../terraform-workflow/)
- Learn about [CI/CD with Azure DevOps](../azure-pipeline/)
- Explore [AWS infrastructure patterns](../aws-infrastructure/)
