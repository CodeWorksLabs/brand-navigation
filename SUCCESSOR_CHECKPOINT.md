# Brand Navigation successor checkpoint

Date: 2026-09-05 (refreshed through 2026-09-06 UTC)
Disposition: **IMPLEMENTATION ON MAIN / SANDBOX AND REPEAL VISUALLY VERIFIED / RELEASE DOCUMENTATION IN PROGRESS / NOT RELEASED**

## Current release-documentation checkpoint

- Current working branch: `codex/release-docs`, created cleanly from
  `origin/main` at `b0b5354481c30e1db1daf4db682368a6f9c9994d`.
- Pull request 5 merged the color-normalization candidate into `main`; the
  DiscussionBridge sandbox was updated through the normal Discourse UI and
  reported itself current with `main`. Administrator checks confirmed that
  colors with and without a leading `#` render correctly and that the
  Appearance panel can return all five values to inherited palette behavior.
- Obsolete draft pull request 2 was closed with an explanatory comment on
  2026-09-06. It targeted the retired R744 `2026.2` compatibility experiment,
  conflicted with current `main`, and was not merged. Its source branch remains
  available so history has not been discarded.
- Repeal OBBBA currently reports Discourse `2026.7.0-latest` at
  `988c31e00fb73713c81b93cd47f68af0fb4c6273`. Its enabled Brand Navigation
  component id 19 is attached to theme ids `1`, `-1`, and `-2`. It was updated
  to `b0b5354` and Phil confirmed the resulting brand-color presentation looked
  great. The current compatibility evidence records both that exact Discourse
  build and component revision.
- Current release-documentation work expands the README feature summary,
  documents the English-first translation posture, adds administrator
  translation guidance, strengthens the release translation/attribution gate,
  and creates `docs/ATTRIBUTION.md` with a permanent reference to the precise
  GPL `curryComponent` pattern adapted from Custom Header Links (icons).
- Focused Prettier checks and `git diff --check` pass for the changed docs. All
  22 Node configuration-bundle tests pass. JavaScript, template, CSS, and type
  lanes pass in the aggregate lint command; the aggregate Prettier lane still
  reports pre-existing Windows checkout drift in unrelated files, so only the
  changed documentation was formatted.
- The resumed task still has no callable authenticated browser-control runtime.
  Visual UI evidence must be gathered with Phil in the authenticated browser;
  existing Pageant/SSH access may be used only when a read-only server check is
  necessary.
- The controlling nine-step release sequence is recorded under **Exact next
  actions** below. The current position is Step 1: finish release preparation
  and manual documentation/product polish.
- Public presentation will use `codeworkslabs.dev` as the product-lab front
  door, platform discovery hostnames such as `discourse.codeworkslabs.dev`, and
  shared canonical documentation at `docs.codeworkslabs.dev`. The durable
  umbrella support entry is `support.codeworkslabs.dev`; independent product
  communities such as `forum.discussionbridge.dev` remain independent. Exact
  source repositories, paths, deployment ownership, and timing remain
  unsettled. No site creation or publication is authorized.

## Purpose and authority

Brand Navigation is an independently maintained Discourse theme component for
an optional brand header and one-level navigation hierarchy. It is not an
official Discourse product.

Phil authorized browser-based installation, configuration, and testing on the
DiscussionBridge sandbox, Repeal OBBBA Forum, DiscussionBridge Forum, The
Bridge, Citizen Activist Network, and RVing Community. Browser administration
is available through Phil's authenticated Chrome tabs. SSH is unnecessary and
should be reserved for cases the supported UI cannot handle. Do not delete or
disable the other installed header components without Phil's explicit
direction.

## Canonical locations

