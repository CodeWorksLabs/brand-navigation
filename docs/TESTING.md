# Testing and acceptance

## Seven-forum update follow-up — 2026-10-17

All seven forums were confirmed to follow `main` on October 17, 2026.
Earlier compatibility-branch checks below describe previous installations.

The component ID identifies Brand Navigation in each forum's Discourse admin;
it is not a version number.

| Forum                    | Discourse component ID | Update branch |
| ------------------------ | ---------------------- | ------------- |
| Repeal OBBBA Forum       | 19                     | main          |
| The Bridge               | 6                      | main          |
| DiscussionBridge Forum   | 3                      | main          |
| DiscussionBridge sandbox | 3                      | main          |
| Citizen Activist Network | 1                      | main          |
| RVing Community          | 16                     | main          |
| R744 Community           | 1                      | main          |

The live source settings and native updater status were checked on all seven.
The sandbox's active component was changed from its RC1 release-branch pin to
`main`. RVing and R744 were changed from automatic compatibility selection to
explicit `main`, without upgrading Discourse or touching detached rollback
copies. The remaining forums already followed the default branch, `main`.

The update follow-up covered administrator controls, saved-setting preservation,
unsaved Move down / Move up checks, and submenu keyboard interaction. Repeal's
focused results are recorded separately below. RVing and R744 were checked
again **after** their switches to `main`; the earlier compatibility-branch
checks were not reused as proof of their new installations.

### RVing and R744: fresh checks on main

Both sites reported **Theme is up-to-date with main**. Checks used Chrome,
signed-in administrators, a 1680 × 901 desktop viewport and each site's active
theme, without switching themes.

| Forum           | Discourse version | Core commit                                | Attached themes              |
| --------------- | ----------------- | ------------------------------------------ | ---------------------------- |
| RVing Community | 2026.9.0-latest   | `9cccc5837dc83a7af376dd40d4cb709cd25b0228` | Default, Foundation, Horizon |
| R744 Community  | 2026.7.2          | `2e46cff73b07ecddbcc5603eb3fbf41d563577f6` | Foundation, Horizon          |

Confirmed on both sites:

- All eleven Appearance color pickers and all four desktop/mobile header-size
  fields were present. The size fields retained their default value, `0`.
- All sixteen settings present immediately before the switch retained their
  exact values, including navigation and colors. The current settings editor
  listed twenty-six settings after the new controls were added.
- The object editor displayed the same-area (**Surface**) ordering hint and
  **Move up** / **Move down** titles and accessible labels. Move up was disabled
  for the first item. Move down changed the draft order; Move up restored the
  complete original tree. **Save Changes was not pressed.**
- Fresh forum pages rendered the configured navigation. RVing's Community
  submenu and R744's Resources submenu opened. Tab focused a visible child:
  Latest discussions on RVing and About on R744. Escape closed each submenu
  and returned focus to its own control.
- Focused submenu text was dark (`#222222`) on the light highlight
  (`#F7CDC2`). The configured Discourse Meta new-tab links had
  `rel="noopener noreferrer"`; same-tab links retained `_self`. No visible
  error alerts were found on the checked pages.

These are live desktop smoke checks, not a new release qualification or a full
theme/device matrix. Mobile, anonymous sessions, pointer hover, theme switching,
live color/size changes and setting-save persistence were not replayed. No live
navigation or color values were changed during these checks.

## Live follow-up: Repeal OBBBA Forum — 2026-10-17

Brand Navigation component 19 on Repeal OBBBA Forum was updated through
Discourse's native updater from `d6904df88d9975a3046381173e6764d8ec0ed165`
to `e791167cf0f0aac16884de6f730694fbdeebfc4e`. The updater reported
up-to-date, and a fresh page load displayed the revised Surface wording.

Environment: Chrome, signed-in administrator, 1680 × 901 desktop viewport,
the site's active theme without theme switching. The page reported Discourse
`2026.10.0-latest`, Core `bf55a44c2872738f7ae2664d6fec3d6d8779190f`.

Confirmed after the update:

- The editor displays “Items in the same area (Surface) appear in the order
  listed.” Both arrows have **Move up** / **Move down** titles and accessible
  labels. Move up is disabled for the first item.
- Move down moved the selected item below its neighbor; Move up restored the
  original order. This was an unsaved draft check: **Save Changes was not
  pressed**, and the saved navigation was not reordered.
