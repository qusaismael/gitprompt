#!/bin/bash

# Prompt the user to select file extensions to wipe content from
function select_extensions() {
    echo "📌 For each file type, answer if you want to wipe its content (but keep its path)."
    OPTIONS=("mjs" "css" "json" "md" "log" "env" "xml" "yml" "txt" "Other")
    SELECTED=()
    for opt in "${OPTIONS[@]}"; do
        if [ "$opt" == "Other" ]; then
            echo "❔ Enter additional extensions (comma-separated, no dots) to wipe content for:"
            read -r others
            IFS=',' read -ra extras <<< "$others"
            for ext in "${extras[@]}"; do
                ext=$(echo "$ext" | tr -d ' ')
                if [[ -n "$ext" ]]; then
                    SELECTED+=("$ext")
                fi
            done
        else
            echo "❔ Wipe content for .$opt files? (y/n)"
            read -r answer
            if [[ $answer =~ ^[Yy]$ ]]; then
                SELECTED+=("$opt")
            fi
        fi
    done
    if [ ${#SELECTED[@]} -gt 0 ]; then
        echo "🔹 Extensions to wipe: ${SELECTED[*]}"
        IGNORE_EXTENSIONS=$(IFS="|"; echo "${SELECTED[*]}")
    else
        echo "🔹 No file types selected for wiping. All files will remain intact."
        IGNORE_EXTENSIONS=""
    fi
}

# Get the repository directory and output file names from the user
function get_paths() {
    echo "📂 Enter repository directory to pack (default: .):"
    read -r repo_dir
    if [[ -z "$repo_dir" ]]; then
        repo_dir="."
    fi
    echo "📝 Enter temporary output file name (default: repomix-temp.txt):"
    read -r temp_file
    if [[ -z "$temp_file" ]]; then
        temp_file="repomix-temp.txt"
    fi
    echo "📝 Enter final output file name (default: repomix-output.txt):"
    read -r output_file
    if [[ -z "$output_file" ]]; then
        output_file="repomix-output.txt"
    fi
    REPO_DIR="$repo_dir"
    TEMP_FILE="$temp_file"
    FINAL_FILE="$output_file"
}

# Main script execution
select_extensions
get_paths

# Generate full repository pack with Repomix
repomix --compress --remove-comments --remove-empty-lines --no-file-summary --copy --output "$TEMP_FILE" "$REPO_DIR"

# If any extensions were selected for wiping, post-process the output
if [[ -n "$IGNORE_EXTENSIONS" ]]; then
    python3 -c "import re, sys; content = sys.stdin.read(); pattern = r'(================\nFile:\s+.*?\.(?:$IGNORE_EXTENSIONS)\n================\n)(.*?)(?=^================\nFile:|\Z)'; replacement = r'\1[Content removed]\n\n'; sys.stdout.write(re.sub(pattern, replacement, content, flags=re.DOTALL | re.MULTILINE | re.IGNORECASE))" < "$TEMP_FILE" > "$FINAL_FILE"
else
    cp "$TEMP_FILE" "$FINAL_FILE"
fi

echo "✅ Process complete. Output saved to $FINAL_FILE"