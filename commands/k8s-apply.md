# Kubernetes Apply Manifests

You are helping apply Kubernetes manifests. Follow these steps:

1. Verify kubectl is configured and context is correct
2. Locate the manifest files (YAML or JSON)
3. Validate manifests before applying:
   - Check YAML syntax
   - Verify API versions are supported
   - Check resource quotas and limits
   - Validate selectors and labels match
4. Preview changes with `--dry-run` or `kubectl diff`
5. Apply manifests with appropriate flags
6. Verify resources are created/updated successfully
7. Monitor rollout status for deployments

Apply commands:
```bash
# Apply a single manifest
kubectl apply -f manifest.yaml

# Apply all manifests in directory
kubectl apply -f ./manifests/

# Apply with recursive subdirectories
kubectl apply -f ./k8s/ -R

# Apply from URL
kubectl apply -f https://example.com/manifest.yaml

# Apply to specific namespace
kubectl apply -f manifest.yaml -n <namespace>
```

Validation before apply:
```bash
# Dry run (client-side validation)
kubectl apply -f manifest.yaml --dry-run=client

# Server-side dry run (full validation)
kubectl apply -f manifest.yaml --dry-run=server

# Show diff of what will change
kubectl diff -f manifest.yaml

# Validate YAML syntax
kubectl apply -f manifest.yaml --validate=true

# Create namespace if it doesn't exist
kubectl create namespace <namespace> --dry-run=client -o yaml | kubectl apply -f -
```

Apply best practices:
- **Use --dry-run first**: Test without applying
- **Use kubectl diff**: See exactly what will change
- **Label resources**: Add labels for organization and selection
- **Set namespaces**: Specify namespace explicitly or in manifest
- **Version control**: Keep manifests in git
- **Use kustomize**: For environment-specific configs
- **Prune resources**: Use `--prune` to remove unmanaged resources

Monitoring after apply:
```bash
# Watch deployment rollout
kubectl rollout status deployment/<deployment-name> -n <namespace>

# Check if pods are ready
kubectl get pods -n <namespace> -w

# Check recent events
kubectl get events -n <namespace> --sort-by='.lastTimestamp'

# Verify service endpoints
kubectl get endpoints -n <namespace>
```

Common manifest validation checks:
1. **API version**: Ensure it's supported in your cluster version
2. **Kind**: Correct resource type
3. **Metadata**: Name, namespace, labels
4. **Spec**: Required fields for the resource type
5. **Selectors**: matchLabels align with template labels
6. **Resources**: Requests and limits defined
7. **Probes**: Liveness and readiness configured
8. **Image tags**: Avoid `latest`, use specific versions

Rollback if needed:
```bash
# Rollback deployment
kubectl rollout undo deployment/<deployment-name> -n <namespace>

# Rollback to specific revision
kubectl rollout undo deployment/<deployment-name> --to-revision=<revision> -n <namespace>

# Check rollout history
kubectl rollout history deployment/<deployment-name> -n <namespace>
```