- Local repository: `C:\CodeProjects\Products\Discourse Brand Navigation`
- Git remote: `https://github.com/CodeWorksLabs/brand-navigation.git`
- Current branch: `codex/release-docs`.
- Merged color-control head: `4d520d2`.
- Current merged head: `b0b5354`.
- Top-level behavior implementation commit: `e53a7d0`; evidence commit:
  `2cb2b2a`; merged pull request:
  `https://github.com/CodeWorksLabs/brand-navigation/pull/3`.
- Previous compatibility branch: `codex/r744-compatibility`
- Closed obsolete compatibility pull request:
  `https://github.com/CodeWorksLabs/brand-navigation/pull/2`
- Compatibility commits: `1c99057`, `ae92961`, and `ab82591`.
- Merged pull request: `https://github.com/CodeWorksLabs/brand-navigation/pull/1`
- Current CI/browser-tested merged head: `b0b5354` (the checkpoint itself may
  create a later documentation-only head).
- Frozen reviewed commit: `2b699c3c173ac3c3d5ef223ec3c45cb6c7770bb7`;
  tree `0e895ab0a208a2fa0db895f4c48192a9fd22adca`.
- Historical runtime evidence below identifies its own commit. It is not a
  claim that those earlier commits are current.

The older path `C:\CodeProjects\CodeWorksLabs\Discourse` no longer exists and
must not be used as this repository's working directory.

## Administrator color-control checkpoint

- Candidate `ce7fb34` adds five independently optional appearance settings:
  bar background, bar text/icons, hover/highlight background, submenu
  background, and submenu text/icons.
- Brand Navigation's existing administrator panel exposes native browser color
  inputs with a per-color **Custom** switch, **Save colors**, and **Inherit
  all**. Blank settings continue using Discourse's `--tertiary`, `--secondary`,
  `--quaternary-low`, and `--primary` palette variables, preserving active
  light/dark color-scheme behavior.
- The five settings are portable in configuration bundles. Bundle validation
  accepts only blank inheritance or six-digit hex colors.
- The administrator guide, README, changelog, setting descriptions, and panel
  labels are updated.
- Local JavaScript lint, Ember template lint, Stylelint, type checking,
  changed-file formatting, `git diff --check`, and all 21 Node configuration
  tests pass.
- Official Discourse workflow run `34051003085` passed linting, backend,
  frontend QUnit, and browser-backed system tests on candidate `1fee5e8`.
  Configuration workflow run `34051002649` passed all 21 Node tests.
- Administrator/browser interaction on the sandbox remains pending because
  this resumed task currently exposes no callable authenticated-browser
  control despite the browser session being open. No production forum has
  been changed.
- The first official workflow passed configuration tests and the complete
  linting lane, then the backend lane rejected one administrator description
  for Discourse's banned phrase `color scheme`; the wording is corrected to
  `color palette` in the follow-up candidate. This was a locale-policy finding,
  not a code-build failure.

## Color-value normalization follow-up

- Sandbox testing found that Discourse's underlying string setting accepts
  both `16324F` and `#FFFFFF`; the database retained those exact forms.
- Branch `codex/normalize-color-values` makes rendering accept either six-digit
  form, normalizes appearance-panel and configuration-bundle values to
  uppercase `#RRGGBB`, and documents the accepted input.
- Local ESLint, Ember template lint, Stylelint, type checking, changed-file
  formatting, `git diff --check`, and all 22 Node configuration tests pass.
- Official CI, merge, and sandbox update verification remain pending. The
  sandbox currently has `bar_background_color=16324F` and
  `bar_text_color=#FFFFFF`; no production forum was changed.

## Current multi-site checkpoint

- Main is installed, configured, and browser-smoke-tested on Repeal OBBBA
  Forum, DiscussionBridge Forum, The Bridge, Citizen Activist Network, and
  RVing Community. The DiscussionBridge sandbox remains the primary current
  Discourse test environment.
- DiscussionBridge Forum and The Bridge now each expose GitHub, Bluesky,
  Discord, and YouTube as right-side `site_header` icon links. Each uses an
  accessible tooltip, opens with `_blank`, and was inspected with
  `rel="noopener noreferrer"`. Both sites showed no broken-theme warning.
