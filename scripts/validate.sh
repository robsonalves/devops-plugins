#!/bin/bash

# DevOps Toolkit Plugin Validation Script
# Validates command files integrity and documentation consistency

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
COMMANDS_DIR="$PROJECT_ROOT/commands"
README_FILE="$PROJECT_ROOT/README.md"
PLUGIN_CONFIG="$PROJECT_ROOT/.claude-plugin/plugin.json"
MARKETPLACE_CONFIG="$PROJECT_ROOT/.claude-plugin/marketplace.json"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

errors=0
warnings=0

echo "=================================="
echo "DevOps Toolkit Plugin Validation"
echo "=================================="
echo ""

# Function to print error
print_error() {
    echo -e "${RED}✗ ERROR:${NC} $1"
    ((errors++))
}

# Function to print warning
print_warning() {
    echo -e "${YELLOW}⚠ WARNING:${NC} $1"
    ((warnings++))
}

# Function to print success
print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

# Check if required directories exist
echo "Checking project structure..."
if [ ! -d "$COMMANDS_DIR" ]; then
    print_error "Commands directory not found: $COMMANDS_DIR"
    exit 1
fi

if [ ! -f "$README_FILE" ]; then
    print_error "README.md not found: $README_FILE"
    exit 1
fi
print_success "Project structure is valid"
echo ""

# Validate JSON configuration files
echo "Validating JSON configuration files..."
if command -v jq &> /dev/null; then
    if [ -f "$PLUGIN_CONFIG" ]; then
        if jq empty "$PLUGIN_CONFIG" 2>/dev/null; then
            print_success "plugin.json is valid JSON"
        else
            print_error "plugin.json is not valid JSON"
        fi
    else
        print_error "plugin.json not found"
    fi

    if [ -f "$MARKETPLACE_CONFIG" ]; then
        if jq empty "$MARKETPLACE_CONFIG" 2>/dev/null; then
            print_success "marketplace.json is valid JSON"
        else
            print_error "marketplace.json is not valid JSON"
        fi
    else
        print_error "marketplace.json not found"
    fi
else
    print_warning "jq not installed, skipping JSON validation"
fi
echo ""

# Extract command references from README
echo "Extracting command references from README..."
readme_commands=$(grep -oP '/[a-z0-9-]+' "$README_FILE" | sort | uniq | sed 's|^/||')
readme_command_count=$(echo "$readme_commands" | wc -l)
print_success "Found $readme_command_count unique commands referenced in README"
echo ""

# List all command files
echo "Checking command files..."
command_files=$(find "$COMMANDS_DIR" -name "*.md" -type f | sort)
command_file_count=$(echo "$command_files" | wc -l)
print_success "Found $command_file_count command files in $COMMANDS_DIR"
echo ""

# Validate each command file
echo "Validating command file structure..."
for cmd_file in $command_files; do
    cmd_name=$(basename "$cmd_file" .md)

    # Check if file is not empty
    if [ ! -s "$cmd_file" ]; then
        print_error "Command file is empty: $cmd_name.md"
        continue
    fi

    # Check if file has a title (starts with #)
    if ! grep -q "^# " "$cmd_file"; then
        print_error "Command file missing title: $cmd_name.md"
    fi

    # Check if file has at least 10 lines (basic content check)
    line_count=$(wc -l < "$cmd_file")
    if [ "$line_count" -lt 10 ]; then
        print_warning "Command file seems too short ($line_count lines): $cmd_name.md"
    fi

    # Check if command is referenced in README
    if ! echo "$readme_commands" | grep -q "^$cmd_name$"; then
        print_warning "Command not documented in README: /$cmd_name"
    else
        print_success "Command validated: /$cmd_name"
    fi
done
echo ""

# Check if all README commands have corresponding files
echo "Checking README documentation consistency..."
for cmd in $readme_commands; do
    if [ ! -f "$COMMANDS_DIR/$cmd.md" ]; then
        print_error "Command documented in README but file not found: /$cmd"
    fi
done
echo ""

# Check for common issues in command files
echo "Checking for common issues..."
for cmd_file in $command_files; do
    cmd_name=$(basename "$cmd_file" .md)

    # Check for TODO/FIXME markers
    if grep -qi "TODO\|FIXME" "$cmd_file"; then
        print_warning "Found TODO/FIXME in $cmd_name.md"
    fi

    # Check for placeholder text
    if grep -qi "placeholder\|example\.com\|changeme" "$cmd_file"; then
        print_warning "Found placeholder text in $cmd_name.md"
    fi
done
echo ""

# Summary
echo "=================================="
echo "Validation Summary"
echo "=================================="
echo "Total command files: $command_file_count"
echo "Commands in README: $readme_command_count"
echo -e "Errors: ${RED}$errors${NC}"
echo -e "Warnings: ${YELLOW}$warnings${NC}"
echo ""

if [ $errors -eq 0 ]; then
    echo -e "${GREEN}✓ All validations passed!${NC}"
    exit 0
else
    echo -e "${RED}✗ Validation failed with $errors error(s)${NC}"
    exit 1
fi
