---
name: sc-local-ipc
description: Desktop, mobile, deep-link, webview bridge, privileged helper, and local IPC security
license: MIT
metadata:
  author: ersinkoc
  category: security
  version: "1.0.0"
---

# SC: Desktop, Mobile, and Local IPC Security

## Purpose

Find boundary failures between remote content, local applications, operating-system users, sandboxed processes, native UI, local daemons, and privileged helpers. A local path, process name, claimed sender, package name, or loopback address is not peer authentication.

## Activation

Run for Electron, Tauri, native desktop or mobile apps, webview hosts, custom URL schemes, app links, exported mobile components, browser native-messaging hosts, Unix sockets, named pipes, XPC, Binder, D-Bus, loopback RPC, privileged helpers, installers, updaters, or local daemons.

## Phase 1: Discovery

### Principal and channel map

Enumerate every process, app component, local endpoint, URI scheme, file association, webview origin, helper, installer, and updater. Record:

- realistic caller: remote origin, untrusted file, sandboxed child, another app, another OS user, or lower-privilege account;
- process identity, OS user, sandbox, integrity level, entitlements, and runtime privilege;
- channel creation, ownership, ACL, namespace, and peer-credential mechanism;
- callable operations and selected resources;
- per-operation authorization, confirmation, and current-session binding.

### Packaging and lifecycle

Read source-controlled manifests, entitlements, installer rules, native-messaging registrations, protocol handlers, service definitions, ACL creation, and update configuration. Note where final signing, merged manifests, installed ACLs, device policy, or OS-version behavior is not visible.

### Native bridge and file paths

Trace every webview/native bridge, IPC dispatcher, file-open handler, drag/drop entry, clipboard/pasteboard read, notification action, shared-memory region, temp file, and privileged file operation to its final sink.

## Phase 2: Vulnerability Hunting

### Deep links and handoffs

- Custom schemes or deep links mutate state, import data, select accounts, or complete authentication without a one-time current-session binding.
- OAuth, SSO, magic links, invites, pairing, or payment callbacks can return to the wrong installed app, profile, tenant, provider, or pending transaction.
- Duplicate parameters, URI normalization, ambiguous host/path matching, stale links, or replay change the selected operation.
- File-open, share, notification, or clipboard content triggers privileged behavior without binding to current user intent.

### Webviews and native bridges

- Remote, redirected, fallback, popup, or subframe content reaches a bridge intended only for packaged content.
- Origin is checked only at initial navigation or by unsafe prefix/suffix matching.
- A generic bridge lets content select arbitrary commands, files, IPC methods, credentials, URLs, or system actions.
- File, universal, mixed-content, custom-scheme, debugging, or navigation settings join trusted and untrusted origins.
- Return values expose local files, credentials, device data, or another account's state.

### Local IPC and exported components

- Unix sockets, named pipes, XPC, Binder, D-Bus, native messaging, loopback listeners, or shared memory accept peers without OS-backed identity.
- An authenticated channel belongs to one app/user but caller fields select another user, tenant, profile, or capability.
- Exported services, activities, receivers, providers, automation endpoints, or aliases perform app-internal operations for external callers.
- Predictable IDs, inherited handles, stale channels, reconnects, world-writable socket paths, or weak correlation cross peer boundaries.

### Privileged helpers and local files

- A low-privilege caller can select a privileged command, service, user, registry key, system setting, or file without final-resource authorization.
- Install, update, or repair logic consumes manifests, packages, scripts, working directories, symlinks, or state writable after approval.
- Check-then-use file logic follows replacement, symlink, mount, junction, hardlink, case, or normalization changes.
- Credential stores, token files, backups, logs, crash reports, notifications, or clipboard data are readable by a less privileged app, profile, or OS user.

### Account and device lifecycle

- Cached data, background work, widgets, notifications, local databases, webview storage, or biometric approvals survive logout or account switching.
- Backup/restore, device migration, undelete, or reinstall restores data or authority under a different current principal.
- Deferred actions execute after expiry or apply another profile's confirmation.

### Updates and loading

- Update metadata, packages, signatures, channels, rollback versions, or install destinations are not bound together.
- DLL/shared-library/plugin search paths or environment-controlled loaders cross from low-privilege writable directories into privileged processes.
- Signature verification succeeds for content that is not the exact installed artifact.

## Phase 3: Verification

