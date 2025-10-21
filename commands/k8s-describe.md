# Kubernetes Resource Describe

You are helping describe and analyze Kubernetes resources in detail. Follow these steps:

1. Verify kubectl is configured
2. Identify the resource to describe:
   - Resource type (pod, deployment, service, node, pvc, etc.)
   - Resource name
   - Namespace (if applicable)
3. Run `kubectl describe` to get detailed information
4. Analyze key sections:
   - Metadata and labels
   - Spec configuration
   - Status and conditions
   - Events (most important for troubleshooting)
   - Resource requests/limits
   - Volumes and mounts
5. Identify issues from events and status
6. Suggest remediation steps

Describe commands:
```bash
# Describe a pod
kubectl describe pod <pod-name> -n <namespace>

# Describe a deployment
kubectl describe deployment <deployment-name> -n <namespace>

# Describe a service
kubectl describe service <service-name> -n <namespace>

# Describe a node
kubectl describe node <node-name>

# Describe a persistent volume claim
kubectl describe pvc <pvc-name> -n <namespace>

# Describe an ingress
kubectl describe ingress <ingress-name> -n <namespace>

# Describe using label selector
kubectl describe pods -l app=<label> -n <namespace>
```

Key sections to analyze:

**For Pods:**
- **Status**: Running, Pending, Failed, etc.
- **Containers**: Ready state, restart count, image
- **Conditions**: PodScheduled, Initialized, ContainersReady, Ready
- **Events**: Shows scheduling, pulling images, health checks, errors
- **QoS Class**: Guaranteed, Burstable, BestEffort
- **Tolerations**: Node affinity and taints
- **Volume Mounts**: PVC bindings, config/secret mounts

**For Deployments:**
- **Replicas**: Desired vs Available vs Ready
- **Strategy**: RollingUpdate settings, max unavailable/surge
- **Conditions**: Available, Progressing
- **Events**: Scaling events, update progress
- **Pod Template**: Container specs, volumes, env vars

**For Services:**
- **Type**: ClusterIP, NodePort, LoadBalancer
- **Endpoints**: Backend pod IPs (should match ready pods)
- **Selector**: Labels used to find pods
- **Port mappings**: Target port vs service port

**For Nodes:**
- **Conditions**: Ready, MemoryPressure, DiskPressure, PIDPressure
- **Capacity/Allocatable**: CPU, memory, pods
- **Allocated Resources**: How much is in use
- **Taints**: Scheduling restrictions

Common issues found in events:
- `FailedScheduling`: Insufficient resources or node constraints
- `FailedMount`: Volume mount issues
- `FailedCreatePodSandBox`: Networking or runtime issues
- `BackOff`: Image pull or startup failures
- `Unhealthy`: Liveness/readiness probe failures
- `FailedSync`: Error syncing pod
