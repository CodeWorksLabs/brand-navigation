# Changelog

Brand Navigation follows [Semantic Versioning](https://semver.org/). Git tags
and matching GitHub Releases identify published versions; Discourse continues
to discover component updates from commits on the installed remote branch.

## Unreleased

- Remove the duplicate Brand Navigation `enabled` setting and use Discourse's
  component-level **Enabled?** control as the single source of truth.
- Document a working staging-theme preparation and bundle-import workflow for
  the native single-switch model.
- Prevent an older asynchronous bundle-file read from replacing a newer file
  selection or pasted configuration.
- Keep linked-parent submenu children in normal mobile-menu flow so they cannot
  overlap following items.
- Adopt Discourse's `d-compat/<YYYY>.<M>` compatibility-branch convention,
  including the official daily branch-creation workflow and exact Discourse
  2026.8 release coverage.
- Fail closed until the accepted 2026.7 and 2026.8 compatibility seeds exist,
  serialize branch writers, and make compatibility-branch CI targets explicit.

## 0.9.0 - 2026-09-07

- Exercise the enabled component during Discourse's shared core-feature system
  coverage.
- Reject navigation data above Discourse's per-object setting limit before an
  administrator import can send any settings.
- Wait for Discourse's primary SVG sprite through a shared, request-free
  readiness observer; check its loaded symbols; fall back to visible labels
  when bar or submenu icons are unavailable; and omit unavailable direct
  site-header icons.
- Join that shared readiness observer when a retained site-header item becomes
  eligible after its initial render, so responsive visibility changes cannot
  strand a valid icon while the primary sprite is still loading.
- Reconcile the successor checkpoint into one unambiguous current release
  state while retaining dated historical evidence.

- Make administrator imports and color saves use immutable request snapshots,
  disable conflicting controls while writes are pending, and reconcile imported
  colors with their visible controls after success.
- Add deferred-completion tests at the administrator component boundary for
  save/import state and submitted-value reconciliation.
- Prevent exports larger than the matching importer accepts, reject non-string
  color values, and escape control characters in validation diagnostics.
- Enable the Discourse RuboCop gate for Ruby system specifications and document
  the intentionally moving dependencies inside the pinned Discourse workflow.
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

Version `v0.9.0` is the first reviewed preview release. The next release
candidate is `v1.0.0-rc.1`; subsequent candidate changes use increasing
`v1.0.0-rc.N` identifiers. Version `v1.0.0` is reserved for the documented,
multi-site-tested release with no known release blockers.
