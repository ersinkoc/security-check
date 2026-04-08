---
name: sc-lang-csharp
description: C#/.NET-specific security deep scan
---

# SC: C#/.NET Security Deep Scan

## Purpose

Detects C#/.NET-specific security anti-patterns including BinaryFormatter deserialization, ASP.NET Core misconfigurations, Entity Framework raw SQL injection, Blazor/SignalR vulnerabilities, and unsafe code risks. Covers the .NET ecosystem's unique attack surface.

## Activation

Activates when C# or .NET is detected in `security-report/architecture.md`.

## Checklist Reference

References `checklists/csharp-security-checklist.md`.

## C#/.NET-Specific Vulnerability Patterns

### Category 1: BinaryFormatter Deserialization RCE

```csharp
// VULNERABLE: BinaryFormatter is ALWAYS dangerous — Microsoft deprecated it
BinaryFormatter bf = new BinaryFormatter();
var obj = bf.Deserialize(stream); // Gadget chain → RCE guaranteed

// Also dangerous: SoapFormatter, NetDataContractSerializer, LosFormatter,
// ObjectStateFormatter

// SAFE: Use System.Text.Json or JsonSerializer
var obj = JsonSerializer.Deserialize<MyType>(jsonString);
```

### Category 2: ASP.NET Model Binding Mass Assignment

```csharp
// VULNERABLE: Binding all properties
[HttpPost]
public IActionResult Create(User user) {
    _context.Users.Add(user); // IsAdmin, Role settable!
}

// SAFE: Use [Bind] or DTO
[HttpPost]
public IActionResult Create([Bind("Name,Email")] User user) { }

// Or DTO pattern
public IActionResult Create(CreateUserDto dto) {
    var user = new User { Name = dto.Name, Email = dto.Email };
}
```

### Category 3: ViewState Tampering (Legacy WebForms)

```csharp
// VULNERABLE: ViewState without MAC validation (legacy ASP.NET)
// web.config: <pages enableViewStateMac="false" />

// SAFE: Always enable MAC (default in modern ASP.NET)
// <pages enableViewStateMac="true" />
```

### Category 4: Entity Framework Raw SQL Injection

```csharp
// VULNERABLE: String interpolation in raw SQL
var users = context.Users
    .FromSqlRaw($"SELECT * FROM Users WHERE Name = '{name}'")
    .ToList();

// SAFE: Parameterized
var users = context.Users
    .FromSqlRaw("SELECT * FROM Users WHERE Name = {0}", name)
    .ToList();

// SAFE: FromSqlInterpolated (auto-parameterizes)
var users = context.Users
    .FromSqlInterpolated($"SELECT * FROM Users WHERE Name = {name}")
    .ToList();
```

### Category 5: Process.Start Command Injection

```csharp
// VULNERABLE: User input in process arguments
Process.Start("cmd.exe", $"/c dir {userInput}");

// SAFE: Use ProcessStartInfo with argument list
var psi = new ProcessStartInfo("dir") {
    ArgumentList = { userInput },
    UseShellExecute = false
};
```

### Category 6: Path.Combine Traversal

```csharp
// VULNERABLE: Path.Combine with absolute path resets
Path.Combine(@"C:\uploads", @"C:\windows\system32\cmd.exe");
// Returns: C:\windows\system32\cmd.exe

// Also: Path.Combine(@"C:\uploads", @"..\..\..\etc\passwd");

// SAFE: Validate resolved path
var basePath = Path.GetFullPath(@"C:\uploads");
var fullPath = Path.GetFullPath(Path.Combine(basePath, userInput));
if (!fullPath.StartsWith(basePath + Path.DirectorySeparatorChar))
    throw new UnauthorizedAccessException();
```

### Category 7: Blazor JS Interop Injection

```csharp
// VULNERABLE: User input in JS interop call
await JSRuntime.InvokeVoidAsync("eval", userInput); // Code execution!

// VULNERABLE: Building JS dynamically
await JSRuntime.InvokeVoidAsync("dangerousFunction", $"alert('{userInput}')");

// SAFE: Pass data as parameters, not code
await JSRuntime.InvokeVoidAsync("safeFunction", userInput);
// JS: function safeFunction(data) { element.textContent = data; }
```

### Category 8: WASM Data Exposure (Blazor WebAssembly)

```csharp
// VULNERABLE: Secrets in Blazor WASM (client-side!)
// appsettings.json in wwwroot is downloadable
{
    "ApiSecret": "sk_live_abc123" // Visible to anyone!
}

// SAFE: Keep secrets server-side, call API from WASM
```

### Category 9: Regex DoS (System.Text.RegularExpressions)

```csharp
// VULNERABLE: Catastrophic backtracking
var regex = new Regex(@"^(a+)+$");
regex.IsMatch("aaaaaaaaaaaaaaaaaaaaaaaaa!"); // Hangs

// SAFE: Use timeout
var regex = new Regex(@"^(a+)+$", RegexOptions.None, TimeSpan.FromSeconds(1));
// .NET 7+: Use GeneratedRegex for compile-time safety
```

