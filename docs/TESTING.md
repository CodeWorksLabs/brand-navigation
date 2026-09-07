# Testing and acceptance

## In use on

### Verified installations

| Site                     | Discourse build        | Core commit  | Verified Brand Navigation coverage                                                                                                                                                          |
| ------------------------ | ---------------------- | ------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Repeal OBBBA Forum       | `2026.7.0-latest+319`  | `988c31e00f` | Authenticated desktop render, linked parents and submenus, visible descriptions, core-header icons, administrator settings, and component coexistence                                       |
| DiscussionBridge sandbox | `2026.9.0-latest+338`  | `587b564093` | Authenticated normal-page render, administrator component/settings surface, and canonical-install reconciliation at Brand Navigation `c878693612`                                           |
| DiscussionBridge Forum   | `2026.9.0-latest+358`  | `f914fcb43e` | Configured navigation, four accessible social header links, safe `_blank` rel, normal authenticated render, full-app embed exclusion, and native `d-compat/2026.8` to `main` transition     |
| The Bridge               | `2026.9.0-latest+188`  | `7dfd824b1`  | Configured publishing navigation, four accessible social header links, safe `_blank` rel, normal authenticated render, full-app embed exclusion, and native `main` update                   |
| Citizen Activist Network | `2026.9.0-latest+358`  | `f914fcb43e` | Configured Community/Issues navigation, submenu keyboard smoke, clean console, normal authenticated render, full-app embed exclusion, and native `d-compat/2026.8` to `main` transition     |
| RVing Community          | `2026.8.0-latest.1+18` | `3f4a87b135` | Configured Community/RVing Network navigation, three-theme attachment, clean console, normal authenticated render, full-app embed exclusion, and native `d-compat/2026.8` update            |
| R744 Community           | `2026.7.2+14`          | `2e46cff73b` | Authenticated normal-page render, submenu/Escape focus behavior, safe `_blank` rel, administrator settings and object editor, full-app embed exclusion, and native `d-compat/2026.7` update |

The original builds were read directly from each site's administrator dashboard
on 2026-09-05. The sandbox identity was refreshed from its running server on
2026-09-07. They are evidence of known compatibility, not minimum-version
declarations. Features not named in a row should be evaluated through the
acceptance matrix below before claiming coverage on that environment.

### Sandbox canonical-install reconciliation — 2026-09-07

The sandbox contained three Brand Navigation imports. Read-only inventory
established that component `1` was unattached, component `2` was attached only
to Horizon with an older configuration, and component `3` held the accepted
sandbox configuration on the default Foundation theme. Component `3` was made
canonical: its source branch was changed to `main`, it updated without an
import error to Brand Navigation commit
`c878693612fd6f4b755e7e1a57f73f61c127a711`, and it was attached to both
Foundation and Horizon. Its eleven stored setting values retained their exact
pre-update hashes and lengths.

Components `1` and `2` were detached, disabled, and left in place as rollback
copies; they were not deleted. Post-change inventory showed only component `3`
enabled and attached, with automatic updates enabled and no remote-theme error.
The public forum returned HTTP 200. This is server-side installation and
availability evidence; it does not replace the earlier browser-rendering
record or claim a fresh anonymous, mobile, accessibility, or embed visual pass.

### DiscussionBridge Forum native compatibility transition — 2026-09-07

The DiscussionBridge Forum was running Discourse
`2026.8.0-latest.1+414` at core commit
`36698aae084678151dffa875d49c8d59216d2733`. Its single Brand Navigation
installation, component `3`, followed the repository's default branch and was
attached to both Foundation and Horizon.

Discourse's native update check selected `d-compat/2026.8`, reporting candidate
commit `a628dcd74c9465903c7eacd59f63e50f6c9d37b6`. The normal remote-theme update
advanced the component from `b0b5354481c30e1db1daf4db682368a6f9c9994d`
to that candidate. Post-update inspection reported the same local and remote
commit, zero commits behind, matching local and remote compatibility refs, and
no import error. All 15 stored setting values retained their exact pre-update
hashes and lengths, both theme attachments remained present, and the public
forum returned HTTP 200.

