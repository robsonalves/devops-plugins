# Kubernetes Logs Viewer

You are helping view and analyze Kubernetes pod logs. Follow these steps:

1. Verify kubectl is configured
2. Identify the pod to check:
   - Exact pod name if known
   - Use label selectors to find pods
   - Check deployment/statefulset pods
3. Retrieve logs with appropriate options
4. Analyze logs for:
   - Error messages and stack traces
   - Warning messages
   - Patterns indicating issues
   - Performance problems
   - Startup/shutdown issues
5. Suggest fixes based on log analysis

Basic log commands:
```bash
# Get logs from a pod
kubectl logs <pod-name> -n <namespace>

# Follow logs in real-time
kubectl logs -f <pod-name> -n <namespace>

# Get logs from specific container in multi-container pod
kubectl logs <pod-name> -c <container-name> -n <namespace>

# Get previous container logs (after crash)
kubectl logs <pod-name> --previous -n <namespace>

# Get logs from all pods in deployment
kubectl logs -l app=<app-label> -n <namespace>

# Tail last N lines
kubectl logs <pod-name> -n <namespace> --tail=100

# Logs since timestamp
kubectl logs <pod-name> -n <namespace> --since=1h
```

Advanced options:
```bash
# Logs from all containers in pod
kubectl logs <pod-name> --all-containers -n <namespace>

# Logs with timestamps
kubectl logs <pod-name> -n <namespace> --timestamps

# Stream logs from multiple pods
kubectl logs -l app=<label> -n <namespace> --all-containers --prefix
```

Common log analysis patterns:
- **Application errors**: Stack traces, exceptions, error codes
- **HTTP errors**: 4xx/5xx status codes, timeouts
- **Database errors**: Connection failures, query timeouts
- **Resource issues**: OOM messages, disk space warnings
- **Startup problems**: Initialization failures, config errors
- **Crash indicators**: Panic messages, segfaults, exit codes

Troubleshooting tips:
1. If pod is crash looping, use `--previous` to see why it crashed
2. For multi-container pods, check all containers including init containers
3. Use `-f` (follow) to watch logs in real-time during debugging
4. Combine with `grep` or filter for specific patterns
5. Check timestamps to correlate with events or incidents