- The Bridge retained its Publishing, From The Bridge, Releases, Ecosystem, and
  My Preferences navigation. Its full-app `?embed_mode=true` check returned no
  Brand Navigation bar and no component social links while `#main-outlet`
  remained present. The normal forum URL was restored afterward.
- DiscussionBridge Forum has the same restrained four-icon social set and
  passed normal rendering and full-app embed exclusion. These are site settings
  only; no repository code changed to add them.
- Citizen Activist Network has configured Community and Issues navigation and
  passed normal authenticated rendering, submenu/Escape behavior, no-console-
  error inspection, and full-app embed exclusion.
- RVing Community has configured Community and RVing Network navigation, is
  attached to Default, Foundation, and Horizon, and passed normal authenticated
  rendering, link/submenu inspection, no-console-error inspection, and full-app
  embed exclusion.
- The original R744 `2026.2.0-latest` attempt exposed unsupported older module
  APIs; that unsupported build remains explicitly outside the compatibility
  claim. R744 was subsequently upgraded to the 2026.7 ESR and is now a verified
  installation as recorded below. Draft pull request 2 is obsolete for the
  R744 site and should be closed rather than merged.

## R744 2026.7 ESR checkpoint

- Phil explicitly authorized the live R744 upgrade and Brand Navigation test.
- A fresh pre-upgrade Discourse backup was confirmed at
  `/var/discourse/shared/web-only/backups/default/r744-community-2026-09-05-033639-v20260126204830.tar.gz`.
- `/var/discourse/containers/web_only.yml` was backed up as
  `web_only.yml.pre-2026.7-esr-20260905`, then pinned to
  `version: release/2026.7`. The launcher repository was fast-forwarded and
  `./launcher rebuild web_only` completed successfully.
- The administrator dashboard reports Discourse `2026.7.2+14` at core commit
  `2e46cff73b`. The configured source remains `release/2026.7`; a newer regular
  release being advertised by the dashboard does not change that ESR pin.
- Brand Navigation component id `1`, sourced from `main`, is enabled and
  attached to Foundation and Horizon. Component id `2` remains preserved,
  disabled, and unattached.
- Authenticated normal-page smoke passed: one Brand Navigation surface, core
  main content present, no broken-theme warning, and no captured console error.
- Resources opened, Escape closed it and restored focus, and the external Meta
  link retained `target="_blank"` with `rel="noopener noreferrer"`.
- Full-app `?embed_mode=true` excluded Brand Navigation while retaining
  `#main-outlet` and produced no broken-theme warning.
- The component administrator page and `navigation_items` object editor loaded
  normally on the ESR. The editor retained its in-place `Save Changes` control;
  no setting mutation was required for this verification.
- The launcher printed container environment values during rebuild. Secret
  values are intentionally omitted from this checkpoint. SMTP, database, and
  MaxMind credentials visible in the task record should be rotated separately;
  no rotation was performed without Phil's direction.

## Top-level Link / Submenu group checkpoint

- Commit `e53a7d0` implements the per-item `link_mode`, with `link` preserving
  the current linked-parent behavior and `group` suppressing the rendered URL
  while retaining the saved value for later reuse.
- Group mode is limited to bar items with actionable children. It is rejected
  for core-header items and for items without children. Link mode requires a
  URL. Configuration bundle import/export accepts and validates the field.
- Local ESLint, Ember template lint, Stylelint, type checking, changed-file
  Prettier, `git diff --check`, and all 19 Node configuration tests passed. The
  repository-wide Windows Prettier command still reports CRLF conversion on 19
  unchanged files; no unrelated formatting rewrite was made.
- Pull request 3 merged as `317c4be`, and all checks are green. Official Discourse workflow
  run `34019282463` passed linting, frontend QUnit, backend, and Ruby system
  tests; configuration workflow run `34019282181` passed all 19 Node tests.
