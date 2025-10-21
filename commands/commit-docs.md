# Documentation Commit (Conventional Commits)

You are helping create a documentation commit following Conventional Commits. This is for documentation-only changes with NO code changes.

Follow these steps:

1. Review changes with `git status` and `git diff --staged`
2. Verify changes are ONLY to documentation (README, comments, etc.)
3. Identify the scope if applicable
4. Create commit with format: `docs(<scope>): <description>`

Guidelines:
- Use imperative mood: "update" not "updated" or "updates"
- Clearly state what documentation changed
- Keep subject under 50 characters
- Add body if the changes are extensive
- ONLY use `docs` type if there are NO code changes

Examples:
```
docs(readme): add installation instructions for terraform modules

Added step-by-step guide for using terraform modules including:
- Module source configuration
- Required provider versions
- Variable configuration examples
- Output usage examples
```

```
docs(terraform): improve variable descriptions and examples

Enhanced all variable descriptions with:
- Type constraints
- Valid value ranges
- Usage examples
- Default value explanations
```

```
docs(pipeline): document Azure DevOps pipeline parameters

Added comprehensive documentation for all pipeline parameters
including trigger configurations, stage dependencies, and
deployment approval requirements.
```

```
docs: fix broken links in contributing guide

Corrected URLs pointing to moved documentation and updated
references to reflect new repository structure.
```

Remember: `docs` is ONLY for documentation changes. If you're changing code AND docs, use the type that matches the code change (feat, fix, etc.) and mention doc updates in the body.