This establishes a successful native compatibility-branch update with settings
preservation on the recorded 2026.8 build. It is server-side installation and
availability evidence; it does not claim a fresh browser visual, anonymous,
mobile, accessibility, or embed pass.

Phil then upgraded the forum through Discourse's administrator UI. During the
upgrade, the public site served its branded maintenance page with a temporary
unavailability explanation and automatic two-minute refresh. The forum
returned successfully on Discourse `2026.9.0-latest+358` at core commit
`f914fcb43e349d1b3bd6e6dc6106ca78a1e2cc74`.

Post-upgrade inspection confirmed that Discourse automatically moved Brand
Navigation from `d-compat/2026.8` to the repository default branch at `main`
commit `56de8bd30f4d4e1deb5ce766dab4fa62f216d1ec`. Local and remote commits
matched, zero commits were behind, both compatibility refs were empty, and no
import error was present. The component remained enabled and attached to both
Foundation and Horizon. All 15 setting hashes and lengths still matched the
pre-update snapshot, the public forum returned HTTP 200, and Phil confirmed the
administrator UI reported **Theme is up-to-date, last checked: just now**. This
proves the native compatibility-to-default-branch transition and configuration
preservation across the recorded Discourse core upgrade; a fresh post-upgrade
browser interaction matrix remains separate.

### The Bridge native update — 2026-09-07

The Bridge was running Discourse `2026.9.0-latest+188` at core commit
`7dfd824b151fc5b206812e72f3aca6078a71b75f`. Its single Brand Navigation
installation, component `6`, followed the repository's default branch and was
attached to both Foundation and Horizon.

Discourse's native update check selected the repository default branch with no
compatibility ref and reported commit
`56de8bd30f4d4e1deb5ce766dab4fa62f216d1ec`. The normal remote-theme update
advanced the component from `b0b5354481c30e1db1daf4db682368a6f9c9994d`
to that commit. Post-update inspection reported matching local and remote
commits, zero commits behind, no compatibility ref, and no import error. All 15
stored setting values retained their exact pre-update hashes and lengths, both
theme attachments remained present, and the public site returned HTTP 200.
The refreshed administrator UI reported the theme up to date; this Discourse
build omitted the implicit default-branch name from that message.

This establishes a successful native default-branch update with settings
preservation on the recorded 2026.9 build. It is server-side installation and
availability evidence plus administrator status confirmation; it does not
claim a fresh visual, anonymous, mobile, accessibility, or embed pass.

### Citizen Activist Network native compatibility transition — 2026-09-07

Citizen Activist Network was running Discourse `2026.8.0-latest.1+414` at core
commit `36698aae084678151dffa875d49c8d59216d2733`. Its single Brand
Navigation installation, component `1`, followed the repository's default
branch and was enabled on Foundation and Horizon.

Discourse's native update check selected `d-compat/2026.8` at commit
`a628dcd74c9465903c7eacd59f63e50f6c9d37b6`. The normal remote-theme update
advanced the component from `04dbb3d994362f3f900d3f10a916ae4ac7245713`
to that compatibility commit. Post-update inspection reported matching local
and remote commits, zero commits behind, matching local and remote
compatibility refs, and no import error. All three stored setting values
retained their exact pre-update hashes and lengths, both theme attachments
remained present, and the public forum returned HTTP 200. Phil refreshed the
administrator UI and confirmed **Theme is up-to-date with
`d-compat/2026.8`**.

This establishes a successful native compatibility-branch update with settings
preservation on the recorded 2026.8 build. It is server-side installation and
availability evidence plus administrator status confirmation; it does not
claim a fresh visual, anonymous, mobile, accessibility, or embed pass.

Phil then upgraded the forum's PostgreSQL and Discourse containers. The forum
returned on Discourse `2026.9.0-latest+358` at core commit
`f914fcb43e349d1b3bd6e6dc6106ca78a1e2cc74`. Post-upgrade inspection
confirmed that Discourse automatically moved Brand Navigation from
`d-compat/2026.8` to repository-default `main` commit
`56de8bd30f4d4e1deb5ce766dab4fa62f216d1ec`. Local and remote commits
matched, zero commits were behind, both compatibility refs were empty, and no
import error was present. The component remained enabled on Foundation and
Horizon, and all three setting hashes and lengths still matched the pre-update
snapshot. The public forum returned HTTP 200, and Phil confirmed the refreshed
administrator UI reported the theme up to date.

