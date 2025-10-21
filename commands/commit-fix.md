# Bug Fix Commit (Conventional Commits)

You are helping create a bug fix commit following Conventional Commits. This is for fixing bugs or issues in existing functionality.

Follow these steps:

1. Review changes with `git status` and `git diff --staged`
2. Verify this is fixing a bug (not adding new functionality)
3. Identify the scope (component/module affected)
4. Create commit with format: `fix(<scope>): <description>`

Guidelines:
- Use imperative mood: "fix" not "fixed" or "fixes"
- Clearly state what bug is being fixed
- Keep subject under 50 characters
- Add body explaining:
  - What was broken
  - What was the root cause
  - How it's fixed
- Reference issue numbers if available
- Include reproduction steps if helpful

Examples:
```
fix(pipeline): resolve terraform state locking timeout

The terraform state lock was not being released properly when
pipeline jobs were cancelled, causing subsequent runs to timeout.

Added proper cleanup in pipeline finally blocks and reduced
lock timeout from 10m to 5m.

Fixes #789
```

```
fix(k8s): correct memory limits causing OOMKilled pods

Pods were being killed due to memory limits set too low (256Mi).
Increased limits to 512Mi based on actual usage patterns observed
in production metrics.

Closes #234
```

```
fix(cloudformation): handle missing DeletionPolicy on S3 buckets

S3 buckets were being deleted during stack updates, causing data loss.
Added DeletionPolicy: Retain to prevent accidental deletion.

BREAKING CHANGE: manual bucket cleanup now required when removing from stack
```

Remember: Fixes are for CORRECTING bugs. If you're adding new functionality, use `feat`. If you're improving code without fixing bugs, use `refactor` or `perf`.
