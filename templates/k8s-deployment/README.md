# Kubernetes Deployment Template

Production-ready Kubernetes deployment template with best practices.

## Files

- `deployment.yaml` - Main application deployment
- `service.yaml` - ClusterIP and headless services
- `configmap.yaml` - Application configuration
- `secret.yaml` - Sensitive data (credentials, keys)
- `ingress.yaml` - External access configuration
- `hpa.yaml` - Horizontal Pod Autoscaler
- `serviceaccount.yaml` - Service account and RBAC

## Quick Start

1. **Customize the templates** for your application
2. **Create namespace**:
   ```bash
   kubectl create namespace myapp
   ```

3. **Apply configurations**:
   ```bash
   kubectl apply -f configmap.yaml
   kubectl apply -f secret.yaml
   kubectl apply -f serviceaccount.yaml
   kubectl apply -f deployment.yaml
   kubectl apply -f service.yaml
   kubectl apply -f ingress.yaml
   kubectl apply -f hpa.yaml
   ```

4. **Or use kustomize**:
   ```bash
   kubectl apply -k .
   ```

## Using DevOps Toolkit

```bash
# Validate before applying
/k8s-apply

# Check status
/k8s-status

# View logs
/k8s-logs

# Debug if issues
/k8s-debug
```

## Configuration

### Required Changes

Update these values in the templates:

1. **deployment.yaml**:
   - `image`: Your container image
   - `namespace`: Your namespace
   - Resource limits/requests
   - Environment variables

2. **service.yaml**:
   - `namespace`: Your namespace
   - Ports if different

3. **configmap.yaml**:
   - Application configuration values

4. **secret.yaml**:
   - Database credentials
   - API keys
   - Create image pull secret

5. **ingress.yaml**:
   - `host`: Your domain
   - TLS certificate name

## Features

### Deployment
- Rolling update strategy
- Health checks (liveness & readiness)
- Resource limits and requests
- Security context (non-root user)
- Pod anti-affinity for HA
- ConfigMap and Secret mounting

### Service
- ClusterIP service for internal access
- Headless service for direct pod access

### Autoscaling
- HPA with CPU and memory metrics
- Min 3, max 10 replicas
- Smart scale up/down behavior

### Ingress
- HTTPS with Let's Encrypt
- Rate limiting
- SSL redirect

## Best Practices Included

1. **Security**:
   - Non-root user (UID 1000)
   - Read-only root filesystem option
   - Image pull secrets
   - Service account with minimal permissions

2. **Reliability**:
   - Multiple replicas (3+)
   - Health checks
   - Graceful shutdown
   - Pod anti-affinity

3. **Observability**:
   - Prometheus metrics annotations
   - Structured logging
   - Pod name/namespace env vars

4. **Resource Management**:
   - CPU/Memory requests and limits
   - Horizontal Pod Autoscaling
   - Proper resource sizing

5. **Configuration**:
   - Externalized config (ConfigMap)
   - Secrets for sensitive data
   - Environment-specific values

## Deployment Workflow

```bash
# 1. Create/update ConfigMap
kubectl apply -f configmap.yaml

# 2. Create/update Secrets
kubectl apply -f secret.yaml

# 3. Deploy application
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml

# 4. Set up autoscaling
kubectl apply -f hpa.yaml

# 5. Configure ingress
kubectl apply -f ingress.yaml

# 6. Verify deployment
kubectl get pods -n myapp
kubectl get svc -n myapp
kubectl get ing -n myapp

# 7. Check logs
kubectl logs -n myapp -l app=myapp

# 8. Test health endpoint
kubectl exec -n myapp <pod-name> -- curl http://localhost:8080/health
```

## Troubleshooting

Use the DevOps Toolkit commands:

```bash
# Check overall status
/k8s-status

# View application logs
/k8s-logs

# Debug pod issues
/k8s-debug

# Restart if needed
/k8s-restart
```

## Customization

### Different Application Types

**Stateless API**:
- Use this template as-is
- Adjust replica count
- Configure HPA metrics

**Background Worker**:
- Remove ingress
- Adjust health checks
- May not need multiple replicas

**StatefulSet** (databases, etc):
- Use StatefulSet instead of Deployment
- Add PersistentVolumeClaims
- Configure headless service

### Environment-Specific

Create overlays for different environments:

```
├── base/
│   ├── deployment.yaml
│   ├── service.yaml
│   └── kustomization.yaml
├── overlays/
│   ├── dev/
│   │   └── kustomization.yaml
│   ├── staging/
│   │   └── kustomization.yaml
│   └── prod/
│       └── kustomization.yaml
```

## Monitoring

Add monitoring with Prometheus:

```yaml
annotations:
  prometheus.io/scrape: "true"
  prometheus.io/port: "8080"
  prometheus.io/path: "/metrics"
```

## Next Steps

1. Set up CI/CD pipeline to deploy these manifests
2. Configure monitoring and alerting
3. Set up log aggregation
4. Implement backup procedures (if stateful)
5. Document runbooks for common operations

## License

MIT
