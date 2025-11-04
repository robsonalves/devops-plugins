# Git Branch Cleanup

You are helping clean up local Git branches that have been merged. This helps maintain a clean local repository.

Follow these steps:

1. **Check current branch and status**:
   ```bash
   git branch
   git status
   ```

2. **Fetch latest from remote to update references**:
   ```bash
   git fetch --all --prune
   ```

3. **List merged branches** (excluding current and main branches):
   ```bash
   # Show branches merged into current branch
   git branch --merged

   # Show branches merged into main/master
   git branch --merged main 2>/dev/null || git branch --merged master 2>/dev/null
   ```

4. **Identify safe-to-delete branches**:
   - Exclude: main, master, develop, current branch
   - Only suggest branches that are fully merged
   - Warn about any uncommitted changes

5. **Show which branches will be deleted**:
   ```bash
   # List local branches that are merged and safe to delete
   git branch --merged | grep -v "\*" | grep -v "main" | grep -v "master" | grep -v "develop"
   ```

6. **Ask user for confirmation** before deleting

7. **Delete merged branches**:
   ```bash
   # Delete merged branches (one by one for safety)
   git branch -d <branch-name>

   # Or batch delete (more aggressive):
   git branch --merged | grep -v "\*" | grep -v "main" | grep -v "master" | grep -v "develop" | xargs -r git branch -d
   ```

8. **Optional: Clean up remote tracking branches**:
   ```bash
   # Remove remote tracking branches that no longer exist on remote
   git remote prune origin

   # Or during fetch
   git fetch --prune
   ```

9. **Show cleanup summary**:
   - Number of branches deleted
   - Remaining branches
   - Disk space saved (if significant)

Safety checks:
- Never delete the current branch
- Never delete main/master/develop branches
- Never force delete (use -d, not -D) unless user explicitly requests
- Warn if branch exists on remote but not merged there
- Check for uncommitted changes before any deletion

Interactive options:
- List all branches with their last commit date
- Show branches older than X days/months
- Delete specific branches by name pattern
- Clean up both local and remote-tracking branches

Examples:

**Safe cleanup** (only merged branches):
```bash
# Show what will be deleted
git branch --merged main | grep -v "\*" | grep -v "main" | grep -v "master" | grep -v "develop"

# Delete them
git branch --merged main | grep -v "\*" | grep -v "main" | grep -v "master" | grep -v "develop" | xargs -r git branch -d
```

**Show branch ages**:
```bash
# Show branches with last commit date
git for-each-ref --sort=-committerdate refs/heads/ --format='%(committerdate:short) %(refname:short)'
```

**Clean up remote tracking branches**:
```bash
# Show stale remote branches
git remote prune origin --dry-run

# Actually remove them
git remote prune origin
```

**Delete specific pattern**:
```bash
# Delete branches matching pattern (e.g., feature/*)
git branch | grep "feature/" | xargs -r git branch -D
```

Common scenarios:

1. **After PR merge**: Clean up the feature branch locally
2. **Repository maintenance**: Periodic cleanup of old branches
3. **Before starting new work**: Clean slate for new features
4. **Storage cleanup**: Remove branches to save disk space

Best practices:
- Run `git fetch --prune` regularly to sync with remote
- Clean up branches after they're merged
- Keep branch names descriptive for easier identification
- Use `-d` (safe delete) instead of `-D` (force delete)
- Review the list before confirming deletion
- Coordinate with team on shared branches

Warnings to show:
- If a branch has unmerged commits, warn and skip
- If current branch is in the deletion list, skip it
- If protected branches (main/master/develop) are in list, skip them
- If remote branch still exists and differs from local, warn user
