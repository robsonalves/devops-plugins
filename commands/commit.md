# Conventional Commit Helper

You are helping create a git commit following the Conventional Commits specification. Follow these steps:

1. Run `git status` to see changed files
2. Run `git diff --staged` to see staged changes (or `git diff` for unstaged)
3. Analyze the changes to determine:
   - Type of change (feat, fix, docs, style, refactor, perf, test, chore, ci, build)
   - Scope (optional but recommended - e.g., api, auth, ui, pipeline)
   - Breaking changes (if any)
4. Stage files if needed with `git add`
5. Create a commit message following this format:
   ```
   <type>(<scope>): <subject>

   <body>

   <footer>
   ```

Commit types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation only changes
- `style`: Code style changes (formatting, missing semicolons, etc.)
- `refactor`: Code change that neither fixes a bug nor adds a feature
- `perf`: Performance improvement
- `test`: Adding or correcting tests
- `chore`: Maintenance tasks, dependency updates
- `ci`: CI/CD pipeline changes
- `build`: Build system or external dependency changes

Rules:
- Subject line: imperative mood, lowercase, no period, max 50 chars
- Body: Explain what and why (not how), wrap at 72 chars
- Footer: Reference issues, breaking changes
- NEVER include author names in commit messages
- Use English for all commit messages

Breaking changes:
- Add `!` after type/scope: `feat(api)!: change response format`
- Add `BREAKING CHANGE:` in footer with description

Examples:
```
feat(auth): add OAuth2 authentication support

Implemented OAuth2 flow with Google and GitHub providers.
Added refresh token rotation for enhanced security.

Closes #123
```

```
fix(pipeline): resolve terraform plan artifact caching issue

The terraform plan artifact was not being properly cached between
pipeline stages, causing plans to be regenerated unnecessarily.

Updated artifact paths and added explicit cache configuration.
```

```
chore(deps): upgrade terraform to v1.7.0

BREAKING CHANGE: minimum required Terraform version is now 1.7.0
```
