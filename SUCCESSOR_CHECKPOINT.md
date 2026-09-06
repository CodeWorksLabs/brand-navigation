# Brand Navigation successor checkpoint

Date: 2026-09-05  
Disposition: **REPEAL PEOPLE NAV LIVE / STAY-OPEN ADMIN SAVE VERIFIED / NOT RELEASE-READY**

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
- Last sandbox-tested runtime commit: `4a65821`.
- Latest implementation commit: `12e764a`; administrator-label follow-up:
  `310f743`.
- Latest Repeal configuration commit: `a1b274d`.

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
- Per-item `both`, `desktop`, and `mobile` device visibility for top-level and
  child entries, evaluated against Discourse's supported physical-device
  capability.
- Sandbox update to `12e764a` passed on Discourse `2026.9.0-latest+307`: the
  new device field was accepted by the objects schema, existing blank values
  retained `both` behavior, authenticated navigation continued rendering, and
  no administrator component warning appeared. The initial live schema check
  exposed a raw `device_visibility` label; the follow-up locale metadata gives
  top-level and child controls the administrator-facing label “Device
  visibility” and explains the backward-compatible blank behavior.
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
- Saving Brand Navigation's navigation-object editor remains on the editor page
  so administrators can continue working instead of being returned to the main
  component settings screen.

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
- Repeal Brand Navigation component id `19` is updated to `310f743`, attached
  to Default, Foundation, and Horizon, populated with the reviewed Repeal
  migration, and enabled. It is visible on the live forum. Phil moved its
  runtime outlet to `above-site-header`, which he considers the likely common
  placement; this is a site setting choice and has not changed the component's
  packaged default.
- Existing Repeal Brand Header id `7` and Dropdown Header id `8` remain enabled
  and untouched. Custom Header Links (icons) id `3` is still installed with its
  settings intact but was disabled after Brand Navigation's replacement icons
  were verified in the core header.
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
  to the bar. Repeal's ten standalone social links now use `site_header`; its
  Social parent and submenu remain in the Brand Navigation bar.
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
- Compatibility documentation now records exact administrator-dashboard
  builds rather than implying an unverified minimum version. Repeal is on
  `2026.7.0-latest+319` at core commit `988c31e00f`; the DiscussionBridge
  sandbox is on `2026.9.0-latest+307` at core commit `b8565672b9`. On
  2026-09-05 Brand Navigation rendered on authenticated normal pages and its
  administrator surface loaded on both builds. Repeal carries the broader
  live interaction coverage enumerated below.
- Repeal exposed two migration-data issues before cutover. The original three
  People entries used no-op `#` destinations and were correctly rejected by the
  validated object schema. Working destinations were later identified and are
  now included in both the live component and the local Repeal bundle. The
  administrator importer converts icon arrays to Discourse's pipe-delimited
  list storage. `50d614b` introduced both migration corrections and placeholder
  URL rejection.

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
  brand icons, `_blank` behavior, the Repeal/Pledge children, and Stories.
- People now links to `/c/people/19`, with working children for Voted for OBBBA
  (`/t/voted-for-the-one-big-beautiful-bill-act/1146`), Voted Against OBBBA
  (`/t/voted-against-the-one-big-beautiful-bill-act/1147`), and Supports Repeal
  OBBBA Act (`/t/repeal-obbba-act-supporters/1148`).
- Phil added visible descriptions directly in Repeal before the People change.
  The live current-state editor was used to add People, preserving those edits.
  Their exact live text is not yet mirrored in the local configuration bundle;
  export the current live settings before using that bundle as a replacement.

## Verification evidence

Executed successfully on Windows for `c02bf5a`:

- `pnpm lint` (JavaScript, templates, CSS, formatting, and type checks): pass.
- `pnpm bundle validate configurations/repeal-obbba.json`: pass.
- `pnpm test:config`: pass (6 tests).
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
- Repeal `site_header` icon placement at `3cd8910`: pass. Before predecessor
  disablement, both ten-icon sets rendered, proving Brand Navigation's set was
  present. After disabling Custom Header Links (icons) id `3`, a fresh page
  showed exactly one set of ten social icons in the core header and none in the
  upper Brand Navigation bar. My Preferences remained in the upper bar.
