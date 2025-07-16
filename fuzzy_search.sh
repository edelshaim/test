#!/bin/bash
# Fuzzy search for a string in file names and contents with preview

read -rp "Search term: " term

# Create a temporary file for results
results=$(mktemp)

# Match file names (case-insensitive)
fd -i "$term" >> "$results"

# Match file contents
rg --color=always --line-number "$term" >> "$results"

# Use fzf with a preview using bat
fzf --ansi \
    --preview 'FILE=$(echo {} | cut -d: -f1); LINE=$(echo {} | cut -d: -f2); [ -f "$FILE" ] && bat --color=always --highlight-line $LINE "$FILE"' \
    < "$results"

rm "$results"
