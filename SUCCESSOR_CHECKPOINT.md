# Brand Navigation successor checkpoint

Date: 2026-09-05  
Disposition: **ADMIN IMPORT/EXPORT AND SUBMENU INTERACTION IMPLEMENTED / LOCAL CHECKS PASS / SANDBOX RUNTIME UPDATE PENDING / REPEAL MIGRATION NOT YET APPLIED / NOT RELEASE-READY**

## Purpose and authority

Brand Navigation is an independently maintained Discourse theme component for
an optional brand header and one-level navigation hierarchy. It is not an
official Discourse product.

Phil authorized browser-based installation and testing on
`https://sandbox-forum.discussionbridge.dev/` and installation/configuration on
`https://forum.repealobbba.org/`. Browser administration is available through
Phil's authenticated Chrome tabs. SSH is unnecessary and should be reserved for
cases the supported UI cannot handle. Do not delete or disable predecessor
components without Phil's explicit direction.

## Canonical locations

- Local repository: `C:\CodeProjects\Products\Discourse Brand Navigation`
- Git remote: `https://github.com/CodeWorksLabs/brand-navigation.git`
- Branch: `main`
- Last sandbox-tested runtime commit: `c51a7f6bd2c683b362ea785bbaf8baa02fc5c58f`.
- Latest implementation commit: `c1cc27b6581602494d5716b53430fdbb70df189e`.

The older path `C:\CodeProjects\CodeWorksLabs\Discourse` no longer exists and
must not be used as this repository's working directory.

## Settled product decisions

- Visible name: `Brand Navigation`; repository slug: `brand-navigation`.
- Description: “A brand header and submenu navigation theme component for
  Discourse.”
- Do not imply Discourse ownership, maintenance, or official status.
- Credit Brand Header and Header Submenus for product inspiration. The current
  implementation was authored from specifications; no predecessor source code
  was intentionally copied.
- License: `GPL-2.0-or-later`.
- Structured administration and safe defaults are first-class requirements.
- One submenu level is supported; arbitrary deep nesting is excluded.
- DiscussionBridge contains no compatibility logic for this component.

## Non-negotiable runtime invariants

- Site-global brand/navigation content must not mount in supported Discourse
  embed contexts.
- Enforce exclusion at initializer and render boundaries using supported
  `EmbedMode.enabled` state.
- Do not use CSS hiding, hostname checks, DOM selectors, or DiscussionBridge
  detection for embed exclusion.
- Leave classic `embedded_header` and core embed behavior untouched.
- Preserve embedded content, topic navigation, sign-in, reply, like, quote,
  composer, and normal full-application sign-in behavior.

## Implemented surface

- Optional brand name, URL, light/dark logo, presentation, and target.
- Ordered direct links and one-level submenus with internal/external URLs.
- Per-entry titles, Font Awesome icons, and safe `_blank` rel handling.
- `everyone`, `anonymous`, and `authenticated` visibility.
- Desktop placement above or below the core header.
- Top-level left/right sections.
- `icon_and_label`, `label_only`, and `icon_only` entry presentation, with a
  visible-label fallback when an icon is unavailable.
- Mobile `menu`, `bar`, and `hidden` modes.
- Native `details`/`summary` submenu semantics, translated navigation labels,
  color-scheme variables, migration/rollback documentation, release material,
  and administrator/user documentation.
- One-open-submenu behavior with closure on outside click, Escape, link
  selection, or opening another submenu; Escape restores summary focus.
- Administrator-facing JSON bundle import/export on Brand Navigation's own
  component page when the component is attached to the administrator's active
  theme. Imports use Discourse's theme-setting model API and do not attach or
  enable the component.

## Current repository and runtime state

- `6bb45ec` fixed strict-mode GJS translation imports. It cleared the sandbox's
  administrator warning and produced no new Brand Navigation client error.
- `160a967` added practical sample defaults.
- `bc4ad96` added left/right sections, icon presentation, and correctly scoped
  theme translations. It is committed and pushed.
- Sandbox theme component id `1` is installed on Foundation and Horizon,
  enabled, configured at `below-site-header`, and updated to `c51a7f6`.
- Sandbox runtime verification after a fresh forum navigation passed: the
  component rendered, the landmark resolved to “Brand navigation,” the main
  links remained left, and authenticated “My Preferences” rendered at the
  right edge. No component warning was present.
