@echo off
setlocal enabledelayedexpansion

:: Prompt the user to select file extensions to wipe content from
echo 📌 For each file type, answer if you want to wipe its content (but keep its path).
set "OPTIONS=mjs css json md log env xml yml txt Other"
set "SELECTED="
for %%o in (%OPTIONS%) do (
    if "%%o"=="Other" (
        set /p others="❔ Enter additional extensions (comma-separated, no dots) to wipe content for: "
        for %%e in (!others!) do (
            set "ext=%%e"
            set "ext=!ext: =!"
            if not "!ext!"=="" (
                if "!SELECTED!"=="" (
                    set "SELECTED=!ext!"
                ) else (
                    set "SELECTED=!SELECTED!|!ext!"
                )
            )
        )
    ) else (
        set /p answer="❔ Wipe content for .%%o files? (y/n) "
        if /i "!answer!"=="y" (
            if "!SELECTED!"=="" (
                set "SELECTED=%%o"
            ) else (
                set "SELECTED=!SELECTED!|%%o"
            )
        )
    )
)
if not "!SELECTED!"=="" (
    echo 🔹 Extensions to wipe: !SELECTED!
) else (
    echo 🔹 No file types selected for wiping. All files will remain intact.
)

:: Get the repository directory and output file names from the user
set /p repo_dir="📂 Enter repository directory to pack (default: .): "
if "!repo_dir!"=="" set "repo_dir=."
set /p temp_file="📝 Enter temporary output file name (default: repomix-temp.txt): "
if "!temp_file!"=="" set "temp_file=repomix-temp.txt"
set /p output_file="📝 Enter final output file name (default: repomix-output.txt): "
if "!output_file!"=="" set "output_file=repomix-output.txt"

:: Generate full repository pack with Repomix
repomix --compress --remove-comments --remove-empty-lines --no-file-summary --copy --output "%temp_file%" "%repo_dir%"

:: If any extensions were selected for wiping, post-process the output using PowerShell
if not "!SELECTED!"=="" (
    powershell -Command "$content = Get-Content '%temp_file%' -Raw; $pattern = '(?i)(================\nFile:\s+.*?\.(?:%SELECTED%)\n================\n)(.*?)(?=^================\nFile:|\Z)'; $replacement = '$1[Content removed]\n\n'; $content -replace $pattern, $replacement | Set-Content '%output_file%'"
) else (
    copy "%temp_file%" "%output_file%"
)

echo ✅ Process complete. Output saved to %output_file%