- Sandbox component id `2` tracked `codex/top-level-link-behavior` for candidate
  testing. After a
  required application reload following the source switch, the administrator
  editor displayed **Top-level behavior** and saved normally without leaving
  the editor.
- Resources passed the complete live round trip: `group` rendered the label as
  a submenu-only button and exposed both children; changing it back to `link`
  restored `/about` as the live parent destination plus the separate caret.
  The saved URL survived group mode. The sandbox was left in Link mode.
- Attempting group mode on Community without actionable children failed closed
  with the expected validation error and did not change the setting.
- Full-app `?embed_mode=true` still produced zero Brand Navigation surfaces,
  one `#main-outlet`, no broken-theme warning, and no captured console errors.
- After merge, sandbox component id `2` was switched back to `main` and reported
  up to date. The final smoke test reconfirmed Resources as the `/about` parent
  link with its separate submenu caret, submenu open and Escape focus return,
  the Meta child link's `_blank`/`noopener noreferrer` safety, one normal-page
  Brand Navigation surface, one core `#main-outlet`, no broken-theme warning,
  and no captured console errors. Full-app `?embed_mode=true` again returned
  zero Brand Navigation surfaces while preserving `#main-outlet`. The browser
  was restored to the normal sandbox forum page.
- Phil then clarified that the sandbox Resources item should demonstrate the
  new submenu-only behavior rather than retain its historical link behavior.
  Resources is now saved as `group`: the normal page exposes it as a submenu
  button, not an `/about` parent link, while its About and Discourse Meta child
  destinations remain available. This is the current sandbox configuration.

## Post-merge sandbox checkpoint

- Pull request 1 was marked ready and merged into `main` as `e22dce2`; merging
  did not create a tag, GitHub Release, or deployment.
- Sandbox component id `2` was changed from
  `codex/v0.9.0-verification` to `main`. Discourse reported it up to date with
  `main`, whose remote head was independently confirmed as `e22dce2`.
- Authenticated normal-page smoke testing passed after the source change: one
  Brand Navigation landmark rendered with Community, Resources, My Preferences,
  and the configured site-header link while core main content remained.
- Resources opened normally; its Discourse Meta `_blank` link retained
  `noopener noreferrer`; Escape closed the submenu and restored focus.
- The same structured configuration bundle was re-imported through the
  administrator UI. Import succeeded, and a forum reload confirmed the brand
  navigation and site-header item persisted.
- Full-app `?embed_mode=true` smoke testing again found no bar, Brand Navigation
  landmark, compact menu, or component site-header icon while core main content
  remained. The browser was restored to the normal forum page afterward.
- This post-merge smoke test changed only the authorized sandbox. Repeal and all
  other production/consumer sites were untouched.

## Current verification gate (supersedes older pending statements below)

- The reviewed candidate was committed to the short-lived verification branch
  and pushed without changing `main`. No tag or GitHub Release was created.
- GitHub Actions run `34010799758` passed every lane at `13005b7`:
  `check_for_tests`, linting (including Ruby, JavaScript, templates, styles,
  formatting, and types), backend/English-locale validation, frontend QUnit,
  and Ruby system tests. Configuration workflow run `34010799448` also passed.
- The first CI run exposed only harness/package compatibility findings: a
  missing standard development `Gemfile`, two English-locale uses of “color
  scheme,” and application-style rather than relative theme-test imports.
  Commit `13005b7` corrected all three, and the complete official workflow
  subsequently passed.
- Browser import initially proved that scalar settings persisted but object
  settings did not. Current Discourse expects object-setting values serialized
  for the theme update endpoint. Commit `1789301` aligned the browser importer
  with that endpoint while retaining the parsed array in the local admin model;
  the structured sandbox bundle then imported successfully.
