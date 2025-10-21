# Refactor Commit (Conventional Commits)

You are helping create a refactor commit following Conventional Commits. This is for code changes that improve structure or clarity WITHOUT changing functionality or fixing bugs.

Follow these steps:

1. Review changes with `git status` and `git diff --staged`
2. Verify changes don't add features or fix bugs
3. Identify the scope (component/module affected)
4. Create commit with format: `refactor(<scope>): <description>`

Guidelines:
- Use imperative mood: "restructure" not "restructured"
- Clearly state what is being refactored
- Keep subject under 50 characters
- Add body explaining WHY the refactor improves the code
- Note if this enables future features

Common refactoring scenarios:
- Extracting repeated code into functions/modules
- Renaming variables/functions for clarity
- Reorganizing file/directory structure
- Simplifying complex logic
- Removing dead code
- Improving code maintainability

Examples:
```
refactor(terraform): extract common networking config to module

Created reusable networking module to eliminate duplication across
environments. Moved VPC, subnet, and routing configuration to
shared module with environment-specific variables.

This will make it easier to maintain consistent networking
configuration and simplify future multi-region deployments.
```

```
refactor(pipeline): consolidate duplicate deployment stages

Replaced environment-specific deployment stages with parameterized
template. Reduced pipeline YAML from 500 to 150 lines while
maintaining all functionality.
```

```
refactor(scripts): reorganize helper functions into modules

Moved bash helper functions from inline scripts to separate
.sh files in scripts/ directory. Improved testability and
reusability across different pipeline stages.
```

```
refactor(k8s): simplify label selector logic

Replaced complex multi-condition selectors with consistent
label scheme using app, component, and environment labels.

BREAKING CHANGE: existing deployments must be updated with new label scheme
```

Remember: Refactors CHANGE code structure but NOT behavior. If you're adding functionality, use `feat`. If you're fixing bugs, use `fix`. If you're improving performance, use `perf`.