- Sandbox administrator save behavior at `4a65821`: pass. Clicking Save Changes
  on `/admin/customize/themes/1/schema/navigation_items` persisted through the
  supported setting model while the URL, editor, and Save Changes control
  remained in place.
- Repeal administrator save behavior at `4a65821`: pass on component id `19`.
  The URL remained `/admin/customize/themes/19/schema/navigation_items`, and the
  editor and Save Changes control remained present after saving.
- Repeal People navigation at `4a65821`: pass. The parent link and separate
  submenu caret render in Brand Navigation; opening the submenu exposes all
  three intended labels and exact working topic destinations listed above.
- The stay-open behavior uses Discourse's documented `api.modifyClass` against
  the core schema-setting editor because that save action currently exposes no
  narrower supported outlet or transformer. The override is restricted to the
  `navigation_items`/`navigation_item` setting and delegates every other schema
  editor to core behavior. Core admin-editor changes remain a maintenance risk.
- `pnpm lint`, `pnpm test:config` (6 tests), Repeal bundle validation, and
  `git diff --check` at `4a65821`: pass.
- Repeal visible-description presentation at `c02bf5a`: pass by live browser
  inspection. Menus containing descriptions selectively widen to 21rem (within
  the viewport), use stronger child labels, readable subordinate text, and
  clearer spacing between choices. Menus without descriptions retain their
  compact width. Phil's existing live description text was unchanged.
- Per-item device visibility at `310f743`: pass on the sandbox. The new
  administrator label and help text render; changing Community to `mobile`
  removed it from the authenticated desktop navigation after reload, and
  restoring `both` brought it back. The sandbox configuration was restored.
- Repeal update to `310f743`: pass. The Device visibility control renders in
  the existing objects editor, all ten existing site-header social icons remain
  visible under their backward-compatible blank/`both` behavior, and no Brand
  Navigation administrator warning appeared. No Repeal item has yet been
  changed to desktop-only or mobile-only.
- Phil's iPhone test found that portrait filtering worked but Desktop-only
  icons returned in landscape. This was caused by the first implementation
  using `site.mobileView`, which Discourse defines from its 40rem responsive
  breakpoint. It was a semantic implementation defect, not ignored settings.
  Per-item filtering now uses supported `capabilities.isMobileDevice`, which
  remains a mobile phone classification across rotation; `mobile_mode` retains
  its separate responsive-layout meaning.
- Repeal was updated to `61db961` with no component warning. Phil then verified
  on a physical iPhone that the configured priority icons render correctly in
  portrait and landscape while Desktop-only icons remain excluded. The
  rotation/device-visibility defect is accepted as fixed.

Authored but not executed in a compatible local Discourse test runtime:

- `test/unit/lib/brand-navigation-test.js`
- `spec/system/brand_navigation_spec.rb`
- `spec/system/core_features_spec.rb`

Do not describe those specs as passing. Ruby, Gem, and Bundler were not
discoverable on the Windows PowerShell PATH. Ubuntu WSL startup probes timed
out, so WSL Ruby availability remains unverified.

## Exact next actions

1. Verify the new per-item device visibility on the sandbox and Repeal mobile
   layouts, then choose which priority Repeal social icons remain on `both` and
   mark the rest `desktop`.
2. Record `https://www.r744.community/` on Discourse `2026.2.0-latest` as the
   planned older-version compatibility target; do not list it as known working
   until installation and the acceptance checks actually pass.
3. Export Repeal's current live Brand Navigation settings so Phil's manually
   added visible descriptions are captured in a portable bundle, then validate
   it before considering replacement of the repository sample.
4. Verify Repeal mobile and anonymous behavior, embed exclusion, and external
   link safety; authenticated desktop coexistence and submenu behavior pass.
5. Keep all predecessors available for rollback; disable them only if Phil
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
