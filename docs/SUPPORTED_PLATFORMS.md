# Supported Platforms

> Setup instructions for using security-check with each supported AI coding assistant.

---

## Overview

security-check works with any LLM-based AI coding assistant that supports skill files or instruction files. The scanning logic is identical across all platforms -- only the file paths and configuration method differ.

| Platform | Orchestration File | Skills Directory | Status |
|----------|-------------------|------------------|--------|
| Claude Code | `CLAUDE.md` | `.claude/skills/` | Fully supported |
| Codex (OpenAI) | `AGENTS.md` | `.agents/skills/` | Fully supported |
| Cursor | `AGENTS.md` | `.agents/skills/` | Fully supported |
| Opencode | `AGENTS.md` | `.agents/skills/` | Fully supported |
| Windsurf | `AGENTS.md` | `.agents/skills/` | Fully supported |
| Gemini CLI | `AGENTS.md` | `.agents/skills/` | Fully supported |

---

## Claude Code

Claude Code is Anthropic's official CLI for Claude. It natively supports skill files in the `.claude/skills/` directory and reads project instructions from `CLAUDE.md` at the project root.

### Automatic Installation

```bash
cd /path/to/your/project
curl -fsSL https://raw.githubusercontent.com/ersinkoc/security-check/main/install.sh | bash
```

The installer automatically detects Claude Code and installs the appropriate files.

### Manual Installation

```bash
# Clone security-check
git clone https://github.com/ersinkoc/security-check.git /tmp/security-check

# Copy the orchestration file
cp /tmp/security-check/scan-target/CLAUDE.md ./CLAUDE.md

# Copy skill files
mkdir -p .claude/skills
cp /tmp/security-check/scan-target/.claude/skills/*.md .claude/skills/

# Copy security checklists
cp -r /tmp/security-check/checklists ./checklists

# Clean up
rm -rf /tmp/security-check
```

### File Structure After Installation

```
your-project/
├── CLAUDE.md                    # Orchestration instructions
├── .claude/
│   └── skills/
│       ├── sc-orchestrator.md
│       ├── sc-recon.md
│       ├── sc-dependency-audit.md
│       ├── sc-sqli.md
│       ├── sc-xss.md
│       ├── ... (40+ skill files)
│       ├── sc-lang-go.md
│       ├── sc-lang-typescript.md
│       ├── ... (7 language skills)
│       ├── sc-verifier.md
│       ├── sc-report.md
│       └── sc-diff-report.md
└── checklists/
    ├── go-security-checklist.md
    ├── typescript-security-checklist.md
    └── ... (10 checklist files)
```

### Existing CLAUDE.md

If your project already has a `CLAUDE.md` file, the installer appends the security-check configuration to the end of your existing file. For manual installation, you can either:

1. Append the security-check `CLAUDE.md` contents to your existing file
2. Use an `@import` or reference approach if your setup supports it

The security-check instructions are designed to be non-conflicting with other project instructions.

### Running a Scan

Open Claude Code in your project directory and use any of these commands:

```
"run security check"
"scan for vulnerabilities"
"security audit"
"scan this project for security issues"
```

For diff mode (scanning only changed files):

```
"scan diff"
"scan changes"
"PR scan"
```

### Configuration

Claude Code automatically discovers `.claude/skills/` files. No additional configuration is needed. The `CLAUDE.md` file at the project root provides the orchestration logic that coordinates the scan pipeline.

### Subagent Parallel Execution

Claude Code supports subagent spawning via the `Task` tool. When available, Phase 2 vulnerability skills run as parallel subagents for faster scanning. If subagents are not available, skills run sequentially within the main context.

---

## Codex (OpenAI)

Codex is OpenAI's coding agent. It reads instruction files from `AGENTS.md` and skill files from the `.agents/skills/` directory.

### Automatic Installation

```bash
cd /path/to/your/project
curl -fsSL https://raw.githubusercontent.com/ersinkoc/security-check/main/install.sh | bash
```

The installer detects Codex environments and installs the `.agents/` format files.

### Manual Installation

```bash
# Clone security-check
git clone https://github.com/ersinkoc/security-check.git /tmp/security-check

# Copy the orchestration file
cp /tmp/security-check/scan-target/AGENTS.md ./AGENTS.md

# Copy skill files
mkdir -p .agents/skills
cp /tmp/security-check/scan-target/.agents/skills/*.md .agents/skills/

# Copy security checklists
cp -r /tmp/security-check/checklists ./checklists

# Clean up
rm -rf /tmp/security-check
```

### File Structure After Installation

```
your-project/
├── AGENTS.md                    # Orchestration instructions
├── .agents/
│   └── skills/
│       ├── sc-orchestrator.md
│       ├── sc-recon.md
│       ├── sc-dependency-audit.md
│       ├── sc-sqli.md
│       ├── ... (all skill files)
│       ├── sc-verifier.md
│       ├── sc-report.md
│       └── sc-diff-report.md
└── checklists/
    ├── go-security-checklist.md
    └── ... (10 checklist files)
```

### Running a Scan

Open Codex with your project and use:

