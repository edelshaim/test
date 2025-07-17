#!/bin/bash
# Fuzzy search for a string in file names and contents with preview

read -rp "Search term: " term
read -rp "Directory to search (default: .): " dir
dir=${dir:-.}

# Create a temporary file for results
results=$(mktemp)

# Match file names (case-insensitive)
fd -i "$term" "$dir" >> "$results"

# Match file contents
rg --color=always --line-number "$term" "$dir" >> "$results"

# Use fzf with a preview using bat
fzf --ansi \
    --preview 'FILE=$(echo {} | cut -d: -f1); LINE=$(echo {} | cut -d: -f2); [ -f "$FILE" ] && bat --color=always --highlight-line $LINE "$FILE"' \
    < "$results"

rm "$results"
