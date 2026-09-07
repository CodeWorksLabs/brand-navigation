# Changelog

Brand Navigation follows [Semantic Versioning](https://semver.org/). Git tags
and matching GitHub Releases identify published versions; Discourse continues
to discover component updates from commits on the installed remote branch.

## Unreleased

- Replace the historical header-icon binding pattern with an independently
  authored lexical component factory while retaining the documented
  `api.headerIcons` integration and `GPL-2.0-or-later` license.
- Make submenu descriptions inherit the configured submenu foreground and use
  the configured hover/highlight color for submenu rows.
- Keep browser-based settings import/export as the supported migration surface
  and limit the local CLI to offline bundle validation.
- Keep administrator appearance and bundle controls available for supported
  local copies, mirrors, repository transfers, and maintained forks.
- Add translated fallback messages and accurately document the English-only
  detailed bundle-validation boundary.
- Add a durable AI-assisted authorship and source-provenance record with pinned
  upstream revisions, license evidence, implementation history, and release
  controls.
- Accept six-digit administrator color values with or without a leading `#`
  and normalize picker and configuration-bundle values to `#RRGGBB`.
- Add administrator color pickers for bar background, bar text, hover/highlight,
  submenu background, and submenu text, with per-color Discourse palette
  inheritance and configuration-bundle portability.
- Add an explicit per-item Link or Submenu group behavior so administrators can
  use a top-level label as navigation or as a submenu-only control without
  placeholder URLs.
- Formalize release versioning and compatibility evidence.
- Remediate the findings from complete codebase review
  `BN-CODEBASE-20260905`.
- Serialize structured object settings for Discourse's administrator update
  endpoint while retaining parsed values in the local settings model.
- Add the standard Ruby development harness and compatible theme-test imports
  required by the official Discourse component workflow.
- Pin the Ruby lint-tool versions used by verification CI.

The first tagged preview candidate is planned as `v0.9.0` after correction
review and required runtime verification. Version `v1.0.0` is reserved for the
documented, multi-site-tested release with no known release blockers.