- All eleven Appearance color pickers were present. The visible setting-field
  values and navigation-tree order matched the pre-update observations.
- Social opened its submenu. Keyboard focus on Bluesky produced visible white
  text and icon fill (`#FFFFFF`) on the navy background (`#002147`). Escape
  closed the submenu and returned focus to its control. White submenu-hover
  text was already configured before this update; no colors were changed.

This is a focused live desktop check, not a new release qualification or a full
theme/device matrix. Pointer hover, mobile, other themes and live setting-save
persistence were not replayed in this session. Automated reorder/save coverage
passed separately in PRs #31 and #32; it is not presented as a live-site save.

## RC2 feature verification (historical)

Updated 2026-10-17. Phil selected the alignment, icon-color and friendly-editor
features for `v1.0.0-rc.2`, before its first publication. The runtime-tested
candidate is the frozen `admin-label-test-r2` delta over main commit
`1ddfef2872855289763b10fc39800ec1ba7f455a`: 58 members, with no candidate
commit/tree claimed. Its canonical ZIP is 269,937 bytes, SHA-256
`58123c4c03f1ce8e8cf98cceaa1f9c92225c8b8cb1040f3abb17b82cb7da8f34`.
The subsequent four-record preparation changes only the changelog, this record,
the successor checkpoint and administrator-guide release wording. The final
package must be associated separately with these tested bytes: a changed ZIP
hash is not a new native-install result, and unchanged Core-consumed fields must
be verified before carrying the installed evidence forward.

Isolated actual checks used Discourse Core
`3086c087a2bceb3d607c6389f77204fec054b018`:

- Normal Foundation/Horizon coverage passed 12 cases/24 layout variants, and
  the earlier shipped component suite passed 22 examples. Explicit
  unchanged-effective-source analysis supports their applicability through the
  focused corrections; these were not replayed as a fresh full replacement suite.
- Fresh Foundation/Horizon 320px RTL minimized-topic checks and two new shipped
  English/Arabic regressions passed: four examples, zero failures. Owned/native
  hit targets, measured header offsets, menu/Escape/focus return and actual
  native topic-link restoration were reached and verified.
- Three prior positive feature cases (Foundation dark colors and both stock
  minimized-header keyboard cases) carry across the unchanged relevant source.
  A fresh, exactly selected five-case run passed Foundation light, Horizon
  light/dark, native friendly-editor persistence and Appearance persistence.
  This qualifies the eight adopted scenarios through bounded evidence, not a
  fresh single eight-case run. Browser feature captures used Chrome 151.0.
- The four palette cases exercise blank, normal-only, hover-only and combined
  icon-color settings across both alignments and icon-only/icon-label links.
  Actual hover and pointer-away keyboard focus were checked independently.
  Inheritance follows the declared theme variables; native icons, link text and
  brand-bar colors remain unaffected. Native light/dark selection was exercised
  on both stock themes. This closes the earlier overlapping-hover and untested
  palette limitations for these exact cases, not every third-party theme.
- The actual native editor adds Menu item/Submenu item rows, saves, stays open,
  reloads and edits persisted values without changing stored schema identities.
  Appearance saves/reloads both colors, clears them with Inherit all, then
  imports/reloads them. Native color-input events were used; the OS picker
  dialog was not exercised.
- Native ZIP import returned component ID 35. All 20 fields matched exact
  Core-consumed names, targets, types and canonical digests, without field
  errors or unexpected attachments. The prior replacement's 20 fields and the
  original 19-field component were preserved, with census/default/joins guards;
  the separate historical installation was also retained.
- Installed component 35 passed all 40 unique named frontend tests: 21 unit,
  six icon/readiness and 13 administrator/bundle cases; zero failures, skips or
  todos. This includes real native-editor API regressions, strict tracked-data
  saves and older five-color component-copy behavior. The profile used Puma
  8.0.2 with one request thread and Chrome 155.0; the runner reported plugins
  disabled. It does not qualify default server startup or all-plugin behavior.

Historical failures remain recorded, not relabeled as passes. The first
eight-case feature attempt passed three and failed five: it exposed the
friendly-label product defect alongside a compilation timeout, color-oracle
mismatch and detached test control. The bounded product/test corrections and
fresh selected outcomes supplied the missing observations. A subsequent retry
selected zero cases because its filter used the wrong RSpec option; the strict
count guard failed that run. The first installed frontend run passed 37/40;
three native-helper cases failed before assertions because the initializer lacked
its application owner. A one-line test-only context correction, with runtime
bytes unchanged, preceded the final 40/40 result. No assertion, count or timeout
was relaxed to obtain these outcomes.

