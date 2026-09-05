# Brand Navigation successor checkpoint

Date: 2026-09-05  
Disposition: **IMPLEMENTATION COMPLETE / RUNTIME VERIFICATION INCOMPLETE /
NOT RELEASE-READY**

Task disposition: **REPLACED BY PHIL — CONTINUE IN ANOTHER TASK**

## Purpose and authority

Brand Navigation is a newly authored Discourse theme component implementing an
optional brand header and one-level navigation hierarchy. It is independently
maintained and is not an official Discourse product.

Phil authorized runtime installation and testing only on:

`https://sandbox-forum.discussionbridge.dev/`

Production installation, publication, deployment, and unrelated sandbox
changes are not authorized. Browser-based Discourse administration is the
default. SSH may be used only when absolutely necessary, after explaining why
the UI or supported API cannot perform the operation.

## Canonical locations

- Local repository: `C:\CodeProjects\Products\Discourse Brand Navigation`
- Git remote: `https://github.com/CodeWorksLabs/brand-navigation.git`
- Branch: `main`
- Local HEAD: `857aba8e4fb45eacd0abc69332cec5ff22c80d2b`
- GitHub `main`: `857aba8e4fb45eacd0abc69332cec5ff22c80d2b`

The functional implementation is available in GitHub and can be installed by
the sandbox through the normal Discourse Git theme-component installer.

## Settled product decisions

- Visible name: `Brand Navigation`.
- Independent-stage repository slug: `brand-navigation`.
- Description: “A brand header and submenu navigation theme component for
  Discourse.”
- Do not use a Discourse prefix, logo, official badge, official Meta tag, or
  language implying Discourse ownership or maintenance.
- Credit Discourse Brand Header and Discourse Header Submenus with simple
  thanks for product inspiration.
- The implementation was newly authored from the accepted product
  specifications. No source code was intentionally copied from either
  reference component.
- Project license: `GPL-2.0-or-later`.
- Administration is a first-class product surface using structured object
  settings and safe defaults.
- One submenu level is supported; arbitrary deep nesting is excluded.
- DiscussionBridge must contain no compatibility logic for this component.

## Non-negotiable runtime invariants

- Site-global brand/navigation content must not mount in any supported
  Discourse embed context.
- The component enforces embed exclusion at both the initializer and component
  render boundaries using supported `EmbedMode.enabled` state.
- Do not use CSS hiding, hostname checks, DOM selectors, or DiscussionBridge
  detection for embed exclusion.
- Leave the classic `embedded_header` and core embed implementation untouched.
- Preserve embedded discussion content, topic navigation, sign-in, reply,
  like, quote, composer, and normal full-application sign-in behavior.
- Normal non-embed pages must retain the intended brand and navigation.

## Implemented surface

- Optional brand name, destination, light/dark logo, presentation mode, and
  link target.
- Ordered direct links and one-level dropdown/submenu entries.
- Internal/external URLs, titles, Font Awesome icons, and safe `_blank` rel
  handling.
- Per-entry `everyone`, `anonymous`, and `authenticated` visibility.
- Desktop placement above or below the core site header.
- Mobile `menu`, `bar`, and `hidden` modes.
- Native `details`/`summary` submenu semantics and navigation landmarks.
- Color-scheme variables, responsive behavior, migration/rollback material,
  release instructions, and administrator/user documentation.

## Current local changes

The working tree intentionally contains uncommitted changes:

- `LICENSE` — MIT replaced by the complete GNU GPL v2 license text.
- `package.json` — declares `GPL-2.0-or-later`.
- `README.md` — GPL declaration, simple thanks/credit, current Discourse admin
  path, and link to the user guide.
- `docs/ATTRIBUTION.md` — deleted by Phil’s direction; no predecessor MIT
  notice is carried because no predecessor source was copied.
- `docs/MIGRATION.md` — “predecessor” replaced with clearer “earlier
  component” language.
- `docs/RELEASE.md` — release credit check now points to the README.
- `docs/USER_GUIDE.md` — new administrator and visitor guide covering install,
  configuration, navigation, mobile, visibility, keyboard use, updates,
  verification, rollback, and troubleshooting.
- `SUCCESSOR_CHECKPOINT.md` — this handoff; untracked until committed.

Do not discard, reset, or overwrite these changes. No commit or push has been
authorized or performed for them.

