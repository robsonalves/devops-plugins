# Feature Commit (Conventional Commits)

You are helping create a feature commit following Conventional Commits. This is for NEW functionality being added to the codebase.

Follow these steps:

1. Review changes with `git status` and `git diff --staged`
2. Verify this is truly a new feature (not a fix or refactor)
3. Identify the scope (component/module affected)
4. Create commit with format: `feat(<scope>): <description>`

Guidelines:
- Use imperative mood: "add" not "added" or "adds"
- Be specific about what feature is being added
- Keep subject under 50 characters
- Add detailed body explaining WHY this feature is needed
- Reference any related issues or tickets
- Mark breaking changes with `!` if applicable

Examples:
```
feat(k8s): add horizontal pod autoscaling configuration

Implemented HPA for production workloads to handle traffic spikes.
Configured CPU and memory-based scaling with min 2, max 10 replicas.

Closes #456
```

```
feat(monitoring): add Prometheus metrics endpoint

Exposed /metrics endpoint with custom business metrics including
request latency, error rates, and database query performance.
```

```
feat(terraform): add multi-region RDS failover support

Implemented automated failover configuration for RDS instances
across us-east-1 and us-west-2 regions.

BREAKING CHANGE: requires updated AWS provider version >= 5.0
```

Remember: Features are for NEW capabilities. If you're fixing a bug, use `fix`. If you're changing existing code without adding features, use `refactor`.
