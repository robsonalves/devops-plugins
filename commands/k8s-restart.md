# Kubernetes Restart Resources

You are helping restart Kubernetes resources (Deployments, StatefulSets, DaemonSets, Pods). This is useful for applying configuration changes, troubleshooting, or forcing a refresh.

Follow these steps:

1. **Identify what needs to be restarted**:
   - Ask user for resource type and name
   - Common types: Deployment, StatefulSet, DaemonSet, Pod
   - If not specified, help identify the resource

2. **Check current resource status**:
   ```bash
   # For deployment
   kubectl get deployment <name> -n <namespace>

   # For statefulset
   kubectl get statefulset <name> -n <namespace>

   # For daemonset
   kubectl get daemonset <name> -n <namespace>

   # Show pod status
   kubectl get pods -n <namespace> -l app=<app-label>
   ```

3. **Choose appropriate restart method**:

   **Method 1: Rolling restart (preferred for Deployments/StatefulSets)**:
   ```bash
   # Kubernetes 1.15+
   kubectl rollout restart deployment/<name> -n <namespace>
   kubectl rollout restart statefulset/<name> -n <namespace>
   kubectl rollout restart daemonset/<name> -n <namespace>
   ```
   - Zero downtime (if replicas > 1)
   - Gradual rollout
   - Respects PodDisruptionBudgets
   - Can be monitored and rolled back

   **Method 2: Scale to zero and back (for testing/dev)**:
   ```bash
   # Scale down
   kubectl scale deployment/<name> --replicas=0 -n <namespace>

   # Wait a moment
   sleep 5

   # Scale back up
   kubectl scale deployment/<name> --replicas=3 -n <namespace>
   ```
   - Causes downtime
   - Useful for dev/testing
   - Ensures clean start

   **Method 3: Delete pods (for StatefulSets with specific pod)**:
   ```bash
   # Delete specific pod (will be recreated)
   kubectl delete pod <pod-name> -n <namespace>

   # For StatefulSet, pods restart in order
   ```

   **Method 4: Update annotation (trigger rollout)**:
   ```bash
   # Add/update annotation to trigger restart
   kubectl patch deployment <name> -n <namespace> \
     -p '{"spec":{"template":{"metadata":{"annotations":{"kubectl.kubernetes.io/restartedAt":"'$(date +%Y-%m-%dT%H:%M:%S)'"}}}}}'
   ```

4. **Execute the restart**:
   ```bash
   # Recommended: Rolling restart
   kubectl rollout restart deployment/<name> -n <namespace>
   ```

5. **Monitor the restart**:
   ```bash
   # Watch rollout status
   kubectl rollout status deployment/<name> -n <namespace>

   # Watch pods
   kubectl get pods -n <namespace> -l app=<app-label> -w

   # Check events
   kubectl get events -n <namespace> --sort-by='.lastTimestamp'
   ```

6. **Verify successful restart**:
   ```bash
   # Check deployment status
   kubectl get deployment <name> -n <namespace>

   # Check pod status (all should be Running and Ready)
   kubectl get pods -n <namespace> -l app=<app-label>

   # Check pod logs for startup
   kubectl logs -n <namespace> -l app=<app-label> --tail=50

   # Verify application health
   kubectl exec -n <namespace> <pod-name> -- curl -f http://localhost:8080/health
   ```

7. **Handle failures**:
   ```bash
   # If restart fails, check events
   kubectl describe deployment <name> -n <namespace>

   # Check pod logs
   kubectl logs -n <namespace> <pod-name>

   # Rollback if needed
   kubectl rollout undo deployment/<name> -n <namespace>
   ```

Common scenarios:

**Scenario 1: Apply ConfigMap/Secret changes**:
```bash
# ConfigMap/Secret updated but pods not picking up changes

# Restart deployment to pick up new config
kubectl rollout restart deployment/myapp -n production

# Monitor
kubectl rollout status deployment/myapp -n production

# Verify
kubectl logs -n production -l app=myapp --tail=20
```

**Scenario 2: Application not responding**:
```bash
# App pods seem stuck or unresponsive

# Check pod status
kubectl get pods -n production -l app=myapp

# Restart
kubectl rollout restart deployment/myapp -n production

# Watch it come back up
kubectl get pods -n production -l app=myapp -w
```

**Scenario 3: Single pod issue in StatefulSet**:
```bash
# One specific pod having issues

# Delete just that pod
kubectl delete pod myapp-2 -n production

# Watch it recreate
kubectl get pods -n production -w

# Verify new pod is healthy
kubectl logs myapp-2 -n production
```

**Scenario 4: Emergency restart (downtime acceptable)**:
```bash
# Quick restart needed, downtime ok

# Scale to zero
kubectl scale deployment/myapp --replicas=0 -n production

# Wait for all pods to terminate
kubectl get pods -n production -l app=myapp

# Scale back up
kubectl scale deployment/myapp --replicas=3 -n production
```

