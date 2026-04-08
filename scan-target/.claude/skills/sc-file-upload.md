---
name: sc-file-upload
description: Insecure file upload detection — unrestricted types, MIME mismatch, polyglot files, and webshell upload
---

# SC: Insecure File Upload

## Purpose

Detects insecure file upload vulnerabilities including unrestricted file type uploads, MIME type vs extension mismatches, double extension bypasses, executable uploads to web-accessible directories, missing file size limits, and archive extraction attacks. Focuses on upload endpoints that could lead to remote code execution or stored XSS.

## Activation

Called by sc-orchestrator during Phase 2 when file upload functionality is detected.

## Phase 1: Discovery

### Keyword Patterns to Search
```
"multer", "upload", "multipart", "formidable", "busboy",
"FileUpload", "IFormFile", "MultipartFile", "@RequestPart",
"$_FILES", "move_uploaded_file", "UploadedFile",
"file.save(", "storage.upload(", "putObject("
```

### Vulnerability Patterns

**1. No File Type Validation:**
```javascript
// VULNERABLE: Accept any file
const upload = multer({ dest: 'public/uploads/' });
app.post('/upload', upload.single('file'), (req, res) => {
  res.json({ path: `/uploads/${req.file.filename}` });
});

// SAFE: Validate file type
const upload = multer({
  dest: 'uploads/',  // NOT in public directory
  fileFilter: (req, file, cb) => {
    const allowed = ['image/jpeg', 'image/png', 'image/gif'];
    if (allowed.includes(file.mimetype)) {
      cb(null, true);
    } else {
      cb(new Error('Invalid file type'), false);
    }
  },
  limits: { fileSize: 5 * 1024 * 1024 }  // 5MB limit
});
```

**2. Upload to Webroot:**
```php
// VULNERABLE: Upload directly to web-accessible directory
move_uploaded_file($_FILES['file']['tmp_name'], 'public/uploads/' . $_FILES['file']['name']);
// If user uploads evil.php → accessible at /uploads/evil.php → RCE!

// SAFE: Upload outside webroot + rename
$ext = pathinfo($_FILES['file']['name'], PATHINFO_EXTENSION);
$allowed = ['jpg', 'png', 'gif'];
if (!in_array(strtolower($ext), $allowed)) { die('Invalid type'); }
$newName = bin2hex(random_bytes(16)) . '.' . $ext;
move_uploaded_file($_FILES['file']['tmp_name'], '/var/data/uploads/' . $newName);
```

### Checks
1. Is file type validated server-side (not just client-side)?
2. Are files stored outside the web root?
3. Are filenames sanitized and randomized?
4. Is file size limited?
5. Are magic bytes checked (not just extension/MIME)?
6. Is the upload directory configured to not execute scripts?

## Severity Classification

- **Critical:** Unrestricted upload to webroot enabling RCE (PHP, JSP, ASPX)
- **High:** Upload allowing XSS (SVG, HTML) or bypassing type checks
- **Medium:** Missing file size limits (DoS), client-side-only validation
- **Low:** Upload configuration weaknesses without clear exploitation path

## Output Format

### Finding: UPLOAD-{NNN}
- **Title:** Insecure File Upload in {endpoint}
- **Severity:** Critical | High | Medium | Low
- **Confidence:** 0-100
- **File:** file/path:line
- **Vulnerability Type:** CWE-434 (Unrestricted Upload of File with Dangerous Type)
- **Description:** File upload at {endpoint} lacks {validation type}.
- **Impact:** Remote code execution, stored XSS, denial of service.
- **Remediation:** Validate file type server-side, store outside webroot, randomize filenames, set size limits.
- **References:** https://cwe.mitre.org/data/definitions/434.html

## Common False Positives

1. **Cloud storage uploads** — files uploaded to S3/GCS are not directly executable
2. **Image processing pipelines** — files processed through ImageMagick/Sharp before storage
3. **API payload uploads** — JSON/XML payloads parsed as data, not stored as files
