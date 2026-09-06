# Brand Navigation successor checkpoint

Date: 2026-09-05  
Disposition: **REPEAL MIGRATION LIVE / FOUR-COMPONENT COEXISTENCE VERIFIED / ADMIN IMPORT/EXPORT VERIFIED / NOT RELEASE-READY**

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
- Last sandbox-tested runtime commit: `c15353ec044d2da2698c3b00fa05f2d7845ceae5`.
- Latest implementation commit: `3cd8910`.

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
- Bundle imports accept either a selected `.json` file or pasted JSON, allowing
  validation and import without browser file-picker automation.

## Current repository and runtime state

- `6bb45ec` fixed strict-mode GJS translation imports. It cleared the sandbox's
  administrator warning and produced no new Brand Navigation client error.
- `160a967` added practical sample defaults.
- `bc4ad96` added left/right sections, icon presentation, and correctly scoped
  theme translations. It is committed and pushed.
- Sandbox theme component id `1` is installed on Foundation and Horizon,
  enabled, configured at `below-site-header`, and runtime-tested at `c15353e`.
- Sandbox runtime verification after a fresh forum navigation passed: the
  component rendered, the landmark resolved to “Brand navigation,” the main
  links remained left, and authenticated “My Preferences” rendered at the
  right edge. No component warning was present.
- Repeal Brand Navigation component id `19` is updated to `3cd8910`, attached
  to Default, Foundation, and Horizon, populated with the reviewed Repeal
  migration, and enabled. It is visible on the live forum. Phil moved its
  runtime outlet to `above-site-header`, which he considers the likely common
  placement; this is a site setting choice and has not changed the component's
  packaged default.
- Existing Repeal components remain enabled and untouched: Brand Header id `7`,
  Dropdown Header id `8`, and Custom Header Links (icons) id `3`.
- Brand Navigation and all three existing header components render together
  without an observed conflict or administrator warning. Phil reviewed the
  combined live result and reported that all four play well together.
- Top-level URL and submenu behavior are independent. URL plus children renders
  a functioning parent label link beside a separate caret control; children
  without a URL retain the complete submenu trigger; URL without children is a
  direct link. A row with neither URL nor children has no actionable output.
- Linked parent labels and their separate caret controls share one continuous
  hover/focus highlight while retaining distinct link and submenu actions.
- Child entries have separate optional tooltip and visible-description fields.
  Empty descriptions retain compact menus.
- Direct top-level icon links can select the `site_header` surface to render
  once among Discourse's core header icons instead of in the Brand Navigation
  bar. This uses the supported `api.headerIcons` API. Existing entries default
  to the bar, and no Repeal item has been moved to the site header yet.
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
  validation, and four Node tests pass. Sandbox theme component `1` was updated
  through Discourse's normal updater to checkpoint head `7baecce`; the
  Configuration Bundles controls render, outside-click closure passes, and
  Escape closure restores focus to the Resources summary. File selection and
  settings application had not yet been exercised through the browser UI.
- `c15353e` adds pasted-JSON import. On the sandbox, a partial bundle changed
  `brand_name` to `Brand Navigation Import Test`; a full page reload confirmed
  persistence. A second bundle restored `Brand Navigation`, and another reload
  confirmed that the temporary value was gone. Theme attachments and the
  component's enabled state were unchanged. The Export settings control opened
  Chrome's save-location prompt at Documents, confirming download delivery and
  respect for the browser's ask-where-to-save preference.
- Repeal runs Discourse `2026.7.0-latest +319`. Its admin model shape required
  relaxing an unnecessary settings-array check in `6b782ff`; the supported
  `admin-customize-theme-before-controls` outlet and `ThemeSettings#updateSetting`
  API are present in that exact Discourse revision.
- Repeal exposed two migration-data issues before cutover. The three People
  entries used no-op `#` destinations and were rejected by the validated object
  schema, so they are omitted until real destinations exist. The administrator
  importer now converts icon arrays to Discourse's pipe-delimited list storage.
  `50d614b` includes both corrections and rejects placeholder submenu URLs.

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
  brand icons, `_blank` behavior, the Repeal/Pledge children, and Stories. The
  three current `People` placeholder links are documented but intentionally
  omitted because they have no working destinations.

## Verification evidence

Executed successfully on Windows for `50d614b`:

