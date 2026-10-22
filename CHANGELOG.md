# Changelog

Brand Navigation follows [Semantic Versioning](https://semver.org/). Git tags
and matching GitHub Releases identify published versions; Discourse continues
to discover component updates from commits on the installed remote branch.

## 1.0.0-rc.5 - 2026-10-22

- Submit only explicitly edited Appearance colors and reconcile successful
  saved values; clear no-op Inherit all drafts.
- Improve compact submenu keyboard entry and Custom checkbox names/focus.
- Keep long linked-parent labels and their caret within the mobile bar.
- Hide the compact trigger when no brand or navigation content can render.
- Avoid unnecessary icon subscriptions for label-only navigation entries.
- Clarify shared-component staging, disabling/detaching, and Escape behavior.
- Adopt ESR tracking for subsequent releases/prereleases; retain exact tested
  versions and distinguish policy adoption from catching up with the schedule.
- Record the prior testing-execution failure and focused verified fixes.
  E01 immediate native-field/picker display staleness remains unresolved;
  incomplete coverage is not evidence of additional product bugs.

## 1.0.0-rc.4 - 2026-10-18

- Clarify administration labels, direct color entry and theme inheritance.
- Explain menu ordering within each Surface and label the Move up / Move down controls.
- Update documentation, support links and header/settings previews.

## 1.0.0-rc.3 - 2026-10-17

- Add independent desktop/mobile sizes for Brand Navigation core-header icons
  and link text, defaulting to Discourse's theme sizing.
- Add core-header normal and hover/focus text colors and a shared hover/focus
  background override, without changing native Discourse controls.
- Add submenu hover/focus text and icon color so administrators can keep normal
  text readable against a different hover background.
- Include the optional colors and sizes in configuration bundles, preserving
  default inheritance and older bundles.
- Correct JavaScript lint coverage and resolve the uncovered findings.

## 1.0.0-rc.2 - 2026-10-17

- Add separate core-header icon and hover/focus color controls, inheriting the
  active theme by default, with Appearance pickers and configuration portability.
- Add per-link core-header alignment beside the logo or with the header controls;
  existing links retain their right-side placement.
- Keep core-header links and icons before Sign Up and Log In in both alignments,
  including the default right-side position.
- Replace internal schema names in the native editor with friendly Menu item and
  Submenu item display labels, without changing saved schema identities.
- Clarify that Section controls the brand bar and that saved navigation changes
  require a refreshed forum page for verification.
- Keep mixed left/right header links and native controls usable on compact
  screens and minimized-topic headers, including bounded RTL checks, measured
  header offsets, and menu/keyboard restoration.
- Escape terminal control characters in local bundle-validation diagnostics,
  including malformed JSON and filesystem errors, while preserving trusted
  usage and validation line breaks.
- Add direct text links and icons with labels to the Discourse core header.
  The new `header_presentation` control defaults to `icon_only`, preserving
  existing site-header entries. Text remains available when an optional icon
  has not loaded or is unavailable.
- Validate and round-trip the new presentation setting in configuration
  bundles, retaining safe URLs, audience/device rules, and embed exclusion.
- Document migration from the separate text-based Custom Header Links component.
- Save native administrator-editor tracked rows through a validated plain-data
  snapshot, without weakening configuration-bundle validation.
- Keep the mobile menu and logo usable alongside core-header text links at
  320px and 390px, with bounded text truncation and the full accessible label.

This release candidate retains the documented narrow-header and manual
acceptance limits in [`docs/TESTING.md`](docs/TESTING.md#rc2-feature-verification-historical).

## 1.0.0-rc.1 - 2026-09-08

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
- Document source credits, licensing and project history.
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

Version `v0.9.0` is the first reviewed preview release. Version
`v1.0.0-rc.1` is the first stable-track release candidate; subsequent candidate
changes use increasing `v1.0.0-rc.N` identifiers. Version `v1.0.0` is reserved
for the documented, multi-site-tested release with no known release blockers.