**Scenario 5: DaemonSet restart**:
```bash
# Restart DaemonSet across all nodes

kubectl rollout restart daemonset/logging-agent -n kube-system

# Monitor - will restart on each node
kubectl rollout status daemonset/logging-agent -n kube-system
```

**Scenario 6: Restart all deployments in namespace**:
```bash
# Restart everything in namespace (rare, be careful!)

# Get all deployments
kubectl get deployments -n staging

# Restart each
for deploy in $(kubectl get deployments -n staging -o name); do
  kubectl rollout restart $deploy -n staging
done
```

Advanced options:

**Restart with max unavailability control**:
```yaml
# Edit deployment first
spec:
  strategy:
    rollingUpdate:
      maxUnavailable: 1  # Only allow 1 pod down at a time
      maxSurge: 1        # Allow 1 extra pod during update

# Then restart
kubectl rollout restart deployment/myapp -n production
```

**Restart pods based on node**:
```bash
# Restart pods on specific node (useful for node maintenance)

# Get pods on node
kubectl get pods --all-namespaces -o wide --field-selector spec.nodeName=node-1

# Delete pods on that node (will reschedule)
kubectl get pods --all-namespaces -o wide --field-selector spec.nodeName=node-1 -o name | xargs kubectl delete
```

**Graceful restart with health checks**:
```bash
# Restart and verify each step

# 1. Start restart
kubectl rollout restart deployment/myapp -n production

# 2. Watch status
kubectl rollout status deployment/myapp -n production --timeout=5m

# 3. If successful, verify health
kubectl get pods -n production -l app=myapp

# 4. Check logs
kubectl logs -n production -l app=myapp --tail=20

# 5. Run health check
kubectl exec -n production <pod-name> -- curl -f http://localhost:8080/health
```

Safety checks and warnings:

**Before restart**:
- Check if this is a production resource
- Verify replica count (if < 2, will cause downtime)
- Check PodDisruptionBudget
- Confirm user wants to proceed

**During restart**:
- Monitor rollout status
- Watch for errors
- Check new pods are starting correctly
- Verify health checks passing

**After restart**:
- Confirm all pods are Running
- Check application logs for errors
- Verify service connectivity
- Test application endpoints

**Warnings to show**:
- If replicas = 1: "Warning: This will cause downtime"
- If production: "Warning: Restarting production resource"
- If PDB exists: "PodDisruptionBudget may slow restart"
- If StatefulSet: "Pods will restart in order"

Best practices:

1. **Prefer rolling restarts**: Use `kubectl rollout restart`
2. **Monitor the restart**: Don't restart and walk away
3. **Check logs**: Verify new pods started successfully
4. **Have rollback ready**: Know how to undo if issues
5. **During business hours**: Restart in maintenance windows when possible
6. **Test in dev first**: If possible, test the restart in non-prod
7. **Update ConfigMaps properly**: Consider using reloader for auto-restarts

Rollback procedure:

```bash
# If restart causes issues

# 1. Rollback to previous version
kubectl rollout undo deployment/myapp -n production

# 2. Monitor rollback
kubectl rollout status deployment/myapp -n production

# 3. Verify pods are healthy
kubectl get pods -n production -l app=myapp

# 4. Check logs
kubectl logs -n production -l app=myapp --tail=50
```

Common reasons to restart:
1. Apply ConfigMap or Secret changes
2. Clear application memory/cache
3. Fix stuck or unresponsive pods
4. Apply resource limit changes
5. Refresh application state
6. Troubleshooting unknown issues
7. After updating container image

Post-restart verification checklist:
- [ ] All pods in Running state
- [ ] All pods show Ready
- [ ] No crash loops
- [ ] Application logs show successful startup
- [ ] Health checks passing
- [ ] Service endpoints updated
- [ ] Application responding to requests
- [ ] No errors in pod events

Troubleshooting restart issues:

**Pods not starting**:
```bash
kubectl describe pod <pod-name> -n <namespace>
kubectl logs <pod-name> -n <namespace> --previous
```

**Rollout stuck**:
```bash
kubectl rollout status deployment/myapp -n production
kubectl rollout pause deployment/myapp -n production  # Pause if needed
kubectl rollout resume deployment/myapp -n production  # Resume
```

**ImagePullBackOff after restart**:
```bash
# Check image pull secrets
kubectl get pods <pod-name> -n <namespace> -o yaml | grep -A5 imagePullSecrets
```

**Insufficient resources**:
```bash
# Check node resources
kubectl describe node <node-name>

# Check pod resource requests
kubectl describe pod <pod-name> -n <namespace> | grep -A5 Requests
```