- Sandbox component id `2` tracks `codex/v0.9.0-verification`, is enabled and
  attached to Foundation and Horizon, and is updated through `13005b7`.
  Component id `1` is preserved, disabled, and detached as rollback material;
  it was not deleted. This sandbox-only change prevents duplicate administrator
  connectors while the candidate is evaluated.
- Sandbox browser passes on the candidate: authenticated desktop render;
  linked parent plus separate submenu control; outside-click and Escape closure
  with focus restoration; safe `_blank` rel; 390px mobile menu, bar, and hidden
  modes; unclipped bar submenu; site-header icon placement and safe rel; full-app
  `embed_mode=true` exclusion while main content remains; structured bundle
  import; unsafe-URL rejection before mutation; corrected locale; and
  save-without-leaving behavior in the navigation-object editor.
- The sandbox was restored to mobile `bar` mode after the reversible hidden-mode
  check. No Repeal or other production installation was changed in this gate.
- Remaining evidence gaps are explicit: classic embedded comments could not
  render because the sandbox has no embed hosts configured; anonymous browser
  visibility was not re-executed without disrupting Phil's authenticated admin
  session; export construction is covered by automated tests, but the current
  browser download could not be conclusively observed because Chrome's
  save-location UI remained outside the automation result; light/dark, RTL,
  screen-reader, and older-version consumer checks remain manual targets.
- Windows still has no discoverable `ruby`, `gem`, or `bundle` commands on this
  task's PowerShell PATH. Ubuntu WSL startup again timed out and was interrupted,
  so its Ruby state remains unverified. This is no longer a coverage blocker for
  the candidate because the official GitHub workflow executed and passed the
  authored QUnit and Ruby system suites.
- Final focused static review of commits `97807a1`, `1789301`, and `13005b7`
  returned `INTERNAL CODE REVIEW PASS WITH P2/P3 FINDINGS`, found no P0/P1
  defect, and confirmed that browser object serialization and the parsed local
  model state are coherent. It raised two P2 findings: overstatement of
  server-side atomicity and floating Ruby lint tools.
- The first closure commit pinned the two Ruby lint tools to the exact versions
  resolved by the passing workflow and corrected the test matrix, but its first
  static closure check found one residual architecture statement plus a P3
  checkpoint-sequencing issue. The present narrow correction describes bundle
  integrity only as complete client preflight plus one update request, without
  claiming an unproven server transaction, and makes a fresh official workflow
  on the exact closure head an explicit pre-merge action.

## 2026-09-05 doctrine review and remediation

- Complete Static Review `BN-CODEBASE-20260905` used the approved Code Review
  Doctrine at `C:\CodeProjects\Governance\Boss\CODE_REVIEW_DOCTRINE.md`,
  52,273 bytes, SHA-256
  `5610F2AB5B2E9DC2CD649E2E11321DEC6B5F1BACD174A1C32BABD49174888C5D`.
- The independent reviewer inspected all 39 tracked members. Opening and
  closing identity remained clean at the exact commit and tree above.
- Disposition: `INTERNAL CODE REVIEW BLOCK`; P0 none, P1 seven, P2 six, P3 one.
  The grouped findings cover mobile hidden/bar behavior, bundle validation and
  atomicity, administrator component identity, CLI credential transport,
  runtime evidence, direct-setting hardening, Escape ownership, accessible
  descriptions/status, CLI bounds, lifecycle records, and export overwrite.
- Phil accepted the review quality and authorized one local remediation batch
  plus Semantic Versioning records. No commit, push, tag, GitHub Release, live
  forum change, installation, deployment, or publication is part of the active
  batch.
