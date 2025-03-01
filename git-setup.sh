#!/bin/bash

echo "Checking git repository status..."

# Check if we have any commits
if [ -z "$(git log -1 2>/dev/null)" ]; then
    echo "No commits found. Creating initial commit..."
    
    # Create a README if it doesn't exist
    if [ ! -f "README.md" ]; then
        echo "# Nuxt View Tidimo" > README.md
        echo "Created README.md"
    fi
    
    # Initialize git if needed
    if [ ! -d ".git" ]; then
        git init
        echo "Initialized git repository"
    fi
    
    # Add and commit files
    git add .
    git commit -m "Initial commit"
    echo "Created initial commit"
fi

# Check current branch name
current_branch=$(git branch --show-current)
echo "Current branch: $current_branch"

# If branch isn't 'main', create or rename to main
if [ "$current_branch" != "main" ]; then
    if [ -z "$current_branch" ] || [ "$current_branch" = "master" ]; then
        echo "Renaming branch to 'main'..."
        git branch -m master main 2>/dev/null || git checkout -b main
    else
        echo "Creating 'main' branch..."
        git checkout -b main
    fi
fi

echo "Ready to push. Run: git push -u origin main"