This proves the native compatibility-to-default-branch transition and
configuration preservation across the recorded PostgreSQL and Discourse core
upgrade. A fresh post-upgrade browser interaction matrix remains separate.

### RVing Community native compatibility update — 2026-09-07

RVing Community was running Discourse `2026.8.0-latest.1+18` at core commit
`3f4a87b13554cb3ea366cb3a29ed56fd4b2c3d03`. Its single Brand Navigation
installation, component `16`, followed the repository's default branch and was
enabled on Default, Foundation, and Horizon.

Discourse's native update check selected `d-compat/2026.8` at commit
`a628dcd74c9465903c7eacd59f63e50f6c9d37b6`. The normal remote-theme update
advanced the component from `04dbb3d994362f3f900d3f10a916ae4ac7245713`
to that compatibility commit. Post-update inspection reported matching local
and remote commits, zero commits behind, matching local and remote
compatibility refs, and no import error. All four stored setting values
retained their exact pre-update hashes and lengths, all three theme attachments
remained present, and the public forum returned HTTP 200. Phil refreshed the
administrator UI and confirmed **Theme is up-to-date with
`d-compat/2026.8`**.

This establishes a successful native compatibility-branch update with settings
preservation on the recorded 2026.8 build. It is server-side installation and
availability evidence plus administrator status confirmation; it does not
claim a fresh visual, anonymous, mobile, accessibility, or embed pass. Two
failed email jobs observed during administration are attributable to the site's
intentionally unconfigured outbound mail provider and are unrelated to Brand
Navigation.

### R744 Community native compatibility update — 2026-09-07

R744 Community was running Discourse ESR `2026.7.2+14` at core commit
`2e46cff73b07ecddbcc5603eb3fbf41d563577f6`. Read-only inventory found two
Brand Navigation records. Component `1` was the live installation, enabled on
Foundation and Horizon and following the repository default branch. Component
`2` was an unattached historical compatibility-test copy pinned to
`codex/r744-compatibility`; its Brand Navigation `enabled` setting was false,
although the unattached Discourse theme record's enabled flag remained true.

Discourse's native update check for live component `1` selected
`d-compat/2026.7` at commit
`a628dcd74c9465903c7eacd59f63e50f6c9d37b6`. The normal remote-theme update
advanced it from `04dbb3d994362f3f900d3f10a916ae4ac7245713` to that
compatibility commit. Post-update inspection reported matching local and
remote commits, zero commits behind, matching local and remote compatibility
refs, and no import error. Its stored enabled setting retained its exact
pre-update hash and length, both live theme attachments remained present, and
the public forum returned HTTP 200. Phil refreshed the administrator UI and
confirmed **Theme is up-to-date with `d-compat/2026.7`**. Historical component
`2` was not changed.

This establishes the oldest recorded supported-line native update with
settings preservation. It is server-side installation and availability
evidence plus administrator status confirmation; it does not claim a fresh
visual, anonymous, mobile, accessibility, or embed pass.

R744 will intentionally remain on the supported 2026.7 ESR line as Brand
Navigation's oldest real-world compatibility canary. Its Discourse core should
advance when security or support requirements demand it, or before that release
line leaves support, rather than solely to match newer test sites.

### Automated release compatibility

PR 9 implementation commit `24071e75f189cb4512cf8ce37d8b1576aa0f652d`
passed configuration run `34144739257` (24/24) and Discourse Theme run
`34144739800`. The expanded theme matrix passed current Discourse plus exact
Repeal and R744 2026.7 cores and exact Discourse `v2026.8.0` core commit
`badad7b0456a628e578bc48b9f8c1259422b5d58`. Each core passed backend,
frontend (23/23), and system (30/30) lanes; current linting also passed. This is
automated compatibility evidence, not a claim of manual 2026.8 browser
acceptance.

## Initial verification record

