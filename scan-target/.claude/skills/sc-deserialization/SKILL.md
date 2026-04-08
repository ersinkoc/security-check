---
name: sc-deserialization
description: Insecure deserialization detection across all serialization formats and languages
license: MIT
metadata:
  author: ersinkoc
  category: security
  version: "1.0.0"
---

# SC: Insecure Deserialization

## Purpose

Detects insecure deserialization vulnerabilities where untrusted data is deserialized using formats that support object instantiation, enabling remote code execution, denial of service, or authentication bypass. Covers Python pickle, Java ObjectInputStream, PHP unserialize, .NET BinaryFormatter, Ruby Marshal, Node.js serialize, and unsafe YAML/XML deserialization.

## Activation

Called by sc-orchestrator during Phase 2. Runs against all detected languages.

## Phase 1: Discovery

### Keyword Patterns to Search
```
# Python
"pickle.loads(", "pickle.load(", "cPickle", "shelve.open(",
"yaml.load(", "yaml.unsafe_load(", "marshal.loads(",
"dill.loads(", "jsonpickle.decode("

# Java
"ObjectInputStream", "readObject(", "readUnshared(",
"XMLDecoder", "XStream", "Fastjson", "JSON.parseObject(",
"ObjectMapper.*enableDefaultTyping", "JsonTypeInfo",
"Hessian", "Burlap", "Kryo", "SnakeYAML"

# PHP
"unserialize(", "phar://", "maybe_unserialize(",
"S:.*:\"", "O:.*:\""

# C#/.NET
"BinaryFormatter", "SoapFormatter", "ObjectStateFormatter",
"NetDataContractSerializer", "LosFormatter",
"TypeNameHandling", "JsonConvert.*TypeNameHandling"

# Ruby
"Marshal.load(", "Marshal.restore(", "YAML.load(",
"Psych.load("

# Node.js
"node-serialize", "serialize", "funcster",
"cryo.parse(", "js-yaml.load("
```

### Dangerous Deserialization by Language

**Python — pickle RCE:**
```python
# VULNERABLE: Deserializing untrusted pickle data
import pickle
data = pickle.loads(request.body)  # RCE via __reduce__

# SAFE: Use JSON for untrusted data
import json
data = json.loads(request.body)
```

**Java — ObjectInputStream:**
```java
// VULNERABLE: Deserializing untrusted Java objects
ObjectInputStream ois = new ObjectInputStream(inputStream);
Object obj = ois.readObject();  // Gadget chains can execute code

// SAFE: Use allowlist-based deserialization filter (Java 9+)
ObjectInputFilter filter = ObjectInputFilter.Config.createFilter(
    "com.myapp.models.*;!*"
);
ois.setObjectInputFilter(filter);
```

**PHP — unserialize:**
```php
// VULNERABLE: Unserializing user input
$data = unserialize($_POST['data']);  // POP chain via __wakeup, __destruct

// SAFE: Use JSON
$data = json_decode($_POST['data'], true);

// Or restrict allowed classes
$data = unserialize($input, ['allowed_classes' => ['SafeClass']]);
```

**C# — BinaryFormatter:**
```csharp
// VULNERABLE: BinaryFormatter is ALWAYS dangerous with untrusted data
BinaryFormatter bf = new BinaryFormatter();
var obj = bf.Deserialize(stream);  // RCE guaranteed with right payload

// SAFE: Use System.Text.Json
var obj = JsonSerializer.Deserialize<MyType>(jsonString);
```

**YAML — unsafe load:**
```python
# VULNERABLE: yaml.load can instantiate Python objects
import yaml
data = yaml.load(user_input)  # Can create arbitrary objects

# SAFE: yaml.safe_load only allows basic types
data = yaml.safe_load(user_input)
```

## Phase 2: Verification

### Exploitability Assessment
1. Is the deserialized data from an untrusted source (HTTP, file upload, database)?
2. Are there known gadget chains available in the classpath/dependencies?
3. Is the deserialization format capable of arbitrary object instantiation?
4. Are there type restrictions or allowlisting on deserialized types?

### Safe vs Unsafe Formats
| Format | Risk Level | Notes |
|--------|-----------|-------|
| JSON (standard) | Safe | No code execution capability |
| XML (data only) | Safe | Unless combined with XXE |
| Protocol Buffers | Safe | Schema-defined, no arbitrary types |
| MessagePack | Safe | Data only |
| Python pickle | Dangerous | Arbitrary code execution via __reduce__ |
| Java ObjectInputStream | Dangerous | Gadget chain exploitation |
| PHP unserialize | Dangerous | POP chain via magic methods |
| .NET BinaryFormatter | Dangerous | Microsoft deprecated it due to RCE |
| Ruby Marshal | Dangerous | Arbitrary object creation |
| YAML (full) | Dangerous | Can instantiate objects in most parsers |

## Severity Classification

- **Critical:** Deserialization of untrusted data in a format supporting code execution (pickle, ObjectInputStream, BinaryFormatter, unserialize) on a network-accessible endpoint
- **High:** Unsafe YAML loading of user data, or deserialization with partial restrictions that may be bypassable
- **Medium:** Deserialization of semi-trusted data (internal service communication) using unsafe formats
- **Low:** Deserialization of trusted data (signed/encrypted) using unsafe formats, or safe format with minor risks

## Output Format

### Finding: DESER-{NNN}
- **Title:** Insecure {format} Deserialization in {location}
- **Severity:** Critical | High | Medium | Low
- **Confidence:** 0-100
- **File:** file/path:line
- **Vulnerability Type:** CWE-502 (Deserialization of Untrusted Data)
- **Description:** {Format} deserialization of {source} data allows arbitrary object instantiation.
- **Impact:** Remote code execution, denial of service, authentication bypass.
- **Remediation:** Replace {unsafe format} with JSON/protobuf. If unavoidable, implement type allowlisting.
- **References:** https://cwe.mitre.org/data/definitions/502.html

## Common False Positives

1. **JSON deserialization** — standard JSON parsing (json.loads, JSON.parse) is safe
2. **Pickle of trusted data** — internal caching with signed/encrypted pickle (still risky but lower priority)
3. **Java serialization in RMI** — internal JVM-to-JVM communication (still a risk but different attack surface)
4. **yaml.safe_load** — explicitly safe YAML loading
5. **PHP unserialize with allowed_classes** — restricted unserialize mitigates POP chains
6. **Protocol Buffers / MessagePack** — schema-based formats without code execution risk