- The local remediation now implements the complete grouped response: mobile
  hidden mode suppresses registered header icons; mobile bar navigation wraps
  without the clipping scrollport; bundle and navigation validation is
  fail-closed; browser import uses one preflighted theme update; administrator
  extensions use an exact remote/schema identity; CLI API access requires a
  canonical HTTPS origin with redirects, time, response size, and terminal text
  bounded; export overwrite is explicit; Escape ownership is scoped; visible
  descriptions and bundle status have explicit accessibility relationships;
  lifecycle/default records are reconciled; and CI/versioning records exist.
- Local post-remediation evidence: `pnpm lint` passes all JavaScript, template,
  CSS, formatting, and type gates; `pnpm test:config` passes 15/15; the Repeal
  migration bundle validates; and `git diff --check` passes. QUnit and Ruby
  system specs, including the newly authored mobile hidden/bar cases, remain
  authored but unexecuted pending a compatible Discourse runtime gate.
- The separate Review Reviewer Doctrine audit is not commissioned and creates
  no current gate.
- Version policy: Git tags and matching GitHub Releases use Semantic Versioning;
  Discourse continues commit-based remote updates. The first planned reviewed
  preview is `v0.9.0`; `v1.0.0` is reserved for documented multi-site readiness.
- Focused correction review `BN-CORRECTION-CLOSURE-20260905` confirmed no P0,
  but blocked the first correction batch on two P1 assurance regressions and
  six P2/P3 hardening or record findings. The follow-up local batch makes QUnit
  fixtures actionable, enables system specs explicitly with non-vacuous
  negative baselines, validates exports, rejects delimiter-bearing icon tokens,
  requires plain data objects and a canonical repository port, bounds browser
  files before reading, pins CI dependencies to reviewed commit identities with
  read-only permissions, and updates release/checkpoint guidance.
- Follow-up evidence: `pnpm lint` passes; `pnpm test:config` passes 18/18; the
  Repeal configuration validates; and `git diff --check` passes. QUnit, Ruby
  system specs, both GitHub workflows, browser/runtime, embed, and consumer
  checks remain unexecuted. No commit, push, tag, release, installation,
  deployment, publication, or live forum mutation has occurred in either local
  remediation batch.
- The follow-up closure review source-closed seven of `BN-CV-01` through
  `BN-CV-08` and found one remaining P1 assurance defect, `BN-FU-01`: the hidden
  mobile system case did not first prove that its same configured site-header
  icon rendered. The final narrow correction now configures the icon in mobile
  bar mode, positively asserts both the bar and icon, changes only
  `mobile_mode` to `hidden`, then asserts every component surface is absent.
  That authored Ruby case remains unexecuted pending the compatible runtime
  gate.
- Final focused static closure independently replayed binary-diff identity
  `bffd9fd8d778076355541202daf441eebb9cde72` and content manifest
  `a750cc4d29d57c77ca810326a9ff0aa642f52af5c46451cb7cffc600778de557`.
  It closed `BN-FU-01` and `BN-CV-02` at source and issued
  `INTERNAL CODE REVIEW PASS`, with no P0-P3 finding remaining in the narrowly
  commissioned static scope. This is not runtime, consumer, or release
  acceptance.

## Settled product decisions

- Visible name: `Brand Navigation`; repository slug: `brand-navigation`.
- Description: “A brand header and submenu navigation theme component for
  Discourse.”
- Do not imply Discourse ownership, maintenance, or official status.
- Credit Brand Header and Header Submenus for product inspiration. The current
  implementation was authored from specifications; no source code from those
  inspiration components was intentionally copied.
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
  theme. Historical imports used individual setting-model updates. The active
  remediation batch replaces that path with one preflighted theme update; it
  still does not attach or enable the component.
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
  render while all three comparison components remain enabled.
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
- Repeal `site_header` icon placement at `3cd8910`: pass. Before the comparison
  icon component was disabled, both ten-icon sets rendered, proving Brand
  Navigation's set was
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
  `navigation_items`/`brand_navigation_item_v1` setting and delegates every
  other schema editor to core behavior. Core admin-editor changes remain a
  maintenance risk.
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

