---
name: sc-lang-php
description: PHP-specific security deep scan
---

# SC: PHP Security Deep Scan

## Purpose

Detects PHP-specific security anti-patterns including deserialization gadgets, type juggling, include-based attacks, and framework-specific vulnerabilities in Laravel and WordPress. Focuses on PHP's unique type system, legacy functions, and common misconfigurations.

## Activation

Activates when PHP is detected in `security-report/architecture.md`.

## Checklist Reference

References `checklists/php-security-checklist.md`.

## PHP-Specific Vulnerability Patterns

### Category 1: unserialize() POP Chains

```php
// VULNERABLE: Unserializing user input → RCE via magic methods
$data = unserialize($_POST['data']); // __wakeup, __destruct chain

// SAFE: Use JSON or restrict classes
$data = json_decode($_POST['data'], true);
$data = unserialize($input, ['allowed_classes' => false]);
```

### Category 2: phar:// Deserialization

```php
// VULNERABLE: phar:// triggers deserialization without unserialize()
file_exists("phar://" . $_GET['file']); // Triggers metadata deserialization!
// Also: file_get_contents, fopen, is_dir, etc.

// SAFE: Validate file path, never use user input in phar://
```

### Category 3: include/require LFI/RFI

```php
// VULNERABLE: User input in include path
include($_GET['page'] . '.php'); // LFI: ?page=../../etc/passwd%00

// SAFE: Allowlist
$allowed = ['home', 'about', 'contact'];
$page = in_array($_GET['page'], $allowed) ? $_GET['page'] : 'home';
include($page . '.php');
```

### Category 4: extract() Variable Overwrite

```php
// VULNERABLE: Overwrites existing variables including auth vars
extract($_POST); // If POST contains 'isAdmin=1' → $isAdmin = 1

// SAFE: Never use extract() on user input; use specific variables
$name = $_POST['name'];
```

### Category 5: Type Juggling (== vs ===)

```php
// VULNERABLE: Loose comparison type juggling
if ($_POST['password'] == $storedHash) { /* ... */ } // "0" == "0e462097..." is TRUE!
if (strcmp($_POST['token'], $expectedToken) == 0) { /* ... */ }
// strcmp([], "string") returns NULL, and NULL == 0 is TRUE!

// SAFE: Strict comparison
if ($_POST['password'] === $storedHash) { /* ... */ }
if (hash_equals($expectedToken, $_POST['token'])) { /* ... */ }
```

### Category 6: preg_replace /e Modifier (Legacy)

```php
// VULNERABLE: /e flag executes PHP code (deprecated in PHP 7)
preg_replace('/.*/e', $_GET['code'], ''); // Code execution!

// SAFE: Use preg_replace_callback
preg_replace_callback('/pattern/', function($matches) { /* ... */ }, $input);
```

### Category 7: Laravel Mass Assignment

```php
// VULNERABLE: No $fillable or $guarded
class User extends Model {} // All fields mass-assignable
User::create($request->all()); // role, is_admin controllable

// SAFE
class User extends Model {
    protected $fillable = ['name', 'email'];
}
```

### Category 8: Eloquent Raw Queries

```php
// VULNERABLE: Raw with interpolation
DB::select("SELECT * FROM users WHERE name = '$name'");
User::whereRaw("name = '$name'")->get();

// SAFE: Parameterized
DB::select("SELECT * FROM users WHERE name = ?", [$name]);
User::whereRaw("name = ?", [$name])->get();
```

### Category 9: Blade Escape Bypass

```php
// SAFE: Blade {{ }} auto-escapes
{{ $userInput }} // HTML-encoded

// VULNERABLE: {!! !!} renders raw HTML
{!! $userInput !!} // XSS if user-controlled!
```

### Category 10: WordPress Security

```php
// VULNERABLE: Missing nonce verification
function handle_ajax() {
    $data = $_POST['data']; // No nonce check → CSRF!
}

// SAFE
function handle_ajax() {
    check_ajax_referer('my_nonce', 'security');
    $data = sanitize_text_field($_POST['data']);
}

// VULNERABLE: $wpdb without prepare
$wpdb->query("SELECT * FROM users WHERE id = " . $_GET['id']);

// SAFE
$wpdb->prepare("SELECT * FROM users WHERE id = %d", $_GET['id']);
```

