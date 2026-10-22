# Brand Navigation Known Issues

## Current disposition — October 22, 2026

The lengthy process failed to produce a clear overall answer. That is a
testing-process failure, not evidence of more product bugs.

Phil's assessment is explicit: **"The testing execution is a failure that will
have a resolution."** That execution failure remains an unresolved process
issue. Its resolution has not yet been specified; closing this testing effort
does not resolve the execution failure or initiate a new investigation.

**Phil closed this testing effort.** No new testing, investigation, gap chasing,
or campaigns are authorized. Reopening requires new explicit instruction from
Phil. Closure is the human stopping decision, not all-nine verification,
release acceptance, or an E01 fix.

On October 22 Phil separately authorized **only the existing GitHub CI workflows**
for RC5 publication. That bounded cycle does not reopen the failed campaign or
authorize local product suites, new tests, or investigation of E01. Its results
are recorded against the candidate actually run below. Further testing remains
on hold pending Phil's protocol/task-management work and explicit direction.

## RC5 standard CI failures — October 22, 2026

At component commit `676cc4ae2982093551c2b46f66abecd5b93e74cb`,
[Configuration bundles CI](https://github.com/CodeWorksLabs/brand-navigation/actions/runs/39743682475)
passed all 45 cases. In
[Discourse Theme CI](https://github.com/CodeWorksLabs/brand-navigation/actions/runs/39743682761),
lint and all four backend jobs passed. All four system lanes passed 53 examples
each with zero failures. The theme workflow failed overall. All four frontend
targets each ran 49 tests with 42 passes and
the following seven failures:

| Administrator-bundle test                                                          | Observed actual → expected                                  |
| ---------------------------------------------------------------------------------- | ----------------------------------------------------------- |
| imported sizes and additional colors persist and reconcile                         | `#222222` → `#123abc`                                       |
| appearance completion reconciles the submitted snapshot                            | `#222222` → `#111111`                                       |
| core-header color pickers save independently and reset to theme inheritance        | `Assert.deepEqual`; log prints objects as `[object Object]` |
| imported core-header colors reconcile with their pickers                           | `#919191` → `#123abc`                                       |
| bundle completion uses its submitted snapshot and preserves unrelated color drafts | `#0088cc` → `#123456`                                       |
| additional color controls save and reset without changing header sizes             | empty string → `#ABCDEF`                                    |
| older component copies expose and save only settings they define                   | `1` → `5`                                                   |

These failed checks remain unresolved. The logs do not establish their root
cause or seven new product bugs; no additional investigation is authorized.
They also do not erase the earlier scoped browser results. Exact Core
identities and the initial lint-failing run are retained in
[TESTING.md](TESTING.md#october-22-rc5-github-ci). E01 remains separately
unresolved. Publication under Phil's bounded RC5 direction is not an all-green
CI or complete acceptance claim.

## Implemented on main

The accumulated product changes were committed and pushed in
[`dcb01b2`](https://github.com/CodeWorksLabs/brand-navigation/commit/dcb01b28744aec1f06441ddacf713c1f8c407958).
Implementation does not establish that every behavior has been verified.

| Change                          | Implementation status                                                                                                                                                               | Verification status                                                                                                                                                                     |
| ------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Appearance color handling       | Sparse saves submit explicitly edited colors; successful responses reconcile saved colors. Native-color observers and a native-save synchronization extension are also implemented. | Saved values persisted in the named corrected browser sequence. Immediate native-field/picker display staleness remains unresolved; the display additions did not establish an E01 fix. |
| No-op Inherit all               | Empty drafts are cleared when no color change is needed.                                                                                                                            | The exact no-op reset/native-save/different Appearance save/reload regression passed at `238d5ad`.                                                                                      |
| Compact-menu keyboard entry     | The group-only submenu control was made keyboard-focusable.                                                                                                                         | Tested E02 contexts showed no issue; complete eight-context/native-phone coverage was not established.                                                                                  |
| Custom checkbox names and focus | Purpose-specific names and stable setting keys are implemented.                                                                                                                     | Names, keyboard operation, saved state, and the E03 focus correction were verified in Chrome.                                                                                           |
| Long linked-parent mobile label | Mobile-bar item width is bounded and the label can truncate while retaining the caret.                                                                                              | The exact Foundation 390x844 case passed in Chrome.                                                                                                                                     |
| Empty compact menu              | The trigger requires a renderable brand or visible navigation content.                                                                                                              | The exact empty-content case passed in Foundation and Horizon in Chrome.                                                                                                                |
| Label-only icon subscriptions   | Unnecessary subscriptions are avoided for entries that cannot display icons.                                                                                                        | E04's label-only group/child subscription and cleanup case passed on the representative frontend target.                                                                                |

The RC5 release identity is `v1.0.0-rc.5`; its tag and matching GitHub prerelease
identify the published source. The published RC4 tag/release is unchanged.

## What was verified, and its limits

- **Earlier CI:** commit `238d5ad829eb6053e5c2aefc94f495cf5f83791f` passed four
  system-test lanes with 49 examples each and 45 configuration/lint-coverage
  cases. These results apply to that commit and its recorded Core revisions,
  not the later `dcb01b2` main update. No suite was rerun for that update; its
  commit used `[skip ci]` to preserve testing closure.
- **Later representative execution:** the recorded run completed 53 system
  examples with 51 passes and 2 failures, plus 45 frontend tests with 45 passes.
  All 21 installed fields matched that run's candidate. These are historical
  results for that snapshot, not whole-product acceptance or a suite result for
  current main.
- **Focused layout retests in Chrome:** the long-label case passed in Foundation
  at 390x844; the empty compact trigger/popup case passed in Foundation and
  Horizon. Installed mobile SCSS SHA-256:
  `32070f6abc896ed43d700368d5a2269188807f2411709c789a05ec6cf828c9e6`;
  menu connector SHA-256:
  `0cb5d98b66c72315061792eabbdde7c79ac73733b8f2c6337ccc2449a1130447`.
- **E03 in Chrome:** the checkbox-focus correction passed; names, keyboard
  operation and saved state were retained.
- **E02 in Chrome:** tested English/Arabic, light/dark, Foundation/Horizon
  compact keyboard sequences showed no issue in the actual desktop-Chrome
  mobile-view contexts. Complete eight-context and native-phone coverage were
  not established.
- **E04:** the missing label-only subscription case passed on the representative
  frontend target, within that recorded case's scope.

## What remains unresolved

- **E01:** immediate native-field/picker display staleness remains unresolved.
  Saved values persisted in the corrected save/reload sequence, but the cause
  of the stale display remains unknown. E01 is not recorded as fixed or closed.
- **Testing execution:** the process failed to produce a clear overall answer.
  Phil states that this failure will have a resolution. That resolution remains
  open; this record does not assign investigation, testing, or a new campaign.
- **Incomplete coverage:** unrun or unreached checks remain missing coverage,
  not demonstrated product bugs. Unknown coverage is not evidence that the
  product is broken. Detailed limits are retained below.

Original configuration and normal viewport were restored after the focused
browser work. The two layout fixes remained installed in the local test fixture;
no production or published RC4 changes were made. Exact fixtures, hashes and
evidence are in the
[Discourse Work closure record](<C:/CodeProjects/Planning/Procedure Docs/notes/brand-navigation-live-browser-results-20261021.md>).
The implementation commit does not create whole-release acceptance or replace
the original observations and failures retained below.

## Classification meanings

| Classification                 | Meaning                                                                                                     |
| ------------------------------ | ----------------------------------------------------------------------------------------------------------- |
| Confirmed observation          | A saved run demonstrates the symptom. Product root cause may still be unknown.                              |
| Possible product issue         | Product behavior may be wrong, but test assumptions or environment remain plausible explanations.           |
| Created by testing             | A test, runner or procedure introduced the observed obstruction or incomplete evidence.                     |
| Testing limitation             | A test assumption restricts what the result can establish; its causal role may be only strongly supported.  |
| Not reproduced later           | A historical failure did not recur in the later completed runs. This does not prove it can never recur.     |
| Unverified                     | The relevant scenario was unrun or unreached. It is not a demonstrated defect.                              |
| Resolved in observed execution | The correction or existing behavior passed the named check on the recorded target.                          |
| Ghost or unsubstantiated claim | A claimed product defect goes beyond the evidence. The underlying behavior is not thereby declared correct. |

## Current observations and historical failures

| Item                                                                       | Classification                                                                              | Evidence and disposition                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| -------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| E01 immediate display staleness and historical native-save overwrite       | **Stale display confirmed and unresolved; overwrite corrected in the named later sequence** | On the earlier candidate, initial background #112233, text #334455, icon #223344 were verified after reload. Native background #123456 saved, while displayed background remained #112233. Saving only Appearance icon #456789 then lost the native background save; reload confirmed background #112233. After the sparse-save correction, Discourse Work observed the native value persist through the different Appearance save and reload. Immediate native-field/picker staleness remained. Its cause is unresolved; E01 is not closed. |
| E03 original keyboard helper stops after 80 Tab presses                    | **Testing limitation; likely test-caused failure**                                          | The helper had a fixed 80-key limit. The failure screenshot showed focus still in native controls preceding Appearance. This strongly supports premature exhaustion, but the full focus sequence was not recorded. The limit was replaced; the replacement has not been verified.                                                                                                                                                                                                                                                            |
| E03 automated example failed during initial page navigation                | **Historical test/page-settle failure; cause unresolved**                                   | The 10000ms client-settle limit expired with pending scroll events on the admin sidebar. Failure occurred at the initial visit, before the changed Tab helper, initial name/value checks, Space operation and reload assertions. It does not establish broken checkbox behavior. Later manual browser results are recorded separately.                                                                                                                                                                                                       |
| E03 direct browser names, keyboard operation and persistence               | **Confirmed working on the local browser target**                                           | All eleven exact checkbox purpose names were unique. Actual Tab/Shift+Tab reached every checkbox with visible focus; Space correctly toggled checked state and picker enablement. All eleven custom values matched native fields and pickers after save/reload. Six alternating controls then returned to inherited, and all mixed states/values persisted after save/reload. This is a manual result, not a passing execution of the forward-only RSpec helper. The first control took122 forward Tabs from this session's starting focus.  |
| E03 checkbox lost keyboard focus after Space                               | **Historical defect; correction verified in Chrome**                                        | Earlier Space toggles moved activeElement to BODY; original screenshots and keyboard observations are preserved. After the stable-setting-key correction, Discourse Work verified that all eleven Custom checkboxes retained visible focus through Space on/off toggles. Keyboard operation and saved state were retained.                                                                                                                                                                                                                   |
| Chromium launches collide on DevTools port 50062                           | **Confirmed testing-procedure defect; absent in the latest observed run**                   | Failed launches recorded Address already in use and Cannot start http server for devtools. Both requested the same port while the procedure used two workers. After command-scoped CHROME_REMOTE_DEBUGGING_PORT=0, the previously blocked mobile-submenu example passed and no collision was captured. The collision's role in the entire earlier launch timeout was not conclusively established.                                                                                                                                           |
| English minimized topic-title example fails in the interrupted first run   | **Historical failure; not reproduced in later completed runs**                              | It failed in the interrupted seed21569 run, then passed in completed seed44114 and seed10005 runs. Cause remains unknown. It is not a currently reproduced product defect.                                                                                                                                                                                                                                                                                                                                                                   |
| Local administrator-enhancement example fails in the interrupted first run | **Historical failure; not reproduced in later completed runs**                              | It failed in the interrupted first run and passed in both later completed runs. Cause remains unknown.                                                                                                                                                                                                                                                                                                                                                                                                                                       |

For E01, the existing no-op Inherit/native-save regression, intentional
same-field draft/reset example and rejection-before-persistence/recovery example
passed. These results narrow the failing observation; they do not erase it.

The earlier native name checks and frontend checkbox-name/state checks passed.
Direct Chrome checks confirmed E03 keyboard reach, toggling and saved states,
first exposed focus loss, and later verified the focus correction.

## Coverage items without demonstrated defects

| Gap                                                | Classification                                                 | Recorded status                                                                                                                                                                                                                                                                                    |
| -------------------------------------------------- | -------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| E02 Compact-menu keyboard contexts                 | **Partly verified; remaining coverage unestablished**          | Tested English/Arabic, light/dark, Foundation/Horizon compact keyboard sequences showed no issue in the observed desktop-Chrome mobile-view contexts. No complete eight-context or native-phone gate closure is claimed. Remaining coverage is not a demonstrated bug or a new testing assignment. |
| E04 Label-only content and icon subscriptions      | **Resolved verification gap on the representative target**     | The missing label-only group/child subscription and cleanup case passed in both completed frontend runs. No defect was observed in that case.                                                                                                                                                      |
| E05 Installation, updates and restart preservation | **Partly verified; remaining coverage and fixture limitation** | ZIP import and exact 21-field identity passed. Git/update, four-prior-version flows and committed-state application restart/database/uploads preservation were not qualified. Container resume is not that durability proof. No restart or update product defect was demonstrated.                 |
| E06 Copies, removal, reinstall and restoration     | **Unverified coverage**                                        | Dedicated shared/separate-copy isolation and lifecycle procedures were not run. No removal or restoration defect was demonstrated.                                                                                                                                                                 |
| E07 Authorization, CSRF and failure handling       | **Unverified coverage**                                        | Dedicated active authorization, missing/invalid-CSRF and fault procedures were not run. This is not evidence of a security vulnerability.                                                                                                                                                          |
| E08 Genuine zoom, OS chooser and screen readers    | **Unverified or deferred human/native coverage**               | Genuine zoom and OS-chooser procedures were not run. Twelve screen-reader procedures remain deferred. No corresponding product defect was demonstrated.                                                                                                                                            |
| E09 Classic embed, HTTPS and transitions into Core | **Unverified coverage and procedure admission**                | Dedicated procedures were not run. Ordinary embed/Core-feature passes do not establish those specific results. No HTTPS or classic-embed defect was demonstrated.                                                                                                                                  |

The representative runtime evidence was gathered against one exact Discourse
2026.9.0 Core revision and a snapshot that was local and uncommitted at the time.
The later main publication does not turn that evidence into a full-suite result
for current main or establish compatibility for every release, operating system
or browser. Broader coverage remains a limitation rather than an observed
incompatibility.

## Issues created by verification tooling

| Issue                                                                           | Classification                                                         | Disposition                                                                                                                                                                                                                            |
| ------------------------------------------------------------------------------- | ---------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Inherited 600-second whole-suite cutoff                                         | **Confirmed, created by testing**                                      | It interrupted the first system run before completion and left a surviving worker whose closure required later observation. The cutoff was removed; subsequent suites completed. Original incomplete/failure evidence was retained.    |
| Required output could be truncated while the controller still reported success  | **Confirmed verification-harness defect, repaired and exercised**      | The repaired truncation path returned controller98, success=false and retained its block. Later primary suites captured full output. This was a reporting/control defect, not a navigation defect.                                     |
| Capture child could be killed without observed exit or assured durable blocking | **Confirmed verification-harness defect, repaired and exercised**      | The repaired timeout path observed child termination, returned failure and retained the block. Complete primary-job closure was independently observed.                                                                                |
| Old RC4 archive/ledger pins prevented RC5 primary execution                     | **Confirmed procedure/binding defect, corrected for the primary runs** | Revised primary bindings passed source guards and actual installed-field comparisons. HTTPS/chooser admission was not thereby completed.                                                                                               |
| Snapshot aggregate source_bytes is null                                         | **Confirmed reporting defect created during preparation**              | The optional total was not recorded. All 67 per-file sizes/hashes and archive size/hash were verified; the existing runner does not consume that aggregate. It did not make the candidate bytes unknown. The null value was preserved. |

## Ghost claims and expected behavior

The following product-defect claims are **unsubstantiated**, rather than known
product failures:

- That the E03 results prove the checkboxes are unreachable or incorrectly
  named. The first traversal was capped; the latest example stopped before
  traversal. The executed name assertions passed where reached.
- That an unrun E02 or E05–E09 procedure demonstrates a broken feature.
- That the nine acceptance gaps represent nine confirmed product bugs.

The earlier automated stale-picker failures did not establish stored-value loss;
their later save was unreached. The original-candidate direct browser sequence
then demonstrated loss for E01's initially custom-color case. After the
sparse-save correction, saved values persisted in the named corrected sequence.
The separate no-op Inherit/native-save/different Appearance regression also
passed in its earlier run. Neither result closes the remaining immediate
native-field/picker display staleness.

Themes attached to the same component share its code and settings. That is
documented behavior, not a newly observed isolation defect.

## Recorded state and evidence

### E01 implementation follow-up — October 21, 2026

After the direct Chrome reproduction, Brand Navigation changed the
Appearance save to submit only explicitly edited colors. Untouched page values
are omitted even if the page is stale; **Inherit all** still explicitly resets
every defined color. Successful settings responses reconcile saved color
values in the page model. This is intended to prevent the demonstrated
overwrite and display the saved server values after an Appearance save.

Matching payload assertions and a stale-page persistence regression were
prepared. Discourse Work subsequently installed the correction in the existing
local fixture and observed the native value persist through a different
Appearance save and reload. Immediate native-field/picker staleness remained
after the later display corrections. E01 is **unresolved**; its cause is not
established, and no further investigation or retest is queued. Original failure
evidence is preserved.

### Earlier stopped verification state

At that earlier stop, the E01 product edit remained local and uncommitted, with
Brand Navigation's approval to retain it. Subsequent implementation publication
and focused browser outcomes are recorded above. That earlier failing native
case did not establish an E01 fix, and E01 remains unresolved. No new product
edit, test, build or runtime operation was performed to correct this record.

- [Earlier completed verification and evidence](</C:/CodeProjects/Products/Discourse Brand Navigation/rc5-preparation/2026-10-20/execution/approved-fixes-verification/RESULT.md>).
- [Direct Chrome E01 result and evidence](</C:/CodeProjects/Products/Discourse Brand Navigation/rc5-preparation/2026-10-20/execution/e01-navigation-repair/MANUAL-BROWSER-RESULT.md>).
- [Direct Chrome E03 result and evidence](</C:/CodeProjects/Products/Discourse Brand Navigation/rc5-preparation/2026-10-20/execution/e03-manual-browser/RESULT.md>).
- [Earlier named system outcomes](</C:/CodeProjects/Products/Discourse Brand Navigation/rc5-preparation/2026-10-20/execution/approved-fixes-verification/SYSTEM-RESULT.json>).
- [Earlier system failure traces](</C:/CodeProjects/Products/Discourse Brand Navigation/rc5-preparation/2026-10-20/f2-external/host/receipts/rc5-approved-fixes-system-a1/worker.stdout.log:87>).
- [Earlier completed run and interrupted-run history](</C:/CodeProjects/Products/Discourse Brand Navigation/rc5-preparation/2026-10-20/execution/FINAL-RESULT.md>).
- [E01 assertion helper](</C:/CodeProjects/Products/Discourse Brand Navigation/spec/system/brand_navigation_spec.rb:67>).
- [Existing procedure inventory](</C:/CodeProjects/Products/Discourse Brand Navigation/test/rc5-procedures/README.md>).
- [Original host-tool findings](</C:/CodeProjects/Products/Discourse Brand Navigation/rc5-preparation/2026-10-20/repair/TEMP-REVIEW.md>) and [subsequent exercised repairs](</C:/CodeProjects/Products/Discourse Brand Navigation/rc5-preparation/2026-10-20/execution/FINAL-RESULT.md:79>).

The verification campaign is stopped. These classifications do not create a
follow-up work assignment or authorize further execution.