The initial implementation candidate was verified on
`codex/v0.9.0-verification` in pull request
`https://github.com/CodeWorksLabs/brand-navigation/pull/1`, which has since
merged. At implementation commit `13005b7`, official Discourse Theme workflow
run `34010799758` passed linting, English-locale validation, frontend QUnit,
backend, and Ruby system tests. Configuration workflow run `34010799448`
passed all 18 Node bundle tests. This is historical implementation evidence,
not the immutable `v0.9.0` candidate. The accepted release candidate is commit
`9f2a6e0c0c18b075e796ff0e7a15e1e8917b6d8b`, tree
`8eca2b3bb2137ea2a24c4cc4574f518e9227e2a9`; configuration run
`34080419543` and Discourse Theme run `34080419924` passed before manual
acceptance and merge.

The same branch was installed as sandbox component id `2` and verified for the
desktop, 390px mobile menu/bar/hidden, keyboard submenu, safe external-link,
structured import, site-header icon, full-app embed-exclusion, and structured
editor save-stay cases. Classic embedded comments remain unverified because the
sandbox has no embed hosts configured. Anonymous browser, light/dark, RTL,
screen-reader, current export-download delivery, and older-version checks also
remain open manual cases; automated visibility/export logic is green.

After pull request 1 merged as `e22dce2`, sandbox component id `2` was switched
to `main` and reported up to date. A focused post-merge smoke test reconfirmed
authenticated normal rendering, safe submenu behavior and Escape focus return,
successful structured re-import with reload persistence, and complete
Brand Navigation exclusion from `?embed_mode=true` while core main content
remained. No production or consumer site was changed during this check.

## Top-level behavior candidate

Merged pull request 3 (`codex/top-level-link-behavior`, implementation commit
`e53a7d0`, merge commit `317c4be`) adds an
explicit `link_mode` to each top-level navigation item. GitHub Actions run
`34019282463` passed the official Discourse lint, frontend QUnit, backend, and
Ruby system jobs; configuration run `34019282181` passed all 19 Node tests.

Sandbox component id `2` was switched from `main` to the candidate branch for
live verification. The administrator editor displayed **Top-level behavior**,
accepted `group` for Resources, kept `/about` in the editor, and stayed on the
editor after saving. On the normal forum page Resources rendered as one
submenu-only button and opened its About and Discourse Meta children. A group
selection on Community, which had no actionable children, was rejected with
the expected validation message and was not saved. Resources was then restored
to `link`; the normal page again rendered `/about` as the parent link with a
separate submenu caret. The final sandbox setting is therefore Link, matching
its pre-test behavior.

After this round trip, `?embed_mode=true` returned zero Brand Navigation
surfaces, one `#main-outlet`, no broken-theme warning, and no captured console
errors. The first save immediately after changing the component source loaded
the new schema alongside the previous single-page-app validator and failed
closed; reloading synchronized the assets and all subsequent saves passed.

After pull request 3 merged, sandbox component id `2` was returned to `main`
and reported up to date. The final post-merge smoke reconfirmed the linked
Resources parent at `/about`, its separate submenu caret, submenu open and
Escape focus return, and the Meta child link's `_blank` target with
`noopener noreferrer`. The normal page had one Brand Navigation surface, one
`#main-outlet`, no broken-theme warning, and no captured console errors.
Full-app `?embed_mode=true` again excluded Brand Navigation while retaining
`#main-outlet`, with no warning or captured console error. The browser was
restored to the normal sandbox forum page.

After that smoke test, Phil chose the new behavior for the live sandbox sample.
Resources is currently saved as `group`: browser inspection confirmed a
submenu button is present and no Resources parent link is rendered. Its saved
`/about` value and both child destinations remain available in configuration.

## Remaining compatibility targets

- The original R744 test on unsupported `2026.2.0-latest` exposed older module
  APIs and is not a compatibility claim. On 2026-09-05 the site was backed up,
  pinned to `release/2026.7`, rebuilt successfully as `2026.7.2+14`
  (`2e46cff73b`), and verified with Brand Navigation. Live component id `1` is
  enabled on Foundation and Horizon and now follows `d-compat/2026.7`. The
  duplicate component id `2` remains preserved and unattached on historical
  branch `codex/r744-compatibility`; its component-level enabled setting is
  false while its unattached Discourse theme-record flag is true. Draft pull
  request 2 is no longer needed to support this site and was closed without
  merge.