Independent source, artifact and actual-results review closed the friendly-label,
mixed/minimized-header and test-harness findings within their stated boundaries.
The CodeWorksLabs Discourse package informed the review; this is not official
Discourse approval, stable-version certification or a claim of unexecuted manual
acceptance. Historical native Git upgrade/rollback/return evidence carries only
across the explicitly unchanged storage/update boundary, not as a fresh full
lifecycle replay on this archive or a future tag.

Fresh remote CI for the final feature commit is pending. Older main/PR25 green
runs below belong to their identified historical source, not this new delta.
Local configuration checks passed 37 cases; types, CSS and template checks
passed. A generic Windows ESLint invocation remained an unqualified environment
diagnostic, not lint green. A separate same-effective-source baseline comparison
reported 12 inherited messages, zero introduced and 24 resolved; it does not
replace exact-head CI lint evidence.

### Current limits and release boundary

Prefer short labels and fewer narrow-screen destinations. Long text can be
heavily truncated and logos compact; full accessible labels and usable tested
targets do not imply unlimited capacity or universal readability. The completed
stock RTL/compact/minimized cases are bounded positive evidence, not the full
RTL acceptance matrix. Genuine browser zoom, the full RTL matrix, an allowed-host
classic external embed and complete human screen-reader acceptance remain the
established stable-v1 boundaries below. Physical-device/Safari, OS picker,
all-plugin compatibility and general accessibility certification are not claimed.

Phil authorized the remaining checks and independent review, then commit/push
and a new draft release-preparation PR. No new PR or final-feature CI result is
asserted yet. Merge, tag, GitHub prerelease and live changes remain separate;
the Bridge's Versions & Status migration is not included. Owned test PostgreSQL
and Redis were cleanly stopped at 08:42:57 UTC on 2026-10-17 before container
stop; databases, backups and failed/positive evidence were preserved.

## Historical RC2 engineering verification — 2026-10-16

The earlier executable candidate for `v1.0.0-rc.2` was commit
`e7a16be653be8ccc045b73833d44ab38330689f1`, tree
`7eee3e5416a9ed2c15bc36b15b54d1bb65c84960`. Its canonical 57-file ZIP is
263,117 bytes, SHA-256
`f2ad43cb6a98106a4efeac8eeeeed2082bf48616a2f9885b54841dece794532a`.
The subsequent RC2 integration update changes only the changelog, this testing
record, and the successor checkpoint. It does not change runtime code, tests,
settings, dependencies, workflows, or installation/update behavior. The evidence
below belongs to the identified executable candidate, not an untested new
runtime or a future tag.