### Category 11: PDO Prepared Statements

```php
// VULNERABLE: Interpolation in PDO query
$pdo->query("SELECT * FROM users WHERE id = " . $_GET['id']);

// SAFE: Prepared statement
$stmt = $pdo->prepare("SELECT * FROM users WHERE id = ?");
$stmt->execute([$_GET['id']]);
```

### Category 12: file_get_contents SSRF

```php
// VULNERABLE: User-controlled URL
$content = file_get_contents($_GET['url']); // SSRF!
// Also reads local files: file:///etc/passwd

// SAFE: Validate URL scheme and host
$url = filter_var($_GET['url'], FILTER_VALIDATE_URL);
$parsed = parse_url($url);
if (!in_array($parsed['host'], $allowedHosts)) die('Blocked');
```

### Category 13: Session Security

```php
// VULNERABLE: Session fixation
session_start(); // Accepts session ID from URL or cookie without regeneration

// SAFE: Regenerate on auth change
session_start();
session_regenerate_id(true); // After login

// Configuration
ini_set('session.use_only_cookies', 1);
ini_set('session.use_strict_mode', 1);
ini_set('session.cookie_httponly', 1);
ini_set('session.cookie_secure', 1);
ini_set('session.cookie_samesite', 'Strict');
```

### Category 14: assert() Code Execution

```php
// VULNERABLE: assert() can execute code (PHP < 8.0)
assert($_GET['expr']); // Executes as PHP code!

// PHP 8.0+ treats assert() as a language construct, not eval
```

### Category 15: Composer Supply Chain

- Check for typosquatted package names in `composer.json`
- Review `scripts` section for dangerous post-install hooks
- Verify `composer.lock` is committed and reviewed

### Category 16: curl_exec Misuse

```php
// VULNERABLE: SSRF + SSL bypass
$ch = curl_init($_GET['url']);
curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false); // Disables SSL!
$result = curl_exec($ch);

// SAFE: Validate URL, enable SSL
curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, true);
curl_setopt($ch, CURLOPT_PROTOCOLS, CURLPROTO_HTTPS); // HTTPS only
```

### Category 17: md5/sha1 for Security

```php
// VULNERABLE: MD5 for passwords
$hash = md5($password);
$hash = md5($password . $salt); // Still weak!

// SAFE: password_hash (bcrypt by default)
$hash = password_hash($password, PASSWORD_DEFAULT);
if (password_verify($input, $hash)) { /* ... */ }
```

### Category 18: strcmp() Bypass

```php
// VULNERABLE: strcmp returns NULL for non-string args
if (strcmp($_POST['token'], $secret) == 0) { /* ... */ }
// POST token[]=1 → strcmp([], "secret") returns NULL → NULL == 0 is TRUE

// SAFE: Type check first or use hash_equals
if (!is_string($_POST['token'])) die('Invalid');
if (hash_equals($secret, $_POST['token'])) { /* ... */ }
```

### Category 19: PHP 8.x Security Features

- Fibers: no direct security risk but async code may introduce race conditions
- JIT: limited attack surface but potential for new bug classes
- Named arguments: check for parameter name injection in dynamic calls
- Enums: use for type-safe comparisons (replaces loose string matching)

### Category 20: Error Disclosure

```php
// VULNERABLE: Display errors in production
ini_set('display_errors', 1);
error_reporting(E_ALL);

// SAFE: Log only
ini_set('display_errors', 0);
ini_set('log_errors', 1);
ini_set('error_log', '/var/log/php/error.log');
```

## Output Format

### Finding: PHP-{NNN}
- **Title:** PHP-specific vulnerability
- **Severity:** Critical | High | Medium | Low
- **Confidence:** 0-100
- **File:** file/path:line
- **Vulnerability Type:** CWE-XXX
- **Description:** What was found
- **Remediation:** PHP-idiomatic fix
- **References:** CWE link, PHP documentation
