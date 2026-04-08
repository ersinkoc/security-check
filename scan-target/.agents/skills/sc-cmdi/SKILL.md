---
name: sc-cmdi
description: OS Command Injection detection in shell execution, subprocess calls, and process spawning
license: MIT
metadata:
  author: ersinkoc
  category: security
  version: "1.0.0"
---

# SC: Command Injection

## Purpose

Detects OS command injection vulnerabilities where user-controlled input is passed to system shell commands, subprocess execution, or process spawning functions without proper sanitization. Distinguishes between full command injection (attacker controls the command) and argument injection (attacker controls arguments to a fixed command).

## Activation

Called by sc-orchestrator during Phase 2. Runs against all detected languages.

## Phase 1: Discovery

### File Patterns to Search
```
**/*.py, **/*.js, **/*.ts, **/*.go, **/*.php, **/*.java, **/*.kt,
**/*.cs, **/*.rb, **/scripts/*, **/*exec*, **/*shell*, **/*command*,
**/*process*, **/*system*, **/*spawn*
```

### Keyword Patterns to Search
```
# Python
"os.system(", "os.popen(", "subprocess.call(", "subprocess.run(",
"subprocess.Popen(", "subprocess.check_output(", "commands.getoutput(",
"shell=True"

# JavaScript/Node.js
"child_process.exec(", "child_process.execSync(",
"child_process.spawn(", "execFile(", "require('child_process')",
"shelljs", "execa"

# Go
"exec.Command(", "exec.CommandContext(", "os/exec"

# PHP
"exec(", "system(", "passthru(", "shell_exec(", "popen(",
"proc_open(", "pcntl_exec(", "backtick"

# Java
"Runtime.getRuntime().exec(", "ProcessBuilder(",
"new ProcessBuilder("

# C#
"Process.Start(", "ProcessStartInfo(",
"System.Diagnostics.Process"

# Ruby
"system(", "exec(", "IO.popen(", "`"
```

### Data Flow Tracing

**Sources:** HTTP request parameters, file names from uploads, environment variables from user-controlled sources, database values originally from user input.

**Sinks:** All command execution functions listed above.

## Phase 2: Verification

### Command Injection vs Argument Injection

**Command injection** — attacker controls the full command or can inject shell operators:
```python
# VULNERABLE: Full command injection
os.system(f"echo {user_input}")  # user_input = "; rm -rf /"
```

**Argument injection** — attacker controls arguments to a known-safe binary:
```python
# VULNERABLE: Argument injection
subprocess.run(["git", "clone", user_url])  # user_url = "--upload-pack=evil"
```

### Shell Metacharacters
Watch for user input reaching shell with these metacharacters unescaped:
`;`, `|`, `&`, `&&`, `||`, `$()`, `` ` ` ``, `>`, `<`, `\n`

### Language-Specific Examples

```python
# VULNERABLE: shell=True with user input
subprocess.run(f"convert {filename} output.png", shell=True)

# SAFE: Array form without shell
subprocess.run(["convert", filename, "output.png"])
```

```javascript
// VULNERABLE: exec uses shell
const { exec } = require('child_process');
exec(`ls ${userDir}`, callback);

// SAFE: execFile does not use shell
const { execFile } = require('child_process');
execFile('ls', [userDir], callback);
```

```go
// VULNERABLE: User input in shell command via sh -c
cmd := exec.Command("sh", "-c", "echo " + userInput)

// SAFE: Direct execution without shell
cmd := exec.Command("echo", userInput)
```

```java
// VULNERABLE: String command to Runtime.exec
Runtime.getRuntime().exec("cmd /c dir " + userInput);

// SAFE: Array form
new ProcessBuilder("cmd", "/c", "dir", userInput).start();
// Note: Still risky if userInput contains shell metacharacters and cmd.exe interprets them
```

```php
// VULNERABLE: User input in system call
system("ping -c 4 " . $_GET['host']);

// SAFE: escapeshellarg
system("ping -c 4 " . escapeshellarg($_GET['host']));
```

## Severity Classification

- **Critical:** Direct command injection from HTTP parameter with shell=True/exec(), no sanitization
- **High:** Argument injection allowing arbitrary file read/write or network access
- **Medium:** Command injection requiring specific conditions, or in admin-only endpoints
- **Low:** Command injection in CLI tools processing local input, or with strong input validation

## Output Format

### Finding: CMDI-{NNN}
- **Title:** {Command|Argument} Injection in {function/endpoint}
- **Severity:** Critical | High | Medium | Low
- **Confidence:** 0-100
- **File:** file/path:line
- **Vulnerability Type:** CWE-78 (OS Command Injection)
- **Description:** User input from {source} reaches {sink} allowing {command|argument} injection.
- **Proof of Concept:** Supplying `; id` or `$(whoami)` as the {parameter} would execute additional commands.
- **Impact:** Full server compromise, data exfiltration, lateral movement, denial of service.
- **Remediation:** Use array-form command execution. Avoid shell=True. Apply allowlist validation or escapeshellarg().
- **References:** https://cwe.mitre.org/data/definitions/78.html

## Common False Positives

1. **Constants in command strings** — commands built entirely from hardcoded values
2. **Internal helper scripts** — commands using internally-generated values, not user input
3. **Build scripts/CI** — command execution in build tooling, not runtime code
4. **execFile with static binary** — `execFile('git', ['status'])` with no user input
5. **Docker/container commands** — orchestration scripts that don't handle user input
