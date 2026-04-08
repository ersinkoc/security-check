---
name: sc-path-traversal
description: Path traversal and directory traversal detection — LFI, RFI, zip slip, and symlink attacks
license: MIT
metadata:
  author: ersinkoc
  category: security
  version: "1.0.0"
---

# SC: Path Traversal / Directory Traversal

## Purpose

Detects path traversal vulnerabilities where user-controlled input is used to construct file paths, enabling reading, writing, or deleting arbitrary files. Covers `../` traversal, null byte injection, URL-encoded bypasses, zip slip (archive extraction), and symlink attacks.

## Activation

Called by sc-orchestrator during Phase 2. Runs against all detected languages.

## Phase 1: Discovery

### Keyword Patterns to Search
```
"open(", "readFile(", "readFileSync(", "writeFile(",
"fs.read", "fs.write", "fs.unlink", "os.Open(", "os.ReadFile(",
"file_get_contents(", "fopen(", "include(", "require(",
"Path.Combine(", "Path.Join(", "filepath.Join(",
"os.path.join(", "path.join(", "path.resolve("
```

### Data Flow: User Input → File Path
```python
# VULNERABLE
filename = request.GET['file']
with open(f'/uploads/{filename}') as f:  # ../../../etc/passwd
    return f.read()

# SAFE: Validate resolved path
filename = request.GET['file']
filepath = os.path.realpath(os.path.join('/uploads', filename))
if not filepath.startswith('/uploads/'):
    raise PermissionError()
with open(filepath) as f:
    return f.read()
```

```javascript
// VULNERABLE: path.join does NOT prevent traversal
const file = path.join(__dirname, 'uploads', req.params.filename);
// req.params.filename = "../../../etc/passwd" → traversal!

// SAFE: Resolve and verify
const base = path.resolve(__dirname, 'uploads');
const file = path.resolve(base, req.params.filename);
if (!file.startsWith(base + path.sep)) {
  return res.status(403).send('Forbidden');
}
```

### Zip Slip Detection
```java
// VULNERABLE: Archive extraction without path validation
ZipEntry entry = zipInput.getNextEntry();
File file = new File(destDir, entry.getName());  // entry could be ../../evil.sh
Files.copy(zipInput, file.toPath());

// SAFE: Validate extracted path
File file = new File(destDir, entry.getName());
if (!file.getCanonicalPath().startsWith(destDir.getCanonicalPath() + File.separator)) {
    throw new SecurityException("Zip slip detected: " + entry.getName());
}
```

## Severity Classification

- **Critical:** Arbitrary file read of system files (/etc/shadow, web.config) or file write to webroot
- **High:** Read access to application config/secrets, zip slip allowing code execution
- **Medium:** Limited file read with partial path control, traversal in admin tools
- **Low:** Path traversal with no sensitive file access, or traversal in read-only static file server

## Output Format

### Finding: PATH-{NNN}
- **Title:** Path Traversal in {function/endpoint}
- **Severity:** Critical | High | Medium | Low
- **Confidence:** 0-100
- **File:** file/path:line
- **Vulnerability Type:** CWE-22 (Path Traversal) | CWE-98 (Remote File Inclusion)
- **Description:** User input from {source} is used in file path at {sink} without canonicalization.
- **Impact:** Arbitrary file read/write, source code disclosure, credential theft.
- **Remediation:** Canonicalize path with realpath/resolve and verify it stays within intended directory.
- **References:** https://cwe.mitre.org/data/definitions/22.html

## Common False Positives

1. **Static file servers** — framework static file handlers typically prevent traversal
2. **path.join with constant base** — if the "user input" is actually a constant
3. **Database-driven file paths** — file paths from database that were validated at upload time
4. **Chroot/container isolation** — even if traversal succeeds, container limits access
