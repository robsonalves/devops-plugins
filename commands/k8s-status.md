# Kubernetes Status Checker

You are helping check the status of Kubernetes resources. Follow these steps:

1. Verify kubectl is configured (`kubectl config current-context`)
2. Determine what resources to check:
   - All resources: `kubectl get all -n <namespace>`
   - Specific resource type: pods, deployments, services, ingresses, etc.
   - Specific namespace or all namespaces (`-A`)
3. Check resource status and health:
   - Pod status: Running, Pending, CrashLoopBackOff, Error, etc.
   - Ready replicas vs desired replicas
   - Recent events
   - Resource age
4. For unhealthy resources, investigate:
   - Pod restarts
   - Container status
   - Events showing issues
   - Resource limits/requests
5. Summarize overall health and any issues found

Useful commands:
```bash
# Get all resources in namespace
kubectl get all -n <namespace>

# Check pods across all namespaces
kubectl get pods -A

# Watch pod status in real-time
kubectl get pods -n <namespace> -w

# Check deployments with replicas
kubectl get deployments -n <namespace>

# Check services and endpoints
kubectl get svc,endpoints -n <namespace>

# Check ingress rules
kubectl get ingress -n <namespace>

# Wide output with more details
kubectl get pods -n <namespace> -o wide
```

Health indicators to check:
- **Pods**: STATUS should be Running, READY should be X/X (all containers ready)
- **Deployments**: READY should equal DESIRED
- **Services**: EXTERNAL-IP for LoadBalancers, CLUSTER-IP for ClusterIP
- **Nodes**: STATUS should be Ready
- **PersistentVolumeClaims**: STATUS should be Bound

Common issues:
- `ImagePullBackOff`: Container image not found or auth issues
- `CrashLoopBackOff`: Container keeps crashing, check logs
- `Pending`: Resource constraints or scheduling issues
- `ErrImagePull`: Image pull errors
- `OOMKilled`: Out of memory, increase limits
- High restart counts: Application instability