- Repeal Brand Navigation component id `19` is installed but not attached to a
  theme. It was installed at `160a967` and still needs an update to `bc4ad96`
  before configuration and activation.
- Existing Repeal components remain enabled and untouched: Brand Header id `7`,
  Dropdown Header id `8`, and Custom Header Links (icons) id `3`.
- A versioned import/export utility now exists at
  `scripts/brand-navigation-config.mjs`. It validates bundles, exports portable
  Brand Navigation settings, preflights a target component, and applies all
  bundled settings in one Discourse admin API request. It cannot attach or
  enable a component.
- `configurations/repeal-obbba.json` contains the inventoried Repeal migration
  as the first real bundle and large-menu test fixture.
- The configuration-bundle work, documentation, expanded thanks, and tests are
  committed in `6def463`; checkpoint commit `c51a7f6` is also pushed. The
  sandbox accepted the updated remote component and its normal runtime render
  remains clean. The API import/export round trip has not run because no
  `DISCOURSE_API_KEY` or `DISCOURSE_API_USERNAME` is available to this task.
- `c1cc27b` adds the supported admin-page bundle controls and polished submenu
  closure behavior. Local lint, types, templates, styles, formatting, bundle
  validation, and four Node tests pass. This commit has not yet been loaded or
  exercised on the sandbox.

## Existing Repeal configuration known so far

- Brand Header: name `Repeal OBBBA`, URL `https://www.repealobbba.org/`, outlet
  `below-site-header`, and top-level links Pledge, Repeal, and Stories.
- Known Pledge URL: `/c/repealobbbapledge-us/10`.
- Known Repeal URL: `/c/repealobbbaact-us/15`.
- Known Stories URL: `/c/stories/7`.
- Dropdown Header top-level groups: Repeal, Pledge, Stories, People, Social.
- Social destinations already observed: Bluesky, Discord, Facebook, GitHub,
  Instagram, Mastodon, Reddit, TikTok, X, and YouTube.
- Dropdown Header and Custom Header Links values have now been inventoried and
  encoded in `configurations/repeal-obbba.json`, including all ten social URLs,
  brand icons, `_blank` behavior, the Repeal/Pledge children, Stories, and the
  three current `People` placeholder links.

## Verification evidence

Executed successfully on Windows for `c1cc27b`:

- `pnpm lint` (JavaScript, templates, CSS, formatting, and type checks): pass.
- `pnpm bundle validate configurations/repeal-obbba.json`: pass.
- `pnpm test:config`: pass (4 tests).
- `git diff --check`: pass.

Previously executed successfully:

- Node smoke coverage for right-section and icon presentation: pass.
- Sandbox desktop runtime render and translated accessibility landmark at
  `c51a7f6`: pass.

Authored but not executed in a compatible local Discourse test runtime:

- `test/unit/lib/brand-navigation-test.js`
- `spec/system/brand_navigation_spec.rb`
- `spec/system/core_features_spec.rb`

Do not describe those specs as passing. Ruby, Gem, and Bundler were not
discoverable on the Windows PowerShell PATH. Ubuntu WSL startup probes timed
out, so WSL Ruby availability remains unverified.

## Exact next actions

1. Push `c1cc27b` and this refreshed checkpoint, then update the sandbox through
   Discourse's normal component updater.
2. Browser-test submenu closure and the administrator import/export controls on
   the sandbox; no API key is needed for the UI workflow.
3. Update Repeal component `19` to the verified commit after action-time
   confirmation.
4. Apply `configurations/repeal-obbba.json` while component `19` remains
   unattached.
5. Obtain action-time confirmation before attaching it to live Repeal themes.
6. Verify desktop/mobile, anonymous/authenticated visibility, keyboard use,
   external-link safety, and coexistence with the existing components.
7. Keep all predecessors available for rollback; disable them only if Phil
   explicitly chooses the cutover.

## Out of scope

- CMS behavior or general page building.
- Arbitrary deep navigation nesting.
- Authentication replacement.
- Changes to core Discourse embedding.
- DiscussionBridge compatibility code.
- Hostname, CSS, or DOM-selector embed workarounds.
- Literal Discourse-core integration as an initial requirement.
- Official-status claims, repository transfer, or public release without a
  separate decision.
