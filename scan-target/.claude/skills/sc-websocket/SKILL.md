---
name: sc-websocket
description: WebSocket security flaw detection — missing origin validation, authentication bypass, and message injection
license: MIT
metadata:
  author: ersinkoc
  category: security
  version: "1.0.0"
---

# SC: WebSocket Security

## Purpose

Detects WebSocket security vulnerabilities including missing origin validation, missing authentication on WebSocket upgrade, cross-site WebSocket hijacking, message injection, missing rate limiting, and sensitive data over unencrypted connections. Covers Socket.IO, ws, gorilla/websocket, and SignalR.

## Activation

Called by sc-orchestrator during Phase 2 when WebSocket usage is detected.

## Phase 1: Discovery

### Keyword Patterns to Search
```
"WebSocket", "ws://", "wss://", "socket.io", "Socket(",
"io.connect(", "gorilla/websocket", "Upgrader",
"ws.Server", "WebSocketServer", "SignalR", "Hub",
"onmessage", "on('message'", "on('connection'"
```

### Vulnerability Patterns

**1. Missing Origin Validation:**
```go
// VULNERABLE: Accept any origin
var upgrader = websocket.Upgrader{
    CheckOrigin: func(r *http.Request) bool {
        return true  // Accepts connections from any origin!
    },
}

// SAFE: Validate origin
var upgrader = websocket.Upgrader{
    CheckOrigin: func(r *http.Request) bool {
        origin := r.Header.Get("Origin")
        return origin == "https://app.example.com"
    },
}
```

**2. Missing Authentication:**
```javascript
// VULNERABLE: No auth check on WebSocket connection
wss.on('connection', (ws, req) => {
  ws.on('message', (msg) => { handleMessage(msg); });
});

// SAFE: Verify auth on connection
wss.on('connection', (ws, req) => {
  const token = req.url.split('token=')[1];
  if (!verifyToken(token)) { ws.close(1008, 'Unauthorized'); return; }
  ws.on('message', (msg) => { handleMessage(msg); });
});
```

**3. Missing Message Validation:**
```javascript
// VULNERABLE: Trusting WebSocket message content
ws.on('message', (msg) => {
  const data = JSON.parse(msg);
  db.query(`SELECT * FROM ${data.table}`);  // Injection!
});
```

## Severity Classification

- **Critical:** WebSocket allowing data access without authentication
- **High:** Cross-site WebSocket hijacking (missing origin check + cookie auth)
- **Medium:** Missing rate limiting, unencrypted WebSocket (ws://)
- **Low:** Verbose error messages over WebSocket

## Output Format

### Finding: WS-{NNN}
- **Title:** WebSocket {vulnerability type}
- **Severity:** Critical | High | Medium | Low
- **Confidence:** 0-100
- **File:** file/path:line
- **Vulnerability Type:** CWE-1385 (Missing Origin Validation in WebSocket) | CWE-306 (Missing Authentication)
- **Description:** {What was found}
- **Impact:** Cross-site WebSocket hijacking, unauthorized data access, message injection.
- **Remediation:** Validate origin, require authentication, validate messages, use wss://.
- **References:** https://cwe.mitre.org/data/definitions/1385.html

## Common False Positives

1. **Development servers** — ws:// on localhost in development
2. **Public broadcast channels** — WebSocket channels intentionally public (chat, notifications)
3. **Token-based auth in URL** — authentication via query param token (valid pattern for WebSocket)