Executed by the official Discourse theme workflow at `13005b7`:

- `test/unit/lib/brand-navigation-test.js`
- `spec/system/brand_navigation_spec.rb`
- `spec/system/core_features_spec.rb`

The QUnit suite and Ruby system specs pass in GitHub Actions run `34010799758`.
They were not executed locally: Ruby, Gem, and Bundler remain undiscoverable on
the Windows PowerShell PATH, and Ubuntu WSL startup timed out.

## Public presence direction

Phil selected platform-oriented CodeWorksLabs discovery hostnames, including
`discourse.codeworkslabs.dev` and `astro.codeworkslabs.dev`, with shared
canonical documentation at `docs.codeworkslabs.dev`. Brand Navigation belongs
on the Discourse platform surface rather than requiring its own product
subdomain. Astro is the recommended implementation for public product/platform
surfaces; Starlight remains the recommended documentation implementation.
Exact paths, repositories, deployment ownership, and timing remain unsettled.
No site, DNS, repository, publication, or deployment action was authorized.

Phil also selected `support.codeworkslabs.dev` as the durable CodeWorksLabs
umbrella support front door. It will route visitors to the appropriate docs,
repository, issue tracker, shared community, or independent product community.
`forum.discussionbridge.dev` remains the independent DiscussionBridge community
and support forum. No shared CodeWorksLabs Discourse instance was authorized or
declared necessary.

## Authorship and provenance control

Phil directed that Brand Navigation retain a durable, defensible record of its
AI-assisted authorship and upstream source classifications before release. The new
`docs/PROVENANCE.md` records Phil's product and acceptance authority, Codex's
implementation role, pinned upstream revisions and licenses, the exact
adapted header-icon registration source, and release-time provenance controls.
The adapted source supplies GPL version 2 text but no explicit “or later” grant
was found in the inspected upstream materials. Before the first tagged release,
Phil selected `GPL-2.0-or-later` for Brand Navigation, with the upstream credit,
precise adapted-pattern reference, and licensing ambiguity preserved in the
public provenance record. Any substantiated concern raised by a rights holder
will be evaluated and corrected as necessary. No version had been tagged or
published as a GitHub Release, but the already-public Git history retains the
license declarations present on those commits. No external human recipient,
adoption, or reliance is known; current repository signals show no forks,
stars, or subscribers. GitHub clone traffic includes CI and installed-component
activity and does not identify people. No ongoing support obligation is
inferred from that historical record.

Licensing-declaration verification on 2026-09-06: `pnpm test:config`
passed all 22 tests and `git diff --check` passed. `pnpm lint:prettier`
continued to report 24 pre-existing baseline files outside this six-file
licensing/provenance change; none of the changed formatted files was reported.

Official-source verification confirms that Discourse Meta labels Brand Header,
Header Submenus, and Custom Header Links (icons) as official and links to the
same `discourse/*` repositories recorded in the provenance ledger. Pavilion
Dropdown Header is the community component. The official repositories genuinely
carry different licenses; official status does not establish a common license.
Any clarification for the icon component must be addressed to the Discourse
maintainers or another confirmed rights holder rather than assuming one
historical contributor can grant it.

## Exact next actions

1. Finish release preparation and manual documentation/product polish.
2. Open one clean draft `v0.9.0` release-preparation pull request.
3. Run CI and freeze the exact candidate commit and tree.
4. Conduct the formal complete codebase review against that immutable
   candidate.
5. Evaluate all findings together and remediate them as one coherent batch.
6. Perform the required correction-closure review and rerun affected tests.
7. Conduct final manual acceptance on the resulting candidate.
8. Merge only when review, CI, documentation, and manual acceptance are
   complete.
9. Confirm the merged tree matches the accepted candidate, then tag `v0.9.0`
   and publish the release.

Keep the previously installed comparison components available for rollback;
disable them only if Phil explicitly chooses a site cutover.

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
