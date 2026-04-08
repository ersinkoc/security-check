# Contributing to security-check

Thank you for your interest in contributing to security-check! This guide will help you get started.

## How to Contribute

### Reporting Issues

- Use GitHub Issues to report bugs or suggest features
- Include as much detail as possible: steps to reproduce, expected vs actual behavior
- For security vulnerabilities in security-check itself, please email security@ecostack.ee

### Adding a New Vulnerability Skill

1. Create a new folder `skills/sc-{skill-name}/` with a `SKILL.md` file (use `templates/SKILL_TEMPLATE.md` as the starting point)
2. Follow the skill writing standard documented in the template
3. Ensure your skill has:
   - Clear Phase 1 (Discovery) with specific file patterns and grep patterns
   - Thorough Phase 2 (Verification) with false positive elimination
   - Accurate CWE references
   - At least 3 vulnerable/safe code examples per language
   - A "Common False Positives" section
4. Update `scan-target/CLAUDE.md` and `scan-target/AGENTS.md` to reference your skill
5. Submit a pull request

### Adding a New Language Skill

1. Create a new folder `skills/sc-lang-{language}/` with a `SKILL.md` file (use `templates/LANG_SKILL_TEMPLATE.md`)
2. Create a matching checklist at `skills/sc-lang-{language}/references/{language}-security-checklist.md` using `templates/CHECKLIST_TEMPLATE.md`
3. The checklist must contain at least 400 unique security check items
4. Each item must have a unique ID, description, severity, and CWE reference
5. Submit a pull request

### Improving Existing Skills

- Add new detection patterns
- Improve false positive elimination logic
- Add language-specific notes
- Add new code examples (vulnerable + safe)
- Update CWE references

### Improving Checklists

- Add new security check items (maintain the ID scheme)
- Improve descriptions for clarity
- Update severity levels based on real-world impact data
- Add framework-specific checks

## Code Style

- All files must be written in English
- Skill files must be at least 150 lines
- Use consistent markdown formatting
- CWE references must be accurate and verifiable
- Examples must show both vulnerable and safe code

## Pull Request Process

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/my-new-skill`)
3. Make your changes
4. Test your changes by running security-check against a sample project
5. Submit a pull request with a clear description

## Commit Messages

Use conventional commit format:

```
feat: add sc-prototype-pollution skill
fix: improve false positive detection in sc-xss
docs: update Go checklist with fiber framework checks
```

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

## Questions?

Open an issue or reach out to Ersin Koc at ecostack.ee.