- Refresh installation records when these sites change Discourse release lines
  or Brand Navigation compatibility refs.

## Automated gates

- JavaScript, template, style, formatting, and type linting.
- Discourse shared core-feature system specification with Brand Navigation
  internally enabled, plus an explicit rendered-presence assertion.
- Normal-page rendering of brand, direct links, and native submenu.
- Mobile compact-menu behavior.
- Negative render assertion for `embed_mode=true`.
- Unit coverage for audience visibility and `_blank` link safety.
- Unit coverage for backward-compatible desktop/mobile item visibility.
- Unit coverage for left/right navigation section grouping.
- Unit coverage for excluding site-header items from the brand bar.
- Unit coverage for optional visible submenu descriptions.
- Unit coverage for delayed primary-sprite readiness, shared notification and
  teardown, production-sprite icon membership, replacement icon IDs,
  icon/label presentation, unavailable bar/submenu fallback, and omission of
  unavailable direct site-header icons.
- Rendered component coverage for a retained site-header item that starts
  mobile-hidden, becomes eligible before sprite readiness, subscribes once,
  and appears after the delayed primary symbol arrives.
- Rendered system coverage for visible label fallback when a bar icon is
  unavailable. The prebuilt system harness cannot dynamically register a new
  `api.headerIcons` entry after the component initializer has run.
- Scoped administrator save behavior that remains in the navigation editor.
- Fail-closed bundle schema, URL, size, nested-field, and conditional validation.
- Bounded local bundle validation without forum credentials or network access.
- Schema-scoped object-editor identity and five-setting component-panel
  signature, including locally uploaded components and incomplete-signature
  rejection.
- Complete bundle preflight, immutable persistence snapshots, strict color
  types, inert diagnostics, whole-file symmetry, and Discourse's per-object
  setting byte limit, including a rendered assertion that an oversized object
  sends no persistence request and changes no setting.
- Component-action deferred-completion coverage for submitted appearance and
  bundle snapshots, in-flight state, model reconciliation, dirty state,
  success state, current/exported settings, and unrelated color-draft
  preservation.
- Browser-backed import coverage for persisted appearance reload, synchronized
  picker state, and a clean post-import save state.

## Manual acceptance matrix

Test the current stable and tests-passed Discourse branches where practical.

| Context                     | Required result                                                                                         |
| --------------------------- | ------------------------------------------------------------------------------------------------------- |
| Desktop, anonymous          | Allowed links render; only one submenu opens and Escape restores focus                                  |
| Desktop, authenticated      | Authenticated entries render; anonymous-only entries do not                                             |
| Mobile menu                 | One header control opens usable brand navigation                                                        |
| Mobile bar                  | Responsive bar wraps navigation and exposes unclipped submenus                                          |
| Mobile hidden               | No brand-navigation surface renders                                                                     |
| Site-header item            | Direct icon appears once with its tooltip, audience, target, and safe rel                               |
| Device-specific item        | Renders only for its selected device class, unchanged across phone rotation                             |
| Descriptive submenu         | Description appears below its label; empty entries remain compact                                       |
| Administrator object save   | Settings persist and the structured editor remains open                                                 |
| Administrator bundle import | Complete bundle preflight occurs before one update request; reload after a server error before retrying |
| Light/dark schemes          | Correct logo fallback and readable scheme colors                                                        |
| RTL locale                  | Logical positioning and submenu alignment remain usable                                                 |
| `embed_mode=true` full app  | No bar or mobile trigger mounts                                                                         |
| Classic embedded comments   | No global brand/navigation content appears                                                              |
| Embedded interaction        | Core topic, sign-in, reply, like, quote, and composer behavior is unchanged                             |
| Normal sign-in              | Full-application sign-in remains core Discourse behavior                                                |

Also test long labels, empty configuration, missing optional icons, external
links, browser zoom, reduced viewport width, keyboard-only use, and screen
reader navigation landmarks.