```
"run security check"
"scan for vulnerabilities"
"security audit"
```

### Notes for Codex

- Codex typically runs skills sequentially within a single context rather than in parallel subagents
- Longer codebases may require multiple turns for a complete scan
- The skills are designed to work correctly in sequential mode -- no modifications needed

---

## Cursor

Cursor is an AI-powered code editor. It reads agent instructions from `AGENTS.md` and discovers skill files in `.agents/skills/`.

### Automatic Installation

```bash
cd /path/to/your/project
curl -fsSL https://raw.githubusercontent.com/ersinkoc/security-check/main/install.sh | bash
```

### Manual Installation

```bash
# Clone security-check
git clone https://github.com/ersinkoc/security-check.git /tmp/security-check

# Copy the orchestration file
cp /tmp/security-check/scan-target/AGENTS.md ./AGENTS.md

# Copy skill files
mkdir -p .agents/skills
cp /tmp/security-check/scan-target/.agents/skills/*.md .agents/skills/

# Copy security checklists
cp -r /tmp/security-check/checklists ./checklists

# Clean up
rm -rf /tmp/security-check
```

### File Structure After Installation

```
your-project/
├── AGENTS.md
├── .agents/
│   └── skills/
│       └── (all skill files)
└── checklists/
    └── (all checklist files)
```

### Running a Scan

In Cursor's AI chat panel (Agent mode), type:

```
"run security check"
"scan for vulnerabilities"
"security audit"
```

### Notes for Cursor

- Use Agent mode (not Ask or Edit mode) for security scanning
- Cursor may process skills sequentially depending on the context window
- For large projects, consider running in diff mode to reduce scope: "scan diff"
- Cursor's `.cursorrules` file does not conflict with security-check's `AGENTS.md`

### Cursor-Specific Configuration

If you use Cursor's rules file, you can add a reference to AGENTS.md:

```
# .cursorrules (optional addition)
When asked to run a security check, follow the instructions in AGENTS.md.
```

This is optional -- Cursor reads `AGENTS.md` automatically.

---

## Opencode

Opencode is an open-source terminal-based AI coding assistant. It supports `AGENTS.md` for project instructions and `.agents/skills/` for skill files.

### Automatic Installation

```bash
cd /path/to/your/project
curl -fsSL https://raw.githubusercontent.com/ersinkoc/security-check/main/install.sh | bash
```

### Manual Installation

```bash
# Clone security-check
git clone https://github.com/ersinkoc/security-check.git /tmp/security-check

# Copy the orchestration file
cp /tmp/security-check/scan-target/AGENTS.md ./AGENTS.md

# Copy skill files
mkdir -p .agents/skills
cp /tmp/security-check/scan-target/.agents/skills/*.md .agents/skills/

# Copy security checklists
cp -r /tmp/security-check/checklists ./checklists

# Clean up
rm -rf /tmp/security-check
```

### File Structure After Installation

```
your-project/
├── AGENTS.md
├── .agents/
│   └── skills/
│       └── (all skill files)
└── checklists/
    └── (all checklist files)
```

### Running a Scan

In Opencode's terminal interface, type:

```
"run security check"
"scan for vulnerabilities"
"security audit"
```

### Notes for Opencode

- Opencode reads `AGENTS.md` from the project root automatically
- Skills execute sequentially within the conversation context
- Opencode supports file reading and writing, which is all security-check requires
- No additional configuration beyond placing the files is necessary

---

## Windsurf

Windsurf is Codeium's AI-powered IDE. It supports agent instructions via `AGENTS.md` and discovers skills in `.agents/skills/`.

### Automatic Installation

```bash
cd /path/to/your/project
curl -fsSL https://raw.githubusercontent.com/ersinkoc/security-check/main/install.sh | bash
```

### Manual Installation

```bash
# Clone security-check
git clone https://github.com/ersinkoc/security-check.git /tmp/security-check

# Copy the orchestration file
cp /tmp/security-check/scan-target/AGENTS.md ./AGENTS.md

# Copy skill files
mkdir -p .agents/skills
cp /tmp/security-check/scan-target/.agents/skills/*.md .agents/skills/

# Copy security checklists
cp -r /tmp/security-check/checklists ./checklists

# Clean up
rm -rf /tmp/security-check
```

### File Structure After Installation

```
your-project/
├── AGENTS.md
├── .agents/
│   └── skills/
│       └── (all skill files)
└── checklists/
    └── (all checklist files)
```

### Running a Scan

In Windsurf's Cascade AI panel, type:

```
"run security check"
"scan for vulnerabilities"
"security audit"
```

### Notes for Windsurf

- Use Cascade mode for running security scans
- Windsurf reads `AGENTS.md` from the project root
- Skills execute within the Cascade conversation context
- Windsurf's existing `.windsurfrules` file does not conflict with security-check

### Windsurf-Specific Configuration

Optionally, you can add a reference in your Windsurf rules:

```
# .windsurfrules (optional addition)
When asked to run a security check, follow the instructions in AGENTS.md.
```

---

## Gemini CLI