### Category 10: SignalR Hub Authorization

```csharp
// VULNERABLE: Hub method without authorization
public class AdminHub : Hub {
    public async Task DeleteUser(string userId) {
        await _userService.Delete(userId); // Anyone connected can call!
    }
}

// SAFE: Authorize hub or methods
[Authorize(Roles = "Admin")]
public class AdminHub : Hub { }
```

### Category 11: HttpClient SSRF

```csharp
// VULNERABLE: User-controlled URL
var response = await _httpClient.GetAsync(userUrl);

// VULNERABLE: Disabled certificate validation
var handler = new HttpClientHandler {
    ServerCertificateCustomValidationCallback = (_, _, _, _) => true
};

// SAFE: Validate URL, proper cert validation
var uri = new Uri(userUrl);
if (!_allowedHosts.Contains(uri.Host)) throw new InvalidOperationException();
```

### Category 12: XmlSerializer XXE

```csharp
// VULNERABLE: XmlDocument with resolver
var doc = new XmlDocument();
doc.XmlResolver = new XmlUrlResolver(); // Resolves external entities!
doc.LoadXml(userInput);

// SAFE: Null resolver
var doc = new XmlDocument();
doc.XmlResolver = null;
doc.LoadXml(userInput);

// Or XmlReaderSettings
var settings = new XmlReaderSettings {
    DtdProcessing = DtdProcessing.Prohibit,
    XmlResolver = null
};
```

### Category 13: .NET MAUI Local Storage

```csharp
// VULNERABLE: Sensitive data in Preferences (plaintext)
Preferences.Set("auth_token", token); // Stored in plaintext!

// SAFE: Use SecureStorage
await SecureStorage.SetAsync("auth_token", token); // Platform-encrypted
```

### Category 14: NuGet Supply Chain

- Check for package substitution attacks (internal→public registry)
- Review `nuget.config` for untrusted package sources
- Verify package signatures when available
- Check for build script execution in package install

### Category 15: Unsafe Code / Span<T>

```csharp
// VULNERABLE: unsafe with unchecked pointer arithmetic
unsafe {
    int* ptr = (int*)Marshal.AllocHGlobal(sizeof(int) * count);
    for (int i = 0; i <= count; i++) // Off-by-one!
        ptr[i] = 0; // Buffer overflow
}

// SAFE: Use Span<T> for bounds-checked memory access
Span<int> span = stackalloc int[count];
span.Fill(0);
```

### Category 16: Razor Page Injection

```cshtml
<!-- VULNERABLE: Raw HTML output -->
@Html.Raw(Model.UserInput)  <!-- XSS! -->

<!-- SAFE: Razor auto-escapes @ expressions -->
@Model.UserInput  <!-- Auto-encoded -->
```

### Category 17: IConfiguration Secrets Exposure

```csharp
// VULNERABLE: Secrets in appsettings.json (committed to git)
{
    "ConnectionStrings": {
        "Default": "Server=db;Password=secret123;"
    }
}

// SAFE: Use User Secrets (dev) or environment variables (prod)
// dotnet user-secrets set "ConnectionStrings:Default" "..."
// Or Azure Key Vault, AWS Secrets Manager
```

### Category 18: Middleware Ordering

```csharp
// VULNERABLE: Auth after endpoints
app.MapControllers(); // Endpoints registered
app.UseAuthentication(); // Too late!
app.UseAuthorization();

// SAFE: Correct order
app.UseAuthentication();
app.UseAuthorization();
app.MapControllers();
```

### Category 19: Kestrel Configuration

```csharp
// VULNERABLE: No request size limits
builder.WebHost.ConfigureKestrel(options => {
    options.Limits.MaxRequestBodySize = null; // Unlimited!
});

// SAFE: Set appropriate limits
options.Limits.MaxRequestBodySize = 10 * 1024 * 1024; // 10MB
options.Limits.MaxRequestHeadersTotalSize = 32768;
options.Limits.RequestHeadersTimeout = TimeSpan.FromSeconds(30);
```

### Category 20: Newtonsoft.Json TypeNameHandling

```csharp
// VULNERABLE: TypeNameHandling enables RCE
var settings = new JsonSerializerSettings {
    TypeNameHandling = TypeNameHandling.All // Arbitrary type instantiation!
};
var obj = JsonConvert.DeserializeObject(json, settings);

// SAFE: Don't use TypeNameHandling, or use SerializationBinder
var settings = new JsonSerializerSettings {
    TypeNameHandling = TypeNameHandling.None // Default, safe
};
```

## Output Format

### Finding: CS-{NNN}
- **Title:** C#/.NET-specific vulnerability
- **Severity:** Critical | High | Medium | Low
- **Confidence:** 0-100
- **File:** file/path:line
- **Vulnerability Type:** CWE-XXX
- **Description:** What was found
- **Remediation:** .NET-idiomatic fix
- **References:** CWE link, Microsoft documentation
