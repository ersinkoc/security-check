---
name: sc-rce
description: Remote Code Execution detection via eval, exec, dynamic code loading, and code injection vectors
---

# SC: Remote Code Execution (RCE)

## Purpose

Detects remote code execution vulnerabilities where user-controlled input reaches functions that evaluate or execute code dynamically. Covers eval-based injection, dynamic function construction, script engine execution, template code execution, and code loading from untrusted sources. This skill focuses on code evaluation mechanisms beyond command injection (covered by sc-cmdi) and deserialization (covered by sc-deserialization).

## Activation

Called by sc-orchestrator during Phase 2. Runs against all detected languages.

## Phase 1: Discovery

### Keyword Patterns to Search
```
# Python
"eval(", "exec(", "compile(", "__import__(", "importlib.import_module(",
"builtins.__import__", "code.InteractiveInterpreter", "ast.literal_eval"

# JavaScript/Node.js
"eval(", "Function(", "setTimeout(.*string", "setInterval(.*string",
"vm.runInNewContext(", "vm.runInThisContext(", "vm.createContext(",
"require(.*variable", "import(.*variable", "new Function("

# PHP
"eval(", "assert(", "create_function(", "preg_replace(.*/e",
"call_user_func(", "call_user_func_array(", "array_map(",
"usort(.*\\$", "include(.*\\$", "require(.*\\$"

# Java
"ScriptEngine", "ScriptEngineManager", "Nashorn", "GraalVM",
"GroovyShell", "GroovyClassLoader", "javax.script",
"MethodHandle", "ClassLoader.loadClass"

# C#
"CSharpCodeProvider", "Roslyn", "Microsoft.CodeAnalysis",
"Assembly.Load(", "Activator.CreateInstance(",
"Type.GetType(.*variable", "DynamicMethod"

# Go
"plugin.Open(", "yaegi", "go/ast"

# Ruby
"eval(", "instance_eval(", "class_eval(", "module_eval(",
"send(.*variable", "public_send(", "method("
```

### Data Flow Tracing
Trace user input to any dynamic code evaluation function. Key patterns:
- HTTP parameter → variable → eval()
- Database value (originally user input) → code execution function
- Configuration file (user-editable) → dynamic import/require
- WebSocket message → eval-like function

## Phase 2: Verification

### Python Examples
```python
# VULNERABLE: eval with user input
result = eval(request.GET['expression'])

# VULNERABLE: exec with user input
exec(request.POST['code'])

# SAFE: ast.literal_eval for safe subset
import ast
result = ast.literal_eval(request.GET['data'])  # Only parses literals

# SAFE: Restricted evaluation with custom namespace
allowed_names = {"abs": abs, "min": min, "max": max}
result = eval(expression, {"__builtins__": {}}, allowed_names)
# Note: Still risky — sandbox escapes are possible
```

### JavaScript Examples
```javascript
// VULNERABLE: eval with user input
const result = eval(req.body.expression);

// VULNERABLE: Function constructor
const fn = new Function('return ' + req.body.code);

// VULNERABLE: vm module (escapable sandbox)
const vm = require('vm');
vm.runInNewContext(req.body.code, sandbox);

// SAFE: Use a math parser library instead
const mathjs = require('mathjs');
const result = mathjs.evaluate(req.body.expression);
```

### PHP Examples
```php
// VULNERABLE: eval
eval($_POST['code']);

// VULNERABLE: Dynamic function call
$func = $_GET['action'];
$func(); // Calls arbitrary function

// SAFE: Allowlist of functions
$allowed = ['view', 'edit', 'delete'];
if (in_array($_GET['action'], $allowed)) {
    $func = $_GET['action'];
    $func();
}
```

## Severity Classification

- **Critical:** Direct eval/exec/Function with HTTP request input, no sandbox or restrictions
- **High:** Code execution through framework features (ScriptEngine, vm module) with user input
- **Medium:** Dynamic code execution with partial restrictions or requiring authenticated access
- **Low:** eval with constant expressions, or vm module with timeout but no network restriction

## Output Format

### Finding: RCE-{NNN}
- **Title:** Remote Code Execution via {eval|Function|exec|ScriptEngine} in {location}
- **Severity:** Critical | High | Medium | Low
- **Confidence:** 0-100
- **File:** file/path:line
- **Vulnerability Type:** CWE-94 (Code Injection) | CWE-95 (Eval Injection)
- **Description:** User input from {source} reaches {code execution function} allowing arbitrary code execution.
- **Impact:** Complete server compromise, data theft, lateral movement, persistent backdoor.
- **Remediation:** Remove eval/exec usage. Use safe parsing libraries. Implement strict allowlisting.
- **References:** https://cwe.mitre.org/data/definitions/94.html

## Common False Positives

1. **eval with constants** — `eval("1+2")` with no user input is not exploitable
2. **ast.literal_eval** — Python's literal_eval only parses literal values (safe for simple data)
3. **Template engine rendering** — template engines are covered by sc-ssti, not this skill
4. **Build/dev tooling** — webpack, babel, jest using eval internally for build purposes
5. **REPL/debug tools** — eval in development REPL tools not deployed to production
6. **Math expression parsers** — libraries like mathjs safely evaluate mathematical expressions