Gemini CLI is Google's command-line AI coding assistant. It supports project instructions via `AGENTS.md` and reads skill files from `.agents/skills/`.

### Automatic Installation

```bash
cd /path/to/your/project
curl -fsSL https://raw.githubusercontent.com/ersinkoc/security-check/main/install.sh | bash
```

### Manual Installation

```bash
# Clone security-check
git clone https://github.com/ersinkoc/security-check.git /tmp/security-check

# Copy the orchestration file
cp /tmp/security-check/scan-target/AGENTS.md ./AGENTS.md

# Copy skill files
mkdir -p .agents/skills
cp /tmp/security-check/scan-target/.agents/skills/*.md .agents/skills/

# Copy security checklists
cp -r /tmp/security-check/checklists ./checklists

# Clean up
rm -rf /tmp/security-check
```

### File Structure After Installation

```
your-project/
├── AGENTS.md
├── .agents/
│   └── skills/
│       └── (all skill files)
└── checklists/
    └── (all checklist files)
```

### Running a Scan

In Gemini CLI, type:

```
"run security check"
"scan for vulnerabilities"
"security audit"
```

### Notes for Gemini CLI

- Gemini CLI reads `AGENTS.md` from the project root automatically
- Skills execute sequentially within the conversation context
- Gemini CLI supports the file operations (read, write, search) that security-check requires
- No additional configuration beyond placing the files is necessary

---

## Cross-Platform Compatibility

### Installing for Multiple Platforms Simultaneously

If your team uses multiple AI coding assistants, install both formats:

```bash
# Manual multi-platform installation
git clone https://github.com/ersinkoc/security-check.git /tmp/security-check

# Claude Code format
cp /tmp/security-check/scan-target/CLAUDE.md ./CLAUDE.md
mkdir -p .claude/skills
cp /tmp/security-check/scan-target/.claude/skills/*.md .claude/skills/

# Agents format (Codex, Cursor, Opencode, Windsurf, Gemini CLI)
cp /tmp/security-check/scan-target/AGENTS.md ./AGENTS.md
mkdir -p .agents/skills
cp /tmp/security-check/scan-target/.agents/skills/*.md .agents/skills/

# Shared checklists (used by both formats)
cp -r /tmp/security-check/checklists ./checklists

rm -rf /tmp/security-check
```

The automated installer (`install.sh`) detects which platforms are present and installs both formats when multiple platforms are detected.

### File Compatibility

The skill files in `.claude/skills/` and `.agents/skills/` are identical. They are maintained as mirrors of each other. When contributing new skills, you must place the file in both directories.

### Checklists Are Shared

The `checklists/` directory is platform-independent and used by all platforms. It only needs to be installed once.

---

## Troubleshooting

### Skills Are Not Being Discovered

**Symptom:** The AI assistant does not recognize security-check commands like "run security check."

**Possible causes:**
1. The orchestration file (`CLAUDE.md` or `AGENTS.md`) is not in the project root directory
2. The skills directory (`.claude/skills/` or `.agents/skills/`) does not exist or is empty
3. The AI assistant is not running in the project directory

**Solution:** Verify file placement:
```bash
# For Claude Code
ls -la CLAUDE.md .claude/skills/

# For other platforms
ls -la AGENTS.md .agents/skills/
```

### Scan Produces No Output

**Symptom:** The scan starts but no `security-report/` directory is created.

**Possible causes:**
1. The AI assistant lacks file write permissions
2. The project directory is read-only
3. The scan was interrupted before Phase 1 completed

**Solution:** Ensure the AI assistant has write access to the project directory. Try running the scan again -- the orchestrator checks for an existing `security-report/` directory and offers to continue or restart.

### Partial Scan Results

**Symptom:** Only some skill result files appear in `security-report/`.

**Possible causes:**
1. The scan was interrupted during Phase 2
2. Context window limits caused some skills to be skipped
3. Language-specific skills were not activated because the language was not detected

**Solution:** Check `security-report/architecture.md` to see which languages were detected. If a language is missing, verify that its source files are present and have standard file extensions. You can also request a specific skill to run: "run only sc-lang-python."

### Checklists Not Found

**Symptom:** Language skills report that they cannot find the checklist file.

**Possible cause:** The `checklists/` directory was not copied or is not in the project root.

**Solution:**
```bash
ls checklists/
# Should show: go-security-checklist.md, typescript-security-checklist.md, etc.
```

If missing, copy the checklists directory from the security-check repository.

### Large Project Performance

**Symptom:** Scan takes very long or the AI assistant runs out of context.

**Possible solutions:**
1. Use diff mode to scan only changed files: "scan diff"
2. Run specific skills instead of the full pipeline: "run sc-sqli and sc-xss only"
3. Scope the scan to a specific directory: "scan the src/api/ directory for vulnerabilities"

---

## Version Compatibility

security-check is designed to work with the current versions of all supported platforms as of its release date. Since it consists entirely of Markdown files read by LLMs, it does not depend on specific API versions or platform features. As long as the platform can:

1. Read Markdown files from the project directory
2. Search for patterns in source code files
3. Write Markdown files to the project directory

security-check will function correctly.