[Configuration CI 38973081900](https://github.com/CodeWorksLabs/brand-navigation/actions/runs/38973081900)
passed all 33 configuration/CLI tests.
[Discourse CI 38973082167](https://github.com/CodeWorksLabs/brand-navigation/actions/runs/38973082167)
tested merge commit `659f2d7ba77fc44b9b1d68fc38afe816785de8ad`, whose tree
matches the candidate exactly:

| Lane          | Exact Discourse Core commit                | Frontend  | System    |
| ------------- | ------------------------------------------ | --------- | --------- |
| Development   | `821e9e2f9f94483a3be8d1e077cde0fd94970479` | 30 passed | 36 passed |
| Repeal 2026.7 | `988c31e00fb73713c81b93cd47f68af0fb4c6273` | 30 passed | 36 passed |
| R744 2026.7   | `2e46cff73b07ecddbcc5603eb3fbf41d563577f6` | 30 passed | 36 passed |
| 2026.8.0      | `badad7b0456a628e578bc48b9f8c1259422b5d58` | 30 passed | 36 passed |

Each system lane includes 16 component examples and 20 shared Core examples.
The lint gate passed; the jobs named backend tests performed English-locale
validation, not backend RSpec. These are exact tested targets, not claims for
every newer patch, production 2026.9, or every browser.

Additional isolated local checks used Core
`3086c087a2bceb3d607c6389f77204fec054b018`:

- The two shipped 320px/390px mobile regressions, three mode/keyboard interaction
  examples, and 16 mobile presentation/audience examples passed: 21 total.
  Captured geometry and pointer/keyboard operations verified visible usable
  targets, menu/logo containment, native controls, and no document overflow.
- Native import of the exact ZIP returned component ID 34. All 19 candidate
  fields matched canonical source, and all 19 fields of the pre-existing
  component were preserved. Installation had no field errors or unexpected
  attachments.
- The installed component passed all 30 named frontend tests, including both
  tracked-row save modes and invalid nested-data rejection. The profile used
  Puma 8.0.2 with one request thread, Chrome 155.0 and the existing frontend
  build; the runner reported plugins disabled. It does not establish default
  Pitchfork startup performance or all-plugin frontend coverage.
- Earlier native lifecycle evidence covered configured RC1-to-candidate source
  updates, rollback, return, settings retention, disable/re-enable, attachment
  and removal. Its unchanged storage/update protocol carries forward with
  explicit impact analysis; it is not represented as a fresh complete Git
  lifecycle replay at `e7a16be` or at a future RC2 tag.

Independent reviewers closed the CLI diagnostic, native-editor save and mobile
layout findings. The CodeWorksLabs Discourse review package was applied to the
source, execution and artifact evidence. The final bounded engineering review
identified no open required findings; it is not official Discourse approval,
stable-version certification or a claim that unexecuted manual checks passed.
Local test databases, backups and all failed/successful evidence were retained;
owned test services were stopped after verification.

### Historical RC2 limits and release boundaries

These statements describe the earlier candidate's evidence at that gate. The
current feature verification and acceptance limits above supersede them.

At 320px, long header text can be heavily truncated, especially beside an icon,
and the logo is compact. Full title/accessible labels and operable targets are
retained; full visible text, unlimited header capacity and universal readability
are not claimed. Prefer short labels and fewer narrow-screen destinations.

Genuine browser zoom and native light/dark palette/focused-color transitions
remain unverified. Complete RTL, a real allowed-host classic external embed and
complete human screen-reader acceptance remain the stable `v1.0.0` gates below.
Physical-device/Safari and general accessibility certification are not claimed.

Phil requested completing PR 25 and putting RC2 on `main` after receiving the
engineering result and these outstanding acceptance boundaries. This records
merge authority, not completion of those unexecuted manual cases. RC2 tag and
GitHub prerelease publication remain separate. The Bridge's Versions & Status
link still belongs to Custom Header Links until a separately authorized live
migration is verified.

## RC2 CLI diagnostic correction — 2026-10-15

Phil authorized correcting review finding `BN-RC2-CLI-01` before RC2. The CLI
now escapes C0, DEL and C1 controls at its final diagnostic sink. Trusted usage
and validator line separators are inserted only after each line is escaped.
The browser validator and header implementation are unchanged.

Local Node `22.22.2` configuration/CLI tests passed 33/33. Seven new tests
capture real CLI subprocess output for malformed JSON containing ESC/BEL,
other controls and newlines, filesystem errors, inert unknown fields, ordinary
parse failures, valid input, and multiline usage. Fixtures use newly created
temporary directories and are cleaned up by the harness. The initial regression
expected a full long payload in V8's truncated error excerpt; shortening the
payload made the assertion exercise both ESC and BEL without relying on omitted
bytes. This was a test-fixture correction, not a candidate bypass.

The pnpm launcher could not verify its requested version because registry
fetches failed. No signature policy was weakened and no dependency changed;
formatting used the already-installed Prettier directly through Node. This
local result does not establish replacement-candidate CI or installed lifecycle
acceptance. Correction closure and the resource-held Discourse matrix remain
separate pending gates.

## RC2 core-header text-link candidate — 2026-10-15

The next candidate adds `header_presentation` for direct core-header links.
Existing items default to `icon_only`; explicit `label_only` and
`icon_and_label` preserve the label without requiring an available icon.
The Bridge's current Versions & Status link remains supplied by its separate
Custom Header Links component until an accepted candidate is installed and
that link is migrated.

Implementation commit `6c7383dd5597d65c7f1e0f9ffdf123d075fab898`, tree
`4682d861dec9029622459a5a3e633730d63aba94`, passed
[Discourse CI run 38812437699](https://github.com/CodeWorksLabs/brand-navigation/actions/runs/38812437699)
in [draft PR 25](https://github.com/CodeWorksLabs/brand-navigation/pull/25).
The CI merge commit `0fa60378a91d11bd2dc5f6a645cf0e348cbf3975` has the same tree.

| Lane           | Discourse core                             | Frontend  | System    |
| -------------- | ------------------------------------------ | --------- | --------- |
| Current        | `60cbc8e4e4e52253d3fa2175b7f2431a38cb9487` | 27 passed | 34 passed |
| Repeal 2026.7  | `988c31e00fb73713c81b93cd47f68af0fb4c6273` | 27 passed | 34 passed |
| R744 2026.7    | `2e46cff73b07ecddbcc5603eb3fbf41d563577f6` | 27 passed | 34 passed |
| 2026.8 release | `badad7b0456a628e578bc48b9f8c1259422b5d58` | 27 passed | 34 passed |

The full Linux lint gate and backend lanes passed.
[Configuration run 38812437412](https://github.com/CodeWorksLabs/brand-navigation/actions/runs/38812437412)
passed 26 tests, including text-link round trips, legacy icon defaults, unsafe
URLs, invalid presentation, groups, and children. Local configuration tests,
template/style/type checks, Ruby syntax, and formatting also passed. Windows
ESLint reproduces local Babel path/theme-global failures on unchanged HEAD;
the clean CI lint gate passes.

QUnit verifies rendering before sprite readiness, escaped label text, safe
new-window attributes, optional-icon recovery, and visibility boundaries.
System tests verify desktop/mobile sizing, retained core controls, keyboard
focus, and embed exclusion. Desktop/mobile CI screenshots were inspected.
The initial run at `93f7c24` failed an RSpec context-name check and a
Selenium-only keyboard-test call; the corrected run above passes both.
This is implementation/test evidence; release review, manual acceptance, and
the live demo cutover remain pending.

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

### Sandbox release-tag rollback exercise — 2026-09-07

Canonical component `3` was disabled through Discourse's component-level
**Enabled?** control, then changed from repository-default `main` to immutable
tag `v0.9.0`. Read-only inventory confirmed exact release commit
`d2527bfb3acdcf4204a33d35e0b13504f6d7c36e`, no import error, and preserved
Foundation and Horizon attachments. Phil enabled the `v0.9.0` legacy internal
setting and confirmed the navigation rendered correctly.

The exercise exposed a product flaw: Discourse's component-level **Enabled?**
control and the component's legacy internal `Enabled` setting could contradict
one another and did not synchronize. The `v1.0.0-rc.1` correction removes the
internal setting and relies only on Discourse's native control.

Component `3` was then disabled through the native control and returned to a
blank **Branch** field. Discourse resolved repository-default `main` at exact
commit `56ee6f874efb85dfd6976928954f0dcd74aab3c8`, with zero commits behind and no
import error. Both parent-theme attachments and every recorded setting hash
were preserved. The component was re-enabled through the native control and
the public forum returned HTTP 200. Final human visual confirmation of the
returned `main` rendering was not separately recorded before the RC test began.

For the single-switch RC test, component `3` was disabled and changed to
`release/v1.0.0-rc.1` at exact commit
`86c9083b8f83dc21d95fc772d5fc7b08e475bc14`. The import reported no error, zero
commits behind, preserved settings and both parent-theme attachments, and no
longer defined `enabled` as a component setting. The earlier value remains as
an inert stored row, which allows an intentional `v0.9.0` rollback to recover
it. Component `3` was enabled through Discourse's native control and the public
forum returned HTTP 200. Phil then confirmed the RC rendered correctly in the
sandbox and that Discourse reported the component up to date with
`release/v1.0.0-rc.1`. Server inspection separately confirmed that the
administrator schema no longer defines an internal `enabled` setting.

### Single-switch CI correction — 2026-09-07

Pull request 19's first CI run after removal of the internal `enabled` setting
passed configuration, lint, backend, and frontend coverage but failed the
explicit rendered-presence example in all four system-test lanes. The normal
Brand Navigation system suite still rendered successfully. Inspection showed
that the shared core-feature fixture no longer persisted the uploaded component
after its obsolete theme-setting assignment was removed.

Commit `f6ca29b9b911936df1cbb4306411574b5bd50e34` corrected both system fixtures
to persist Discourse's native `Theme.enabled` state. Configuration workflow run
`34176240352` passed, and Discourse Theme workflow run `34176242873` then passed
lint, backend, frontend, and system coverage on current Discourse, 2026.8, and
both 2026.7 targets. This verifies that the automated fixture now exercises the
same single activation source as the product.

### Sandbox embed and RTL browser evidence — 2026-09-07

The sandbox remained on Discourse `2026.9.0-latest` at exact core commit
`587b564093f20285dd15a02aea3eeb54886870e8`. Canonical component `3` was on
`main` at Brand Navigation commit
`56de8bd30f4d4e1deb5ce766dab4fa62f216d1ec`, tree
`176d51fa7b5eed30833258b73befe99f3173d2b7`, with no import error and with both
Foundation and Horizon attached. The later repository changes through merged
`main` commit `dc0e935ab54eead212e41681320470b52fc6a775` are documentation-only; an
exact runtime-path diff from `56de8bd` is empty.

A temporary allowed host at `localhost:8765`, a dedicated temporary topic with
one reply, and an exact `TopicEmbed` mapping supplied a real classic-comments
fixture. Chromium `152.0.7977.76` loaded the external page at a 1280 by 1200
viewport. The rendered classic embed contained the reply count, author, reply
content, timestamp route, and **Continue Discussion** route. Its response and
render contained no Brand Navigation bar, mobile trigger, header icon, runtime
asset, or component class. The screenshot was visually inspected during the
test.

With Discourse's native full-app embed setting temporarily enabled, the same
topic was loaded with `embed_mode=true` and an allowed external referrer at
1440 by 1000 and 390 by 844 viewports. Both loads contained zero Brand
Navigation bars, navigation landmarks, submenu summaries, and mobile triggers.
Core Discourse still exposed the topic-progress landmark, post content, reply
button, logged-out like prompts, copy-link actions, and **Sign in to reply**
composer call to action. This confirms exclusion and availability; quote
selection, completed sign-in, and authenticated composer submission were not
executed in this pass.

For RTL evidence, the sandbox default locale was temporarily set to Arabic.
The browser reported `lang=ar` and computed `direction=rtl`. Foundation and
Horizon were each exercised on desktop and in the component's mobile menu at
390 by 844. The logical right section mirrored to the physical left, ordinary
items remained grouped at the physical right, and every tested submenu stayed
within the viewport. Keyboard **Enter** opened Resources, **Tab** reached its
first child, and **Escape** closed it. Desktop focus returned to the submenu
summary; mobile Escape closed the containing menu and returned focus to the
Brand Navigation header control. RTL full-app desktop and mobile embeds also
contained no Brand Navigation surface. Browser screenshots and computed
geometry were inspected during the pass.

The test restored `default_locale=en`, `embed_full_app=false`, and
`embed_any_origin=false`, removed the temporary allowed-host and topic-embed
records, and soft-deleted the dedicated topic. Post-cleanup verification found
zero embeddable hosts, no active temporary mapping, and no active temporary
topic.

This is reproducible browser/runtime evidence, not a claim of completed human
assistive-technology acceptance. A preparatory Chromium accessibility-tree pass
also exposed the named Brand Navigation landmark, distinct linked-parent and
submenu-caret controls, focusable child links, visible-description association,
named social icon links, mobile control name/state, and embed exclusion. The
human screen-reader gate below remains open.

### Partial iPhone VoiceOver evidence — 2026-09-07

An anonymous portrait-mode pass on the public Repeal OBBBA Forum used Safari
with iPhone VoiceOver. The exact iPhone model, iOS build, and VoiceOver version
were not recorded, so this is bounded evidence rather than a completed
screen-reader acceptance pass.

VoiceOver announced the mobile trigger as **Brand Navigation, button** and
activation exposed the menu items. A submenu control announced its open action
and collapsed state. After activation, VoiceOver exposed each tested child's
name and link role and read the visible description associated through
`aria-describedby`. VoiceOver did not speak the outer mobile trigger's
collapsed/expanded state during the observed sequence. Its two-finger scrub did
not close the open submenu, and direct-toggle closure was not completed before
the session ended. These observations remain open for a controlled follow-up.

The same portrait session exposed a separate responsive-capacity limitation.
With five Brand Navigation social destinations configured for mobile alongside
Discourse's Log In, Search, and Navigation controls, the Brand Navigation menu
trigger was largely obscured by Log In. A Chromium-compatible 390 by 844
reproduction measured the fixed header panel at approximately 375px inside an
approximately 369px content row; the trigger's outlet consequently collapsed
to zero width. Operators should currently reserve mobile header capacity by
marking additional social destinations **Desktop only**. Automatic overflow or
priority handling is not implemented and requires separate product treatment.
Changing one of the observed mobile social destinations to **Desktop only** on
the Repeal installation stopped the overflow and restored the complete Brand
Navigation menu trigger on the tested iPhone portrait viewport.

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
`2` was an unattached copy pinned to the historical R744 compatibility-test
branch; its Brand Navigation `enabled` setting was false,
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

The initial implementation candidate was verified on the candidate branch in pull request
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

Merged pull request 3 (top-level link behavior, implementation commit
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
  duplicate component id `2` remains preserved and unattached on the historical
  R744 compatibility-test branch; its legacy Brand Navigation `enabled`
  setting is false while its unattached Discourse theme-record flag is true.
  Draft pull
  request 2 is no longer needed to support this site and was closed without
  merge.
- Refresh installation records when these sites change Discourse release lines
  or Brand Navigation compatibility refs.

## Automated gates

- JavaScript, template, style, formatting, and type linting.
- Discourse shared core-feature system specification with Brand Navigation
  enabled through Discourse's native component state, plus an explicit
  rendered-presence assertion.
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
- Deferred file-selection coverage proving that only the latest selected file
  or pasted bundle may replace pending import state.
- Mobile-menu geometry coverage proving that an open linked-parent submenu
  occupies layout space before its following navigation item.
- Browser-backed import coverage for persisted appearance reload, synchronized
  picker state, and a clean post-import save state.

## Manual acceptance matrix

Test the current stable and tests-passed Discourse branches where practical.

| Context                     | Required result                                                                                        |
| --------------------------- | ------------------------------------------------------------------------------------------------------ |
| Desktop, anonymous          | Allowed links render; only one submenu opens; Escape from it returns focus to its submenu control       |
| Desktop, authenticated      | Authenticated entries render; anonymous-only entries do not                                            |
| Mobile menu                 | Header button opens navigation; Tab reaches the first link or submenu control; Escape dismisses the menu and returns focus to the header button |
| Mobile bar                  | Responsive bar wraps navigation and exposes unclipped submenus                                         |
| Mobile hidden               | No brand-navigation surface renders                                                                    |
| Site-header item            | Direct icon appears once with its tooltip, audience, target, and safe rel                              |
| Device-specific item        | Renders only for its selected device class, unchanged across phone rotation                            |
| Descriptive submenu         | Description appears below its label; empty entries remain compact                                      |
| Administrator object save   | Settings persist and the structured editor remains open                                                |
| Administrator bundle import | Use a separate component copy or staging site for a live installation; complete preflight occurs before one update request |
| Light/dark schemes          | Correct logo fallback and readable scheme colors                                                       |
| RTL locale                  | Logical positioning and submenu alignment remain usable                                                |
| `embed_mode=true` full app  | No bar or mobile trigger mounts                                                                        |
| Classic embedded comments   | No global brand/navigation content appears                                                             |
| Embedded interaction        | Core topic, sign-in, reply, like, quote, and composer behavior is unchanged                            |
| Normal sign-in              | Full-application sign-in remains core Discourse behavior                                               |

Also test long labels, empty configuration, missing optional icons, external
links, browser zoom, reduced viewport width, keyboard-only use, and screen
reader navigation landmarks.

## Remaining manual gates for `v1.0.0`

The `v0.9.0` preview does not claim completed human verification for these
three cases. The browser/runtime evidence above materially advances the first
two but does not substitute for final human confirmation:

1. A classic Discourse comments embed on an allowed external host, proving that
   Brand Navigation does not mount while embedded discussion content and core
   interaction controls remain available.
2. A complete RTL-locale desktop/mobile pass covering layout, submenu
   alignment, focus, keyboard behavior, responsive modes, themes, and embed
   exclusion.
3. Complete the human screen-reader testing begun in the partial iPhone
   VoiceOver pass above, covering the navigation landmark, accessible names,
   expanded/collapsed state, linked-parent and caret actions, dismissal and
   focus return, visible descriptions, icon links, responsive controls, and
   embed exclusion.

Execute these on a controlled test environment after the operator-documentation
correction closes. Record the Discourse build and core commit, Brand Navigation
commit/ref, theme, browser, viewport/device, account state, assistive technology
and version when applicable, exact steps, and pass/fail result. Gather all
findings before making a correction batch; automated accessibility tests do not
substitute for these human checks.