## Verification evidence

Executed successfully on Windows from the canonical repository:

- `pnpm lint`
  - ESLint: pass
  - Ember template lint: pass
  - Stylelint: pass
  - Prettier source check: pass
  - Ember TypeScript/Glint check: pass
- `pnpm prettier README.md docs/USER_GUIDE.md --check`: pass
- `git diff --check`: pass
- `package.json` parses and reports `GPL-2.0-or-later`.

Authored but not executed in a compatible Discourse runtime:

- `test/unit/lib/brand-navigation-test.js`
- `spec/system/brand_navigation_spec.rb`
- `spec/system/core_features_spec.rb`

Do not describe those tests as passing. Ruby, Gem, and Bundler were not
discoverable on the Windows PowerShell PATH. Ubuntu WSL startup probes timed
out, so the WSL Ruby state remains unverified; do not claim Ruby is absent from
the machine.

## Sandbox/browser facts

- `https://sandbox-forum.discussionbridge.dev/about.json` returned HTTP 200.
- The sandbox reported Discourse `2026.9.0-latest` during the check.
- One anonymous desktop browser load returned HTTP 200 and found zero
  `[data-brand-navigation]` elements.
- That result proves only that Brand Navigation did not render in that exact
  anonymous page state. It does not prove whether the component is installed,
  disabled, empty, or excluded by configuration.
- No authenticated theme inventory, installation, configuration, or runtime
  acceptance test has been completed.

## Abandoned access attempts and residue

The `chrome:control-chrome` skill was initially absent. Its files were later
restored and the skill became visible in the active skill catalog. The required
`mcp__node_repl__js` execution endpoint nevertheless remained absent from the
task's complete callable-tool inventory and evaluated as undefined. Therefore,
this task never bound to or inspected Phil’s ordinary authenticated sandbox
admin tab.

Phil is replacing this task and will continue in another task. Do not repeat
the Playwright profile, Chrome Sync, or SSH detours.

Preserved local residue outside CodeProjects:

- `C:\Users\Owner\AppData\Local\Codex\brand-navigation-sandbox-browser`
- `C:\Users\Owner\AppData\Local\Codex\brand-navigation-sandbox-google-chrome`
- Playwright browser binaries under the user-local `ms-playwright` cache.

Both dedicated test-browser processes were terminated. Phil’s ordinary browser
was not attached to, inspected, modified, or closed. The residue was
deliberately preserved because deletion was not authorized.

One strict, read-only SSH attempt was made before Phil established the
browser-first rule. It failed closed before authentication because the host key
did not match the pinned `known_hosts` entry. No remote command ran. Do not
modify `known_hosts` or resume SSH merely to work around browser access.

## Exact successor requirements and next action

The replacement task must confirm that both the `chrome:control-chrome` skill
and its required `mcp__node_repl__js` execution endpoint are callable before
claiming browser access. It must then bind to Phil’s already-open,
already-authenticated sandbox administrator tab. It must not create another
browser profile, request credentials, copy cookies, use Chrome Sync, or
substitute SSH for ordinary Discourse administration.

First action:

1. Open the existing authenticated tab at
   `https://sandbox-forum.discussionbridge.dev/admin/config/customize/components`.
2. Record the current theme/component inventory and Brand Navigation pre-state.
3. Install the GitHub component if absent, or record its installed revision and
   configuration if present.
4. Configure only reversible test data on the sandbox.
5. Execute the complete matrix in `docs/TESTING.md`, including desktop/mobile,
   empty and partial settings, anonymous/authenticated visibility, keyboard and
   accessibility behavior, `_blank` safety, full-app embed mode, classic embed
   exclusion, and preservation of core embed interactions.
6. Record every sandbox mutation and the final retained/restored state.
7. Report exact commands/actions, pass/fail results, gaps, and residual risks to
   Discourse Boss before any release decision.

## Out of scope

- CMS behavior or general page building.
- Arbitrary deep navigation nesting.
- Authentication replacement.
- Changes to core Discourse embedding.
- DiscussionBridge compatibility code.
- Hostname, CSS, or DOM-selector embed workarounds.
- Literal integration into Discourse core as an initial requirement.
- Production installation or deployment.
- Commit, push, public release, or official-status claim without a new explicit
  decision.
