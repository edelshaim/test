
Create bash script for fuzzy search
Jul 16
edelshaim/test
codex/create-bash-script-for-fuzzy-search
+22
-0

Archive

Share
View PR


1
a bash script that will prompt for a string and run a fuzzy search on the current directory for that string in both file names and content. the results should be displayed as a list with a preview pane
Copy
Summary

Added a new Bash script to perform fuzzy searches on filenames and file contents with a preview pane using fzf and bat

Testing

✅ apt-get install -y fzf ripgrep fd-find bat


File (1)
add a prompt to select the directory to recursively search on
Copy
Summary

Added a prompt for specifying the search directory, defaulting to the current directory, in the fuzzy search script

Updated search commands to use the selected directory for filename and content search

Testing

✅ bash -n fuzzy_search.sh

✅ pip install -q -r requirements.txt (with warning)


File (1)

fuzzy_search.sh
New


Diff
Logs
fuzzy_search.sh
New
+22
-0

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