- `pnpm lint` (JavaScript, templates, CSS, formatting, and type checks): pass.
- `pnpm bundle validate configurations/repeal-obbba.json`: pass.
- `pnpm test:config`: pass (5 tests).
- `git diff --check`: pass.

Previously executed successfully:

- Node smoke coverage for right-section and icon presentation: pass.
- Sandbox desktop runtime render and translated accessibility landmark at
  `7baecce`: pass.
- Sandbox Resources outside-click closure: pass.
- Sandbox Resources Escape closure and summary focus restoration: pass.
- Sandbox administrator Configuration Bundles controls render: pass.
- Sandbox pasted-JSON validation enables Import settings: pass.
- Sandbox reversible import, reload, restore, and reload: pass.
- Export bundle construction and serialization Node coverage: pass.
- Browser download delivery from Export settings: pass; Chrome displayed its
  configured save-location prompt.
- Repeal component update, attachment save, and hidden-state save: pass.
- Repeal scalar settings import and reload persistence: pass.
- Repeal navigation object import without invalid People placeholders: pass;
  the editor shows Repeal, Pledge, Stories, Social, ten right-side social links,
  Sign Up, and My Preferences.
- Repeal custom icon-list persistence: pass; all twelve icons render as separate
  administrator list entries after reload.
- Repeal authenticated desktop render at `fc2ced6`: pass; the brand, four
  migrated navigation entries, ten right-side social links, and My Preferences
  render while all three predecessor components remain enabled.
- Repeal submenu interaction at `fc2ced6`: pass on a fresh page; a submenu opens
  normally and closes after an outside click on the core All categories heading.
  The document click handler uses capture phase so stopped bubbling in other
  Discourse components does not prevent closure.
- Repeal linked-parent behavior at `fc2ced6`: pass. Repeal links to
  `/c/repealobbbaact-us/15`, Pledge to `/c/repealobbbapledge-us/10`, and Social
  to `/c/social/16`; their separate submenu controls open correctly and retain
  outside-click closure. During manual administration, those paths were briefly
  entered into the label fields due to field-index selection, then corrected
  before final verification. This was an operator interaction incident, not a
  component data-model or rendering behavior.
- Repeal caret presentation at `53a6871`: pass by live screenshot. Discourse's
  global `summary::before` disclosure triangle is suppressed within Brand
  Navigation, leaving only the component's small downward caret.
- Repeal linked-submenu alignment at `ce91a6f`: pass by live screenshot in the
  `above-site-header` outlet. The opened Repeal child menu begins under its
  parent label rather than under the separate caret or between adjacent
  top-level items.
- Repeal linked-parent caret spacing at `00cf3ce`: pass by live screenshot. The
  separate accessible submenu control is now visually adjacent to its parent
  label while the child menu retains the corrected alignment.
- Repeal combined parent/caret highlight at `3cd8910`: pass by live screenshot.
  Activating the separate caret highlights the complete linked group and the
  child menu remains aligned beneath the parent label.
- Repeal administrator schema at `3cd8910`: pass. The top-level `Surface`
  control and separate child `Tooltip` and `Visible description` fields render
  in the supported objects editor.
- `pnpm lint`, `pnpm test:config` (6 tests), bundle validation, and
  `git diff --check` at `3cd8910`: pass.
- A configured `site_header` item has not yet been exercised in a live runtime;
  selecting which Repeal items move is an administrator content decision.

Authored but not executed in a compatible local Discourse test runtime:

- `test/unit/lib/brand-navigation-test.js`
- `spec/system/brand_navigation_spec.rb`
- `spec/system/core_features_spec.rb`

Do not describe those specs as passing. Ruby, Gem, and Bundler were not
discoverable on the Windows PowerShell PATH. Ubuntu WSL startup probes timed
out, so WSL Ruby availability remains unverified.

## Exact next actions

1. Decide which, if any, Repeal direct icon items should move from the bar to
   the `site_header` surface and which submenu children should receive visible
   descriptions; no content placement was changed automatically.
2. Verify Repeal mobile and anonymous behavior, embed exclusion, and external
   link safety; authenticated desktop coexistence and submenu behavior pass.
3. Map the three People items only after replacing their no-op `#` values with
   confirmed working destinations.
4. Keep all predecessors available for rollback; disable them only if Phil
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
