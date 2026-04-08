# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [1.0.0] - 2026-04-08

### Added

- Initial release of security-check
- 40+ vulnerability detection skills across all major categories
  - Injection: SQL, NoSQL, GraphQL, XSS, SSTI, XXE, LDAP, Command, Header
  - Code Execution: RCE, Insecure Deserialization
  - Access Control: Authentication, Authorization, Privilege Escalation, Session
  - Data Exposure: Secrets, Sensitive Data, Cryptography Misuse
  - Server-Side: SSRF, Path Traversal, File Upload, Open Redirect
  - Client-Side: CSRF, CORS, Clickjacking, WebSocket
  - Logic: Business Logic, Race Conditions, Mass Assignment
  - API: API Security, Rate Limiting, JWT
  - Infrastructure: IaC, Docker, CI/CD
- 7 language-specific deep security scanners
  - Go, TypeScript/JavaScript, Python, PHP, Rust, Java/Kotlin, C#/.NET
- 400+ item security checklists per language
- 4-phase scanning pipeline: Recon, Hunt, Verify, Report
- Confidence scoring (0-100) with CVSS v3.1-style severity
- Supply chain and dependency analysis
- Infrastructure-as-Code scanning
- Diff mode for PR-level incremental scans
- Support for Claude Code, Codex, Cursor, Opencode, Windsurf, Gemini CLI
- One-command installation script
- Modular plugin architecture with templates
- Comprehensive documentation