1. Name the attacker's starting local or remote-content capability; do not treat all local users as equivalent.
2. Identify the crossed OS/app principal, entry channel, accepted argument or state, final resource, and unauthorized result.
3. Verify applicable sandbox, peer credentials, signing, entitlements, permissions, user consent, installer ACLs, and handler authorization.
4. For webview issues, cite navigation/origin control and the privileged native sink.
5. For IPC issues, cite channel peer authentication and per-resource authorization separately.
6. For helper and file issues, reason about the final opened object, not only the earlier path string.
7. Use dummy profiles and non-sensitive fixtures on an isolated machine or emulator; stop after the smallest harmless proof.
8. Mark unknown packaging, signing, merged-manifest, device-policy, installed-ACL, or OS behavior as `needs_validation`.

## Severity Classification

- **Critical:** A remote or low-privilege actor reaches arbitrary privileged code execution or broad system compromise.
- **High:** Significant cross-user data access, privileged helper abuse, authentication callback theft, or arbitrary sensitive file action.
- **Medium:** Limited unauthorized local action, account-lifecycle leakage, or bridge/component exposure with realistic conditions.
- **Low:** Narrow demonstrated disclosure or mutation. Missing optional hardening without a reachable protected asset is not a vulnerability.

## Platform Notes

- **Electron:** inspect `contextIsolation`, sandboxing, preload exposure, IPC sender/frame validation, navigation/window creation, and shell/openExternal URL policy.
- **Tauri:** inspect command allowlists/capabilities, window labels/origins, sidecars, updater signing, filesystem scopes, and deep links.
- **Windows:** inspect named-pipe security descriptors, service DACLs, impersonation, UAC helpers, junction/reparse points, installer repair, and DLL search order.
- **macOS/iOS:** inspect XPC audit tokens, entitlements, keychain access groups, URL schemes/universal links, App Transport Security, and webview handlers.
- **Android:** inspect exported components, intent filters, signature permissions, content-provider grants, WebView bridges, PendingIntent mutability, and backup rules.
- **Linux:** inspect Unix-socket ownership/mode, D-Bus policy, polkit actions, systemd units, desktop files, setuid/capabilities, and symlink-safe file APIs.

## Output Format

Write `security-report/findings/sc-local-ipc.json` using the shared candidate contract. Include attacker capability, OS/app principal, channel, peer identity, final resource, source trace, controls, observed result, packaging assumptions, and verdict.

## Common False Positives

- A same-user plaintext file is reported without identifying a less-privileged reader or stronger credential boundary.
- A loopback endpoint has OS-backed peer authentication and per-operation authorization.
- A component appears exported in source but the final source-controlled manifest deterministically disables it.
- Remote web content cannot navigate to or invoke the native bridge.
- A helper accepts broad input but independently normalizes and authorizes the final resource.
- A path check looks racy but the operation uses descriptor-relative no-follow APIs on the final object.

## Coverage Completion

Coverage requires accounting for every process, local endpoint, bridge, deep-link/file handler, exported component, privileged helper, installer/updater, and logout/restore lifecycle—or recording an explicit gap.

## Minimum Review Checklist

- [ ] Inventory processes, privileges, sandboxes, and execution identities.
- [ ] Name each realistic remote-content or local attacker capability.
- [ ] Inventory sockets, pipes, ports, XPC, Binder, D-Bus, and shared memory.
- [ ] Verify OS-backed peer identity for every local channel.
- [ ] Verify per-operation and final-resource authorization.
- [ ] Review channel creation ownership, ACLs, cleanup, and reconnects.
- [ ] Bind correlation IDs and handles to peer and session lifecycle.
- [ ] Inventory deep links, URL schemes, app links, and callbacks.
- [ ] Bind callbacks to current session, app, account, operation, and expiry.
- [ ] Review file-open, share, clipboard, notification, and drag/drop inputs.
- [ ] Inventory webviews, frames, navigation events, and native bridges.
- [ ] Validate origin at invocation time after every navigation transition.
- [ ] Minimize bridge methods and validate final normalized arguments.
- [ ] Review exported components in final source-controlled manifests.
- [ ] Review privileged helper dispatch and destination validation.
- [ ] Use descriptor-relative no-follow file operations where required.
- [ ] Review installer, repair, update, rollback, and plugin loading paths.
- [ ] Bind signatures to the exact installed bytes and destination.
- [ ] Review logout, account switch, backup, restore, and migration cleanup.
- [ ] Review local secrets against app, profile, and OS-user boundaries.
- [ ] Verify prompts and biometric approvals bind to the displayed action.
- [ ] Mark unknown signing, packaging, ACL, and device facts unresolved.
- [ ] Use only dummy local fixtures in isolated validation.
- [ ] Record each reviewed channel and lifecycle in the coverage ledger.
