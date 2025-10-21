# Kubernetes Pod Debug Helper

You are helping debug Kubernetes pod issues. Follow these steps:

1. Identify the problematic pod(s)
2. Gather initial information:
   - Pod status and conditions
   - Recent events
   - Container restart counts
3. Determine the type of issue:
   - Startup failures
   - Runtime crashes
   - Network issues
   - Resource constraints
   - Configuration problems
4. Use appropriate debug techniques
5. Suggest fixes based on findings

Initial diagnosis:
```bash
# Get pod status
kubectl get pod <pod-name> -n <namespace> -o wide

# Describe pod for events and details
kubectl describe pod <pod-name> -n <namespace>

# Check logs (current and previous)
kubectl logs <pod-name> -n <namespace>
kubectl logs <pod-name> -n <namespace> --previous

# Check all containers in pod
kubectl get pod <pod-name> -n <namespace> -o jsonpath='{.spec.containers[*].name}'
```

Debug techniques by issue type:

**Startup/CrashLoopBackOff:**
```bash
# Check logs from crashed container
kubectl logs <pod-name> -n <namespace> --previous

# Check init containers
kubectl logs <pod-name> -n <namespace> -c <init-container-name>

# Exec into pod (if it stays running long enough)
kubectl exec -it <pod-name> -n <namespace> -- /bin/sh

# Run debug container in pod's namespace
kubectl debug <pod-name> -n <namespace> -it --image=busybox
```

**Network issues:**
```bash
# Check service endpoints
kubectl get endpoints <service-name> -n <namespace>

# Test DNS resolution
kubectl run -it --rm debug --image=busybox --restart=Never -n <namespace> -- nslookup <service-name>

# Test connectivity
kubectl run -it --rm debug --image=nicolaka/netshoot --restart=Never -n <namespace> -- /bin/bash

# Check network policies
kubectl get networkpolicies -n <namespace>

# Describe service
kubectl describe service <service-name> -n <namespace>
```

**Resource constraints:**
```bash
# Check node resources
kubectl describe node <node-name>

# Check pod resource usage
kubectl top pod <pod-name> -n <namespace>

# Check pod resource requests/limits
kubectl get pod <pod-name> -n <namespace> -o jsonpath='{.spec.containers[*].resources}'

# Check events for evictions
kubectl get events -n <namespace> --field-selector reason=Evicted
```

**Configuration issues:**
```bash
# Check environment variables
kubectl get pod <pod-name> -n <namespace> -o jsonpath='{.spec.containers[*].env}'

# Check mounted volumes
kubectl get pod <pod-name> -n <namespace> -o jsonpath='{.spec.volumes}'

# Check configmaps
kubectl get configmap -n <namespace>
kubectl describe configmap <configmap-name> -n <namespace>

# Check secrets (values are base64 encoded)
kubectl get secrets -n <namespace>
kubectl describe secret <secret-name> -n <namespace>
```

**Permission issues:**
```bash
# Check service account
kubectl get pod <pod-name> -n <namespace> -o jsonpath='{.spec.serviceAccountName}'

# Check RBAC
kubectl get rolebindings,clusterrolebindings -n <namespace>

# Check pod security policies
kubectl get psp
```

Advanced debugging:
```bash
# Create debug copy of pod
kubectl debug <pod-name> -n <namespace> -it --copy-to=<debug-pod-name> --container=<container-name> -- sh

# Debug with different image
kubectl debug <pod-name> -n <namespace> -it --copy-to=<debug-pod-name> --set-image=<container>=busybox

# Attach to running container
kubectl attach <pod-name> -n <namespace> -c <container-name> -it

# Get full pod yaml
kubectl get pod <pod-name> -n <namespace> -o yaml
```

Common issues and solutions:

1. **ImagePullBackOff**: Check image name, registry auth, network to registry
2. **CrashLoopBackOff**: Check logs (--previous), startup command, health probes
3. **Pending**: Check node resources, scheduling constraints, PVC binding
4. **OOMKilled**: Increase memory limits, check for memory leaks
5. **Service not reachable**: Check endpoints, selectors, network policies
6. **Config not updating**: Check configMap/secret, may need pod restart
7. **Permission denied**: Check RBAC, service accounts, pod security

Quick health check command:
```bash
kubectl get pod <pod-name> -n <namespace> -o json | jq '{
  name: .metadata.name,
  status: .status.phase,
  ready: .status.conditions[] | select(.type=="Ready") | .status,
  restarts: .status.containerStatuses[].restartCount,
  image: .spec.containers[].image
}'
```
