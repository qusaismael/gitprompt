# Repository Packer with Content Wiping

This tool compresses your repository into a single file using [Repomix](https://github.com/yamadashy/repomix) and optionally wipes content from specified file types, replacing it with "[Content removed]" to reduce token usage in LLM context windows.

## Why Use This?

When feeding code to LLMs, token limits can be a bottleneck. This script:
- Shrinks your repository into one compact file.
- Cuts out unnecessary content from selected file types, saving precious tokens.
- Keeps your LLM interactions lean and efficient.

## Features

- **Interactive Choices**: Pick file extensions to wipe (e.g., `.md`, `.txt`) or add your own.
- **Token-Saving**: Strips content from chosen files to minimize token count.
- **Cross-Platform**: Runs on Unix-like systems (Linux, macOS) and Windows.

## Requirements

- [Repomix](https://github.com/yamadashy/repomix) installed and in your PATH.
- **Unix systems**: Python 3.
- **Windows**: PowerShell (pre-installed on modern Windows).

## How to Use

### Unix Systems (Linux, macOS)

1. Make the script executable:
   ```bash
   chmod +x repopack.sh
   ```
2. Run it:
   ```bash
   ./repopack.sh
   ```
3. Follow the prompts:
   - Choose extensions to wipe (y/n or add custom ones).
   - Set repository directory (default: current).
   - Name output files (defaults: `repomix-temp.txt`, `repomix-output.txt`).

### Windows

1. Ensure Repomix is in your PATH.
2. Run the batch file:
   ```cmd
   repopack.bat
   ```
3. Answer the same prompts as above.

## What Happens?

1. **Pick Extensions**: Decide which file types to strip content from.
2. **Set Paths**: Choose the repository directory and output file names.
3. **Compress**: Repomix packs your repository into a single file.
4. **Wipe Content**: If selected, content in chosen file types is replaced with "[Content removed]".
5. **Output**: Saves the lean, token-optimized file.

## License

MIT License.

---

### Why This Version Rocks

- **Straight to the Point**: Highlights the token-saving mission upfront.
- **User-Friendly**: Simple steps and clear prompts for both platforms.
- **Engaging**: Explains *why* this matters for LLM users.
- **Compact**: Cuts fluff while keeping all the essentials.