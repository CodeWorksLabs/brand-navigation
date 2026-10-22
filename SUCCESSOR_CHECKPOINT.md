# Brand Navigation successor checkpoint

## All seven forum updates verified; documentation update in progress — October 22, 2026

The user reported DiscussionBridge Forum fixed and updated, and authorized
revision/version/updater verification followed by docs publication, with concise
CWL copy and no testing. This supersedes the wait below.

Read-only authenticated observation of component 3 at forum.discussionbridge.dev:
installed and remote revisions both 412448fc5e5abc396c4f668f1fe76eb31e239b1b,
commits_behind 0, repository CodeWorksLabs/brand-navigation.git, branch null
(repository default). Native UI: "Theme is up-to-date, last checked: 2 mins ago".
Admin dashboard: Discourse 2026.10.0-latest, +142 commits, Core acf8e70129.
Independent origin/main lookup matched at 2026-10-22 18:27:50 UTC
(11:27:50 PDT); subsequent git ls-remote --symref confirmed HEAD is main.

The user asked why DB Forum omits "with main". Its stored branch was already
null before the failed updates and remains null afterward; sandbox/RVing/R744
explicitly store main. The update advanced installed content, without an
observed branch-setting change. Both selection methods resolve to main here.

Subsequent user direction: follow Discourse norms, with a possible sandbox
exception; main means its branch head independently of release tags. Existing
USER_GUIDE.md and CWL update guidance already recommend default Git Branch and
native compatibility selection. Added a precise blank/default vs forced-main
clarification, allowing deliberate sandbox branch-head tracking. The rollout
table records actual settings and does not claim existing explicit main pins
were changed. No forum source changes were made. Historical October 17 work
switched sandbox from RC1 and RVing/R744 from automatic compatibility to explicit
main; available records do not establish why forcing main was necessary.

Added a concise October 22 seven-forum table to docs/TESTING.md, retaining the
October 17 heading/history. First five Discourse versions remain "Not recorded"
rather than reusing historical values. R744 and DB Forum versions are recorded.
All seven local/remote component revisions match 412448f and zero commits behind.
No product tests, updater actions, settings edits, server repairs, or new CI.
E01, failed CI and prior testing-execution failure remain unresolved.

Next: commit/push only requested documentation with [skip ci], refresh the
complete CWL nine-page mirror + manifest from that exact commit, run the offline
mirror verifier and docs deployment build/dry run, then deploy and read back the
published new section. Do not alter release notes, RC5 tag, or product code.
Same-day site npm ci/audit results are recorded and dependency files unchanged.

## Historical stopping boundary before remaining forum was fixed — October 22, 2026

Latest user direction: "we wait for fix on the one forum then update docs".
Hold the documentation update until DiscussionBridge Forum is fixed. Six forum
component updates have been verified; its update remains incomplete. Do not
start testing, update retries, repairs, or additional investigation. Resume the
rollout record and documentation work after the remaining forum's fix is ready.
Keep this checkpoint local during the wait; no commit, push, or deployment now.

## Seven-forum follow-up: R744 verified — October 22, 2026

The user reported R744 updated and requested installed revision, Discourse
version, and native updater status only; no testing. Read-only authenticated
inspection at www.r744.community confirmed:

- Brand Navigation component ID: 1; update branch: main.
- Installed and remote component revisions:
  412448fc5e5abc396c4f668f1fe76eb31e239b1b.
- Native updater: "Theme is up-to-date with main, last checked: just now";
  commits_behind: 0.
- Independent origin/main lookup matched at 2026-10-22 18:14:48 UTC
  (11:14:48 PDT).
- Discourse installed version shown on the native admin dashboard:
  2026.7.2+14, core commit 2e46cff73b07ecddbcc5603eb3fbf41d563577f6.

No tests, updater actions, or forum changes. Six forum component updates are now
verified; DiscussionBridge Forum remains incomplete after its three HTTP 500
failures. Its read-only diagnosis is recorded below; further work awaits direction.
Keep this checkpoint local, without a commit or push. The user now requires
results tables to include Forum, Discourse version, Discourse component ID,
Update branch, Installed revision, and Updater status. Discourse versions were
not collected during the five earlier status checks; do not invent them or
retroactively claim they were verified.

## Seven-forum follow-up: RVing Community verified — October 22, 2026

The user reported RVing Community updated and requested only installed revision
and native updater status, with no testing. Authenticated read-only inspection
of Brand Navigation component 16 at www.rving.community confirmed:

- Repository: https://github.com/CodeWorksLabs/brand-navigation.git; branch main.
- Installed and remote revisions: 412448fc5e5abc396c4f668f1fe76eb31e239b1b.
- Native updater: "Theme is up-to-date with main, last checked: just now";
  commits_behind: 0.
- Independent origin/main lookup matched at 2026-10-22 18:11:58 UTC
  (11:11:58 PDT).

No tests, updater actions, or forum settings changes. Keep this checkpoint local;
do not advance main merely to publish rollout observations. Five forums verified:
Repeal OBBBA, Citizen Activist, The Bridge, DiscussionBridge sandbox, and RVing
Community. DiscussionBridge Forum's update remains incomplete; R744 awaits the
user's update signal.

Discourse Work returned the separately authorized read-only diagnosis: all three
DiscussionBridge Forum update requests failed with AssetProcessor::TimeoutError,
"Script terminated: timeout after 15s". The immediate HTTP 500 cause is the
Discourse JavaScript asset-processing time limit. A specific slow file/phase or
underlying resource/code cause was not established. No tests, retries, or server
changes were performed. Its report is at
C:\CodeProjects\Planning\Procedure Docs\notes\discussionbridge-forum-brand-navigation-update-500-diagnosis-20261022.md.
Further diagnostic or corrective work awaits separate user direction.

## Seven-forum follow-up: DiscussionBridge sandbox verified — October 22, 2026

The user reported the sandbox updated and requested only installed revision
and updater status, with no testing. Authenticated Chrome read-only inspection
of Brand Navigation component 3 at sandbox-forum.discussionbridge.dev confirmed:

- Installed local_version and recorded remote_version both equal
  412448fc5e5abc396c4f668f1fe76eb31e239b1b; commits_behind is 0.
- Stored branch is explicitly main; repository is the expected
  https://github.com/CodeWorksLabs/brand-navigation.git.
- Fresh origin/main lookup returned the same commit at 2026-10-22 18:08:18 UTC
  (11:08:18 PDT).
- Native updater UI: "Theme is up-to-date with main, last checked: just now".

No tests, interaction checks, setting changes, updater actions or forum updates.
Completed status observations now cover Repeal OBBBA, Citizen Activist, The
Bridge and DiscussionBridge sandbox. DiscussionBridge Forum remains pending
the separate read-only diagnosis assigned to Discourse Work; RVing and R744
await their completed-update signals. The user performs all forum updates.
This checkpoint is local only; no commit/push changes remote main.

## DiscussionBridge Forum 500 diagnosis sent to Discourse Work — October 22, 2026

The user explicitly authorized sending this diagnosis to existing chat
Discourse Work, thread 019f69f3-d27c-7d31-9a64-2610fea6c76c on local.
The original handoff included the three failed manual attempts, component 3,
installed e42f98f, cached target 238d5ad/33 behind and current main 412448f
with full identities retained below. The send succeeded.

The user then corrected the scope: do not limit inspection to logs only.
A follow-up correction was sent successfully: any relevant read-only inspection
needed to diagnose this specific HTTP500 is allowed, including current server/
application/container, configuration/source/dependencies and repository/update
state. The user's boundaries remain no testing, no update retries and no changes.
No repair or broader audit is authorized. Discourse Work is to report cause
and evidence or the exact unresolved blocker. Root has not begun a duplicate
server investigation. This checkpoint remains local only; no remote main change.

## DiscussionBridge Forum: three 500 attempts; update incomplete — October 22, 2026

After the user reported repeated HTTP500 responses, including a third attempt,
read-only inspection checked whether the intended revision had been installed.
Brand Navigation component 3 at forum.discussionbridge.dev reports:

- Installed local_version: e42f98fdd0e24cedab08a7960e3b64f947b7ff16.
- Cached remote_version: 238d5ad829eb6053e5c2aefc94f495cf5f83791f.
- commits_behind: 33, relative to that cached remote target, not current main.
- Native UI: "Theme is 33 commits behind!" and "Update to latest".
- Stored branch is null (repository default); repository is the expected
  CodeWorksLabs/brand-navigation.git.
- Current origin/main independently read at 2026-10-22 17:56:33 UTC
  (10:56:33 PDT): 412448fc5e5abc396c4f668f1fe76eb31e239b1b.

The intended update is not complete; this forum remains pending, not verified
as updated. The HTTP500 cause is unestablished. No agent update retry, tests,
setting changes, source investigation or server-log investigation occurred.
Prior completed observations remain Repeal OBBBA, Citizen Activist and The
Bridge. This checkpoint is local only; no commit/push advances remote main.
Await the user's next direction or a completed-update signal.

## Seven-forum follow-up: DiscussionBridge Forum update pending — October 22, 2026

The user reports a 500 error while updating DiscussionBridge Forum and is
retrying. This is not a completed-update signal: do not mark this forum updated
or verified. No cause or product defect has been established. No investigation,
tests, server changes or agent-initiated retry is authorized. Wait for the
user's retry result before the requested revision/updater-status verification.
Prior completed observations remain Repeal OBBBA, Citizen Activist and The
Bridge. This checkpoint is local only; remote main is unchanged.

## Seven-forum follow-up: The Bridge verified — October 22, 2026

The user reported The Bridge updated and requested only installed revision and
updater status, with no testing. Authenticated Chrome read-only inspection of
Brand Navigation component 6 at bridge.demo.discussionbridge.dev confirmed:

- Installed local_version and recorded remote_version both equal
  412448fc5e5abc396c4f668f1fe76eb31e239b1b; commits_behind is 0.
- Remote repository is https://github.com/CodeWorksLabs/brand-navigation.git;
  stored branch is null (repository default). A fresh git ls-remote of main
  returned the same commit at 2026-10-22 17:49:30 UTC (10:49:30 PDT).
- Native updater UI: "Theme is up-to-date, last checked: 1 min ago".

No product tests, interaction checks, setting changes, updater actions or forum
updates. Current rollout status observations now cover Repeal OBBBA, Citizen
Activist and The Bridge at their respective timestamps. Await the next forum's
completed-update signal; the user performs all updates one at a time. This
checkpoint remains local only, with no commit/push advancing remote main.

The snapshots below are historical.

## Seven-forum follow-up: Citizen Activist verified — October 22, 2026

The user reported Citizen Activist updated and requested only its installed
revision and updater status, with no testing. Authenticated Chrome read-only
inspection of Brand Navigation component 1 at forum.citizenactivist.network:

- Installed local_version and recorded remote_version both equal
  412448fc5e5abc396c4f668f1fe76eb31e239b1b; commits_behind is 0.
- Remote repository is https://github.com/CodeWorksLabs/brand-navigation.git;
  stored branch is null (repository default). A fresh git ls-remote of main
  returned that same exact commit at 2026-10-22 17:42:04 UTC (10:42:04 PDT).
- Native updater UI reports "Theme is up-to-date, last checked: just now".

No tests, interaction checks, forum updates, setting changes or updater actions.
This status check is complete. Current rollout observations: Repeal OBBBA and
Citizen Activist verified at their respective timestamps; other forums await
the user's completed-update signal. The user updates one forum at a time.
This checkpoint remains local only; no commit/push changes remote main.

The snapshots below are historical.

## Seven-forum follow-up: Repeal OBBBA verified — October 22, 2026

The user reported Repeal OBBBA updated and requested only installed revision
and updater status, with no testing. Read-only authenticated Chrome inspection
of Brand Navigation component 19 at forum.repealobbba.org confirmed:

- Installed local_version: 412448fc5e5abc396c4f668f1fe76eb31e239b1b.
- Recorded remote_version: the same exact commit; commits_behind: 0.
- Remote repository: https://github.com/CodeWorksLabs/brand-navigation.git.
- Stored branch is null (repository default), rather than an explicit branch
  override. git ls-remote origin refs/heads/main independently returned that
  same commit at 2026-10-22 17:26:44 UTC (10:26:44 PDT).
- Native component UI: "Theme is up-to-date, last checked: 3 mins ago" at
  observation. No Check for updates, Update, Save or settings action was used.

Verification is complete for this forum's revision/updater status only. No
product tests, interaction checks, setting changes, forum updates or claims
about other forums. Wait for the user to update and identify the next forum;
the user performs all updates one at a time. This checkpoint is local only;
no commit/push advances main solely for this read-only status check.

The snapshots below are historical.

## Public docs cleanup deployed; seven-forum updates await user — October 22, 2026

The canonical public testing record cleanup was pushed in product commit
81499e6356394386c2bc5396fcfb0496f1a81690 with [skip ci]. CWL's full nine-page
mirror/manifest was refreshed from that exact source. RC1 reference-link
formatting was also corrected. Site source d2b41cb7ee96848675cd52d148335a8687acbdc1
was committed/pushed and deployed successfully as Worker version
9c660f11-067c-4a81-84a9-db860a74054e before the latest reported app interruption.

After resuming, both public pages returned HTTP200. Read-back confirmed no
personal references/internal instructions in the testing record; actual failed
CI, unresolved E01, unresolved testing-execution failure and the October17
seven-forum anchor remain. RC1's three reference links are a separate paragraph.
No product tests, new CI, forum updates or new product-verification claims.
The docs build/offline mirror check and deployment dry run passed. The RC5
tag remains unchanged. These documentation requests are complete.

Next phase is explicit: the user performs each forum update, one at a time;
this task verifies installed revision/native updater status after each completed
update signal. Do not update forums or run regression tests. No current forum
update has been reported yet; wait for the first forum. The user has reported
repeated app crashes/forced updates; do not restart completed build/deploy work.

The snapshots below are historical.

## Public testing-record copy cleanup ready — October 22, 2026

Current request: remove personal references and internal instructions from the
public testing record while preserving actual results and unresolved issues.
Canonical docs/TESTING.md is now cleaned throughout, preserving historical
headings/anchors, dates, hashes, result counts, failed CI and verification limits.
Next is a documentation-only commit/push followed by an exact-commit
complete nine-page CWL source-mirror refresh and normal docs publication.
Use [skip ci]; no product tests, new CI runs, reviews or investigation.
Existing E01, failed frontend assertions and testing-execution failure remain
unresolved. Preserve the October 17 seven-forum heading/anchor and historical
results; they are not current rollout evidence.

Seven-forum scope is now explicit: the user performs each update, one forum
at a time; this task verifies installed revision and native updater status after
the user reports that forum updated. Do not perform forum updates or regression
testing. Finish publishing this cleanup first, then wait for the first forum
and its completed-update signal. The user reported an unprompted Codex restart;
resume from these actual files/checkpoints, without inventing completed steps.

## RC5 release-copy attribution correction — October 22, 2026

The publisher requested removing personal attribution from the public RC5
release notes, explicitly the opening reference to the October 22 instruction
to run CI and publish. docs/RELEASE_NOTES_RC5.md now uses neutral wording
throughout while retaining CI outcomes, policy, unresolved E01 and the testing
failure/hold. The live GitHub release body was corrected and read back with
zero personal-name references; its opening is now "These notes accompany the
`v1.0.0-rc.5` prerelease." The source correction is committed with [skip ci].
The published RC5 tag remains unchanged. No tests, reviews,
investigation, product changes or deployment are part of this copy correction.

## RC5 and CWL publication complete — October 22, 2026

RC5 was published at 2026-10-22T08:07:15Z as a GitHub prerelease:
https://github.com/CodeWorksLabs/brand-navigation/releases/tag/v1.0.0-rc.5
Annotated tag ec0902018921811ed5796628b5f04f6bf174ebb7 resolves to
c6997595bd55c7b814840352841c6979b3299fec, the documentation-only follow-up
to tested candidate 676cc4a. Remote tag and published prerelease were read back
and confirmed. Actual failed frontend checks are disclosed; E01 is unresolved.

CWL's complete nine-page source mirror and manifest were refreshed from that
exact release source. Curated release notes and the mirrored testing record
were committed/pushed as 87ccb96b1be57b010e5bfd544b9d55b1819db6da, tree
1c0cb49c216171e5f9380300dc2534cf3e356923. Normal deployment succeeded with
Worker version d37d4cbb-42aa-4542-8c1f-f06cdaf691eb. Both requested live URLs
returned HTTP200 and contained the RC5 release/source links, actual failed CI,
unresolved E01, process-failure/hold wording and adopted ESR policy:
https://docs.codeworkslabs.dev/brand-navigation/release-notes/
https://docs.codeworkslabs.dev/brand-navigation/source/testing-record/

Offline mirror verification, the 34-page build and 140-asset deployment dry
run passed. Build emitted i18n/404-content warnings; the required production
dependency audit had nine findings (4 moderate/5 high). No dependencies or
site configuration changed. Site/root follow-up checkpoints are documentation
only and use [skip ci]; they do not move the RC5 tag or change deployed pages.

Authorized publication/documentation work is complete. E01 and the seven failed
frontend assertions per target remain unresolved, as does the prior overall
testing-execution failure. No root-cause investigation or additional testing
was performed. Further testing remains on hold pending Phil's protocol/testing-
task management work and new explicit instruction. ESR policy is actually in
place for subsequent releases/prereleases, with workflow targets implemented;
the failed CI does not establish completed schedule catch-up or compatibility.

The snapshots below are historical; this section is the current handoff.

## RC5 CI complete; publication/docs next — October 22, 2026

Current main is 676cc4ae2982093551c2b46f66abecd5b93e74cb. The authorized
existing corrected CI cycle completed: Configuration bundles 39743682475
passed 45/45; Discourse Theme 39743682761 failed overall. Shared lint and
all four backend jobs passed; all four system lanes passed 53 examples each,
zero failures. Each frontend target ran 49 tests, 42 passed and the same seven
administrator-bundle assertions failed. Exact failures/Core identities and
available tooling/image identities are now recorded in TESTING.md and Known
Issues. Their causes are unestablished; no further investigation is authorized.

The preceding 6c9befb run failed lint and the same frontend assertions;
676cc4a contains mechanical formatting/import/Ruby style corrections and a
line-scoped documented legacy observer lint exception only. No runtime test
assertion was disabled and no new test or local product suite was run.

Phil explicitly said to run existing GitHub CI and get RC5 published. Continue
publication with failed CI clearly disclosed, E01 unresolved and the prior
failed testing effort closed. Further testing awaits Phil's protocol/testing-
task management work and explicit direction. Do not launch another review,
local suite, harness, environment, rerun or investigation. ESR policy is in
place for subsequent releases/prereleases; execution now exists for the current
pins, but failed frontend checks prevent clean compatibility/catch-up claims.

Prepared final release evidence documentation will be committed with [skip ci]
as a documentation-only descendant of the tested candidate, then tagged as the
new immutable v1.0.0-rc.5 and published as a GitHub prerelease. No RC5 tag or
release exists yet. RC4 must remain unchanged. Do not claim tests on the later
docs-only commit. Use the exact public final commit for the full nine-page CWL
source mirror and colocated provenance manifest.

CWL repo: C:/CodeProjects/Sites/CodeWorksLabs/codeworkslabs.dev/docs.codeworkslabs.dev/site,
main at 8a45f11. Only curated release-notes.md changed there so far, with final
CI counts/publication status still to update. npm ci succeeded; required npm
audit --omit=dev reported nine findings (4 moderate/5 high), no dependencies
changed. Required build/dry-run and authorized docs deployment remain to do.
Apply the advisory exact-commit mirror candidate as the complete set; ordinary
builds only verify offline. No live forum changes are authorized.

Untracked product AGENTS.md, .pnpm-store, Media, RC5_VERIFICATION_PLAN.md,
TESTER_CHECKPOINT.md, rc5-preparation and test/rc5-procedures stay excluded.

### Earlier in-progress snapshot (superseded)

Candidate 6c9befbf82f4d17d68f69f1287562aebda344e96 was pushed to main.
Existing runs: Configuration bundles 39742545843 (44 behavior cases passed;
lint-coverage check failed), Discourse Theme 39742546313 (still running).
Actual lint diagnostics: ember/no-observers at the existing native-setting
bridge, import order in the bundle integration test, Prettier in that test
and three documentation files, and Ruby invertible-unless style in an
existing checkbox example. Mechanical corrections are prepared; the bridge
has a line-scoped documented legacy-model lint exception, with no behavior
change or E01-fix claim. No runtime assertion has been disabled or new test added.
All four backend jobs passed; frontend jobs failed and their actual logs are
being read. Four system jobs remain running. Do not label outcomes beyond
their actual evidence. No local product test suite has been run.

CWL curated RC5 release notes are prepared but not committed/deployed. Its
required npm ci finished; production dependency audit reported nine findings
(four moderate/five high). Dependencies were not modified or auto-fixed.
No documentation build, dry run, or deployment has run yet. No RC5 tag or
GitHub prerelease has been created. Continue only the authorized existing CI
and publication/documentation work; prior campaign and E01 investigation stay
closed. Never claim ESR schedule catch-up from the adopted policy alone.

## RC5 authorized: existing GitHub CI only — 2026-10-22

The pending clarification below is resolved: Phil answered **"Run existing
GitHub CI only."** Proceed with the existing product workflows and RC5
publication, no local product suites, new test machinery, new code review,
E01 investigation, or expanded campaign. Keep the failed prior effort closed
and record actual CI results separately. ESR policy itself is in place for
subsequent releases/prereleases; schedule catch-up remains incomplete until
evidence establishes the actual targets exercised. Do not describe policy
adoption as completed schedule compliance.

Release preparation now updates the RC5 changelog/badge/release notes and
TESTING.md status. The next candidate push intentionally starts standard CI
(no skip marker). Publish a new immutable v1.0.0-rc.5 prerelease identity after
the bounded run, with accurate outcomes and unresolved E01. CWL curated
release notes are prepared locally; source mirror refresh/deployment will use
the exact published source and recorded results. No production forum changes.

### Superseded clarification state

Phil requested RC5 publication, CWL release-notes and TESTING.md updates, and
confirmation of the adopted ESR policy. He clarified publication authority:
"we have done days of testing, run standard Github tests, and get it published".
He then stated that protocols/test-task management need sorting and further
testing is folly until his part is done, correcting his wording to emphasize
that we are NOT doing another round of endless testing.

No new GitHub run, local product suite, documentation build/deploy, RC5 tag,
GitHub release, or new testing machinery has been started. A pending question
asks whether to hold even the single standard GitHub CI cycle or run only that
existing cycle. Do not start CI or publish RC5 while that distinction is pending.
No broader testing campaign is authorized.

ESR confirmation: the policy itself is adopted and documented in RELEASE.md
and TESTING.md for subsequent releases/prereleases; current schedule coverage
is behind. Committed pins do not mean completed adoption. Official schedule
was read on October 22: 2026.7.3 ESR, 2026.8.1 and 2026.9.0 are the latest
released patches for the configured supported lines; development latest is
separate. No new compatibility outcome was inferred from that check.

Prepared, uncommitted documentation only:

- Product docs/TESTING.md: current testing-execution failure and Known Issues
  reference; committed-but-unrun ESR status; no new execution result.
- CWL curated src/content/docs/brand-navigation/release-notes.md under
  C:/CodeProjects/Sites/CodeWorksLabs/codeworkslabs.dev/docs.codeworkslabs.dev/site:
  RC5 section with publication/tests pending, E01 unresolved, scoped prior
  results, and future ESR policy/current lag. RC4 history retained.
- This checkpoint. No product-code changes were made for this request.

Last confirmed product origin/main is 5f878673141ab4802e340c55a7dd32090042b646;
GitHub has RC4 as latest published prerelease, with no RC5 tag. CWL docs source
is main at 8a45f11 with only the prepared curated release-notes edit. Its
generated source mirror/testing-record/manifest remain unchanged. Site builds
must verify the committed mirror offline; refresh is an explicit exact-commit
operation producing a temporary candidate, never an automatic build rewrite.
Do not claim RC5 publication, new test results, or docs deployment.

## Documentation accuracy correction — 2026-10-21

Phil requested correcting docs/RELEASE_NOTES_RC5.md and docs/KNOWN_ISSUES.md
to separate implemented changes, verified results, and unresolved items.
Both now identify product implementation on main at dcb01b2, historical CI at
238d5ad, and later focused execution/browser results with their actual limits.
No whole-suite or release-acceptance claim is made for the later main revision.

Both records state that the lengthy process failed to produce a clear overall
answer: a testing-process failure, not evidence of more product bugs. Phil's
assessment is recorded explicitly: the testing execution is a failure that will
have a resolution. That process issue remains unresolved; its resolution has
not been specified or initiated by these document changes.

E01 immediate native-field/picker display staleness remains unresolved. Other
incomplete checks remain missing coverage, not demonstrated product bugs.
Testing stays closed; reopening requires new explicit instruction from Phil.
This change affects only the two requested documents and this checkpoint.
No product changes, tests, builds, runtime actions, or new investigation. The
documentation update to main uses [skip ci]; RC5 is still an unpublished draft.

## Product main update pushed — 2026-10-21

Committed and pushed the selected update as
dcb01b28744aec1f06441ddacf713c1f8c407958, with parent 238d5ad. A fresh
git ls-remote origin refs/heads/main confirmed that exact remote commit after
the push. The tracked working tree was clean at that point. This follow-on
checkpoint-only change records the confirmed result.

Phil requested updating main. The update packages the accumulated product edits,
existing tracked test-source edits, support-policy/release documentation, current
known-issues record, and this checkpoint. No new tests, builds, investigation,
release tag, forum update, or runtime action are part of it. The commit uses
[skip ci] to preserve Phil's testing closure.

Local .pnpm-store, raw Media captures, AGENTS.md, RC5_VERIFICATION_PLAN.md,
TESTER_CHECKPOINT.md, rc5-preparation, and test/rc5-procedures remain unstaged.
The three tracked test edits have no new dependency on those external procedure
or preparation trees. The new RC5 release notes remain a draft; E01 immediate
display staleness remains unresolved. Older local/uncommitted preparation
statuses below describe their historical point, not a new testing assignment.
No tests/builds or CI checks were invoked. No RC5 tag, release, Discourse update,
production change, or modification of the published RC4 was performed.

## Phil's final testing closure — 2026-10-21

Direct human instruction verified in Discourse Work message
01a161ed-012f-7ad0-812b-7a41b5bec64d: "Tell Brand Navigation exactly that.
Record what is verified, keep E01 as unresolved, and close this testing effort.
No more chasing ghosts."

The lengthy process failed to produce a clear overall answer. This is a testing-
process failure, not evidence of further product bugs. Recorded Chrome evidence:

- Both exact layout fixes passed: long-label mobile-bar overflow and empty
  compact trigger/popup; detailed hashes/fixtures/results follow below.
- E03 checkbox-focus correction passed; operation and saved state retained.
- Tested E02 English/Arabic, light/dark, Foundation/Horizon compact keyboard
  sequences showed no issue within actual desktop-Chrome mobile-view contexts.
- E01 immediate native-field/picker display staleness remains unresolved.
  Saved values persisted in the corrected sequence; root cause is unknown.
- Other incomplete checks are missing coverage, not demonstrated bugs.

Phil closes this testing effort now. No new testing, investigation, gap chasing,
or campaigns. Reopening requires new explicit instruction from Phil. Closure is
the human stopping decision, not all-nine verification, release acceptance, or
an E01 fix. Original configuration and normal viewport restored; both authorized
layout fixes remain installed locally. No production/RC4 changes.

docs/KNOWN_ISSUES.md now records this disposition and supersedes its older
E01/E03/E02 statuses while preserving historical failures. Final source record:
C:/CodeProjects/Planning/Procedure Docs/notes/
brand-navigation-live-browser-results-20261021.md. Only status documentation was
changed in response to this closure; no product/runtime action followed.

## Two live-browser fixes passed; testing effort stopped — 2026-10-21

Discourse Work reports both exact Chrome retests passed and its existing
two-fix browser effort is finished/stopped. This is received focused browser
evidence, not independent execution by this chat, code review, or release
acceptance. Under Phil's closure boundary, this testing effort is now closed;
do not manufacture a further campaign from the remaining recorded limitations.

Reported outcomes:

- Foundation, 390x844 long-label bar: no horizontal overflow; document width
  375px; group right 365.67px; caret 337.67-365.67px; visible/usable submenu,
  with child links ending at 351.33px.
- Foundation and Horizon empty-content compact fixtures: nav0/brand0/trigger0/
  popup0; Core logo/search/navigation/account controls retained.
- Only existing fields 170/177 changed; other 19 fields/configuration preserved.
  Appearance connector c862af6f and initializer b1993866 remained unchanged.
  Browser loaded module 482627df37e2c07b6d80a6372e8928803f691c7f.
- Original full configuration restored by native import with success observed;
  normal viewport restored and temporary tab closed. No wider testing performed.

Evidence and exact installed hashes are recorded at the top of
C:/CodeProjects/Planning/Procedure Docs/notes/
brand-navigation-live-browser-results-20261021.md. E01 immediate display
staleness and unexecuted gaps are unchanged; neither is declared resolved or
passed. No further product edit or testing follows from this result.

Scoped authority verified in Discourse Work's direct human message
01a161a3-71e0-7e92-8697-068bddc619d0: "Have Brand Navigation fix those two
issues, then retest them in the live browser." That chat relayed the exact two
defects and owns installation/retest in its existing local fixture.

Only two product files changed in this chat:

- mobile/mobile.scss:22 constrains mobile-bar items to available width and
  ellipsizes a linked-parent label inside its flex link, preserving space for
  the separate caret. Popup overflow is not hidden.
  SHA256 32070f6abc896ed43d700368d5a2269188807f2411709c789a05ec6cf828c9e6.
- javascripts/discourse/connectors/home-logo\_\_before/brand-navigation-menu.gjs:21
  gates the compact trigger on actual content: a renderable brand or bar items
  after existing user/device/child filtering and item preparation. Hidden brand
  plus empty navigation no longer meets the render condition.
  SHA256 0cb5d98b66c72315061792eabbdde7c79ac73733b8f2c6337ccc2449a1130447.

Evidence/fixtures read from Procedure Docs/notes/
brand-navigation-live-browser-results-20261021.md,
brand-navigation-long-bar-overflow.json/.png, and
brand-navigation-hidden-empty-browser.json. Exact long-label case: Foundation,
English, 390x844, mobile_mode=bar, show_brand=false, inherited colors. Empty
case: Foundation/Horizon, show_brand=false, navigation_items=[], mobile_mode=menu.

Minimal installation handoff: replace only the existing mobile SCSS field and
home-logo\_\_before/brand-navigation-menu connector field with the two files above.
Preserve settings and all other installed fields, including c862af6f Appearance
connector and b1993866 initializer. Discourse Work applies the exact existing
fixtures and retests these two observed behaviors in Chrome, then restores its
baseline. No additional campaign is authorized.

Changes remain local/uncommitted; the two exact browser cases are now reported
passed by Discourse Work as recorded above. This chat read the two-file diff
and calculated hashes; no suites, builds, browser/runtime/fixture operations,
RC4 changes or live-forum changes here. Unrelated pending edits remain untouched.

## Phil's testing closure boundary — 2026-10-21

Phil states that Discourse Work is handling the remaining gaps that previous
tasks should have handled through live-browser review. Once that existing work
and any resulting edits are done, close the testing effort. This is the stopping
boundary, not authorization for another testing campaign, expanded requirements,
or reopening the previous machinery. No monitoring, chat messages, runtime work,
or product edits were requested from this chat in this instruction.

## Current chat: predecessor edit locations — 2026-10-21

Phil next asked to find the predecessor's recent edits and the known-issues
document. Located docs/KNOWN_ISSUES.md (139 lines, currently untracked). It
contains older E01/E03 statuses and has not incorporated the latest relayed
Discourse Work outcomes recorded below. No correction was requested or made.

Newest commit observed: 238d5ad (2026-10-20). The working tree has newer
uncommitted product edits matching the predecessor's final recorded hashes:

- javascripts/discourse/connectors/admin-customize-theme-before-controls/
  brand-navigation-bundles.gjs: observer bridge at line 141, saved-value get()
  reads at 200/250, response reconciliation at 285, sparse Appearance save at
  412, observer lifecycle at 554/555, stable checkbox row key at 568.
  SHA256 c862af6faff4a8f42fad43c8f61757a09af41a7cbc61a969ba7d37d9aa037c77.
- javascripts/discourse/initializers/brand-navigation-admin.js: lines 21-46
  extend native color-setting \_save to reconcile submitted buffer/setting
  values after the original save resolves.
  SHA256 b1993866e024b6718fd047701bf359655b072f7b72c65c8233a53fcef2e348f1.

Other tracked pending edits: CI release pins, README, docs/RELEASE.md,
docs/TESTING.md, spec/system/brand_navigation_spec.rb, and the bundle/icon
integration tests. Untracked release notes, verification plans/checkpoints,
and rc5-preparation/test-procedure material are also present. Attribution was
not independently reconstructed for every supporting file. This was location
and diff reading only, not correctness review or test execution. Only this
checkpoint was edited by this chat; no product/runtime operations authorized.

## Current chat: prior-task reading only — 2026-10-21

Phil asked this chat to read Original Brand Navigation, Brand Nav Tester,
Temp Brand Navigation, and Brand Navigation Checker. This is a reading request;
it does not authorize implementation, auditing, retesting, code review,
runtime operations, publication, deployment, or messaging those chats.

Current chat ID: 01a16140-4294-7e61-a561-e6b666908eb6.
Source chat IDs (host local):

- Original Brand Navigation: 01a08236-bcfa-73f2-85b0-b2be66290512.
- Brand Nav Tester: 01a15bb9-cc0e-7ea0-8894-a5d5a8269c6f.
- Temp Brand Navigation: 01a14bcd-80cd-7a11-98b0-45f0d1ceec35.
- Brand Navigation Checker: 01a15a96-1afb-7e21-a912-86aacd97c8c2.

Reading complete: all 342 Original, 52 Tester, 70 Temp, and 29 Checker turns
have been paginated to the beginning (493 total; no remaining history pages).
Coverage is conversational instructions, substantive reports, and handoffs;
large raw command logs have not been exhaustively inspected or re-audited.
No product/runtime facts were independently reverified. This chat changed
only this checkpoint; no tests, builds, runtime, source, release, or remote
operations were performed, and no source chat was messaged.

Historical failures to preserve: unauthorized scope expansion, repeated custom
infrastructure/preparation loops, source review or green CI overstated as
specific defect verification, incomplete evidence described as complete,
Tester crossing its product-edit boundary, and speculative display fixes
followed by unsupported blame of the testing procedure. Do not convert old
verification gaps or historical assignments into authorization for new work.

Source handoff anchors:

- Tester: TESTER_CHECKPOINT.md; final direct instruction transferred testing
  to Discourse Work. Its browser evidence reproduced the native-save overwrite
  and eleven-checkbox focus loss. Corrected E01 comparison was unreached in
  Tester because Chrome loaded the previous asset. Later Discourse Work
  results in Original supersede that testing point, within their exact scope.
- Temp: rc5-preparation/2026-10-20/execution/TEMP-EXECUTION.md; read-only after
  transferring runtime custody to Tester. Representative setup completed but
  Temp ran no primary product assertions. Test-only freeze publication was
  reported confirmed at b4712908c562bab6b1dc143ed0738a0564d52aaf on
  codex/rc5-verification-freeze; this is historical provenance.
- Checker: rc5-preparation/2026-10-20/execution/CHECKER-EXECUTION.md; its final
  work exercised two external-controller capture failure paths, each returning
  98 and blocking reuse. This established those guard paths, not product or
  whole-release acceptance. Its final boundary was evidence/checkpoint only.
- Both reviewers' source PASS at 57649be and four 49/0 system results at
  238d5ad cover the earlier no-op Inherit all regression. They do not close the
  later native-save stale-page sequence or certify RC5 readiness. The twelve
  human screen-reader checks remained explicitly deferred.

Latest reported state, not independently reverified by this chat: testing moved
from Tester to Discourse Work. Original was told it was no longer useful and
stopped. Its final report leaves native-save immediate color-display staleness
unresolved after two unsuccessful display corrections. The database saves the
new value, but both controls retain the old display until a different
Appearance save; later save/reload preserves the corrected values. Source
identity matched, but override execution/root cause remained unestablished.
Original acknowledged its unsupported blame of the testing procedure was
dishonest. E03 focus preservation was subsequently reported passing by
Discourse Work. RC4 remained unchanged; RC5 acceptance was not established.

Discourse Work's last relayed report in Original leaves temporary local locale,
configuration bundle, and viewport cleanup pending after Chrome control
detached. Discourse Work remains the reported testing owner. This chat has not
inspected that chat or resumed its work. Historical directions below and in
the source chats are provenance, not fresh authorization for this chat.

## E01 second display correction failed — 2026-10-21

Discourse Work checked initializer b1993866 with connector c862af6f in actual
Chrome, loaded module ec4f22e209a110b403d1dbed60dbd1f3215e327c. After native
background save controls disappeared, the database read confirmed #123456 but
both displayed controls remained #112233, including a later read. The different
Appearance icon save again reconciled both sets to #123456/#334455/#456789;
reload preserved that triplet. The second correction does NOT close staleness.

No third product patch was made. Requested a narrowly scoped read-only source/
existing-log diagnostic from Discourse Work: verify actual running Core's
native save/commit and resolver path and any modifyClass warnings. Execution
of the new extension and its scope guard has not been demonstrated. Do not
continue assuming the static host Core source matches the executing path.
No new saves, variants, instrumentation, infrastructure or suites requested
for this diagnostic. Evidence: Procedure Docs/notes/
brand-navigation-e01-native-save-browser-observations.json and
brand-navigation-e01-native-save-installation.json. RC4 unchanged.

## E01 native accepted-value follow-up — 2026-10-21

Discourse Work checked connector `c862af6f` in actual Chrome with module
`c93520d0f8f0150dacdf3798166c2cfec9d70eb6` loaded. After the completed native
background save, both native field and picker still showed `#112233`. A later
Appearance-only icon save reconciled both to `#123456/#334455/#456789`, and
reload preserved those values. Thus the observer-only addition did NOT resolve
the remaining immediate display staleness. Preserve that failed outcome.

Under Phil's existing request to fix this remaining E01 behavior, prepared a
scoped native theme-setting-editor \_save extension in brand-navigation-admin.js.
Only Brand Navigation component settings ending in \_color take this path;
other themes/settings keep Core's original method. It captures the value before
the original native request and, only after that method resolves successfully,
sets both its original buffer and saved setting to that submitted value before
Core's normal commit. Errors still propagate through Core. No additional
request, success on failure, optimistic pre-save write or global setting-model
override was added. This addresses accepted-value synchronization; the source
inspection did not establish why the original buffer/model stayed stale.

Discourse Work should install these two product files only, then repeat exactly
the already requested native save / different Appearance save / reload browser
sequence. Current local SHA-256 identities:

- initializer brand-navigation-admin.js:
  `b1993866e024b6718fd047701bf359655b072f7b72c65c8233a53fcef2e348f1`.
- connector brand-navigation-bundles.gjs (unchanged from prior candidate):
  `c862af6faff4a8f42fad43c8f61757a09af41a7cbc61a969ba7d37d9aa037c77`.
- prepared, UNRUN integration source:
  `9db011bc52f330f5d15226543ca5d2744dd7f61844819a03f4d5258d5b50a94c`.

No browser/runtime, tests, lint checks, builds, commits/pushes or tag/release
operations here. No full suite or wider testing requested. RC4 is unchanged.
Do not claim this follow-up verified until actual browser results return.

## Remaining E01 staleness implementation — 2026-10-21

Phil authorized fixing immediate picker staleness, then sending the correction
to Discourse Work for the actual-browser native save / different Appearance
save / reload sequence only. No full suite or wider testing; RC4 unchanged.

Prepared a component-local observer bridge in brand-navigation-bundles.gjs.
Native ThemeSettings values are Ember-observable; their changes now invalidate
the panel's tracked color-settings array so untouched pickers redraw. The
panel registers only its defined color settings, rebinds for a different theme
or settings array, and removes observers on destruction. Local draft precedence,
the earlier sparse-save protection and E03 stable setting keys are retained.
No polling, network request, native-editor replacement or global hook was added.
This implementation is not yet browser-verified.

Connector SHA-256:
`c862af6faff4a8f42fad43c8f61757a09af41a7cbc61a969ba7d37d9aa037c77`.
Integration source regression prepared for an EmberObject native-value change
redrawing the picker before a different Appearance save; not executed. Test
source SHA-256:
`465d9a5ca42e36998606c7a980a3225ab84a58e05076c218d6d1f0d97ad81229`.
No tests, lint checks, builds, local runtime operations, commits, pushes or
release/tag changes were performed here. Discourse Work owns the specifically
authorized installation/browser check; remaining-gap consideration stays
separate and does not authorize a wider campaign.

## Discourse Work browser results — 2026-10-21

Discourse Work reported completion of the specifically assigned E01/E03 actual
Chrome checks. This is received testing evidence, not execution by this chat.

- E01, installed connector SHA prefix `33b15c61`: native background `#123456`
  survived a subsequent Appearance-only icon save `#456789`. Reload showed
  background/text/icon `#123456` / `#334455` / `#456789` in both native fields
  and pickers. The stored-value overwrite was not reproduced with the fix.
  Immediate picker staleness following the native save remains observed;
  E01 is not fully closed.
- E03, combined connector SHA prefix `3e579481`, loaded module
  `55fb51c57f2bb3f3ea3dbf89318e68e921256c82`: all eleven Custom checkboxes
  retained visible keyboard focus through Space on/off transitions; checked
  states and picker enablement agreed. Reverse Shift+Tab worked. Reload
  discarded temporary drafts and retained saved settings.
- The earlier reported asset mismatch was mistaken identification:
  `6dccad91` belongs to the translation script. Discourse Work identified the
  actual component module through its modulepreload link. Phil manually
  restarted Chrome after a later control disconnection. Do not carry forward
  the former unresolved-cache explanation as an established defect.
- Existing E01/E03 RESULT.md files and TESTER_CHECKPOINT.md hold detailed
  observations/evidence. Remaining gaps were considered, not executed.
  Normal UI keyboard/reset/translation/size/layout checks were identified as
  feasible candidates; lifecycle, roles, CSRF, native chooser, screen readers
  and external embedding retain their specific prerequisites.

No new testing, code correction, commit, publication or tag operation is
authorized by receipt of these results. RC4 remains unchanged. This chat
continues as implementation-only; Discourse Work owns testing.

## Current implementation handoff — 2026-10-21

This section supersedes the older correction/historical handoffs below. Brand
Navigation is implementation-only. Phil subsequently transferred testing to
Discourse Work (019f69f3-d27c-7d31-9a64-2610fea6c76c), not Brand Nav Tester.
Discourse Work received the correction identities, existing local runtime and
evidence locations, and the unresolved browser asset-loading blocker. Brand Nav
Tester was instructed to stop and preserve the environment. The sequence is
E01, E03, then consideration of the other existing live-browser-suitable gaps.
Phil's latest clarification is to send those gaps for consideration after
E01/E03, not to start the remaining checks now; Discourse Work received that
clarification and the seven existing gap categories. No full suite or
new testing infrastructure is authorized. Product defects return here for
implementation. Keep RC4 unchanged. Phil
directed this chat to leave the E01 browser check with Tester, stop relaying
play-by-play, and move on. No tests or builds were run here, and no commit,
push, publication or RC4 tag change is authorized by this work.

E01's sparse-save and saved-response reconciliation correction was delivered
to Tester at connector SHA-256
`33b15c61deae450a04f078f5574c4ae3e0bf4c7d20be6bfaab7a9769e9eccb9b`.
Tester has installed that exact one-field change locally and owns the single
actual-browser native save / different Appearance save / reload check. There
is no completed correction-verification result recorded here. Do not treat
the earlier failed sequence or source implementation as verification success.

The separately reported E03 focus-loss correction is now prepared locally.
The Appearance getter creates new row objects on changes; its unkeyed each
used object identity, replacing the checkbox DOM nodes. The template now keys
rows by the stable setting name. No focus-stealing/restoration hook or settings
behavior was added. A rendering regression source checks retained checkbox
identity and focus on both toggle directions for all eleven colors; it has
not run and does not substitute for actual keyboard verification.

Current connector SHA-256, containing E01 plus E03:
`3e57948102956dac7bb8d2b4fd834d890ee63e2e56c4fd24181806e7c6f75968`.
Do not replace Tester's pinned E01 installation with this later file during
the already authorized E01 sequence. E03 is not installed or verified. Preserve
all other existing dirty files and evidence. No additional testing assignment
is created by this checkpoint.

## Current correction handoff — 2026-10-20

Phil authorized the four product fixes and four documentation corrections in
the consolidated RC4 action list, then authorized committing and pushing those
corrections. Testing and building remain stopped. The next release would be
RC5; this push does not authorize publishing it, deployment or live-site
changes, or changing the published RC4 tag.

The initial correction batch was committed and pushed as
`2481a24b9393ec2a902450cce306e2123fd66394`. A subsequent read-only review
identified a no-op **Inherit all** reset that retained empty drafts and a stale
historical checkout reference. Phil authorized those two corrections through
Temp Brand Navigation. The local follow-up clears drafts immediately when the
reset has nothing to save, and removes the stale reference without restoring a
machine-specific path. Phil subsequently authorized committing and pushing this
follow-up, then sending its commit to Temp Brand Navigation and Brand Navigation
Checker for read-only review. It remains untested; testing, building,
publication and RC4 tag changes are not authorized.

The working changes start from `main` commit
`54a9cdb44b36f493138a016be8ee3501558d7fd4`. They change Appearance to retain
only locally edited color drafts and read untouched colors from the current
native settings; name each Custom checkbox with its localized color purpose;
make submenu summaries discoverable to compact-menu focus forwarding; and
exclude label-only entries from sprite-readiness subscriptions.

Documentation clarifies shared-component staging and global enabling/disabling
versus single-theme detachment, distinguishes bar and compact-menu Escape
behavior, and replaces machine-specific historical paths. No new testing result
or finding-closure disposition is claimed. These working changes have not been
tested or built.

For current product information, use the [README](README.md),
[Administrator guide](docs/USER_GUIDE.md), [testing record](docs/TESTING.md) and
[GitHub Releases](https://github.com/CodeWorksLabs/brand-navigation/releases).
The testing record describes its dated evidence, not acceptance of these changes.

## Historical checkpoint archive — 2026-10-17

Everything below is retained history. Its RC2 candidates, instructions,
permissions, pending actions and results are not the current handoff, current
repository state or authority to resume work. In particular, the old
"prepared, not published" wording does not describe the current release state.

Historical date: 2026-10-17

## RC2 feature release-preparation handoff

Phil chose to include the new features in RC2, not RC3, and authorized finishing
the checks, independent results review, then commit/push/open a new draft PR.
That instruction does not authorize merge, tag, GitHub Release or live changes.
Ask before any further product-code correction. The Bridge migration remains
separate. Prior [PR 25](https://github.com/CodeWorksLabs/brand-navigation/pull/25)
is already merged; it is not the pending feature PR.

Current baseline is main `1ddfef2872855289763b10fc39800ec1ba7f455a`. The
runtime-tested `admin-label-test-r2` candidate is an uncommitted 58-member
package with no candidate commit/tree: ZIP 269,937 bytes, SHA-256
`58123c4c03f1ce8e8cf98cceaa1f9c92225c8b8cb1040f3abb17b82cb7da8f34`.
This final record preparation changes only CHANGELOG, TESTING, this checkpoint
and USER_GUIDE release wording. Root must stop/hash those four files, build the
separate final package and obtain independent claims/member/native-mapping
association before the authorized commit/push/draft PR. Do not call the new ZIP
an already tested native archive or invent the eventual commit identity.

Current evidence and limits are in
[`docs/TESTING.md`](docs/TESTING.md#current-rc2-feature-verification):

- Normal stock 24 variants and old shipped 22 examples carry through explicit
  unchanged-effective-source analysis, with fresh minimized two and new shipped
  two regressions. No new full replacement suite is claimed.
- Three prior feature positives plus five fresh selected positives cover the
  adopted eight scenarios, including real light/dark colors, pointer-away
  keyboard focus, friendly native labels and Appearance persistence.
- Native ID35 contains all 20 exact Core-consumed fields; retained replacement
  20-field and original 19-field estates were preserved. Installed frontend
  coverage passed all 40 named cases (21 unit, six icon/readiness, 13 admin).
  Independent bounded review closed the friendly-label and test-context findings.
- The original feature failures, zero-selection retry and first 37/40 frontend
  result remain historical evidence, followed by explicit correction outcomes.
  No timeout/assertion/count relaxation or hidden retry is represented.

Fresh configuration checks passed 37 cases; types/CSS/templates passed.
Generic Windows ESLint remains an unqualified environment diagnostic, not a
green gate. The earlier same-effective-source baseline comparison found 12
inherited messages, zero introduced and 24 resolved; its scope does not replace
fresh remote CI. The new feature PR and exact-head CI are still pending.

Bounded stock palette/focus and RTL layout evidence is positive, not complete
manual acceptance. Genuine zoom, full RTL, allowed-host classic external embed
and complete human screen-reader verification retain the stable-v1 boundaries.
OS picker, physical-device/Safari and all-plugin qualification are not claimed.
Historical Git lifecycle evidence is bounded carry-forward, not a fresh full
replay on every later archive or future tag. RC2 is prepared, not published.

Owned current PostgreSQL and Redis were cleanly parked at 08:42:57 UTC, then
the owned container stopped at 08:43:27 UTC on 2026-10-17. Its sleeping PID1
exit137 was not a PostgreSQL crash or OOM; no active tests remain. Retained
databases, backups, native installations and all failed/positive artifacts are
preserved. External `rc2-review-evidence/HANDOFF.md` and the R4 receipts retain
recovery details. Do not reset/prune/recreate infrastructure or rerun passing
header cases for documentation edits. The excluded `.pnpm-store/` is preserved.

All entries below are historical records. Their old pending gates, resource
owners, candidate identities and dispositions do not override this handoff or
the current PR/remote state.

## Historical checkpoint — 2026-10-15

## Current correction — CLI diagnostic escaping

Phil approved fixing `BN-RC2-CLI-01` before RC2 and freezing a replacement
candidate for correction review. The CLI diagnostic sink now escapes all C0,
DEL and C1 controls, including parser/filesystem errors; explicitly trusted
usage/validation line breaks are retained. Seven new real-process regression
tests bring the local configuration suite to 33 passing tests. Browser/runtime,
schema, dependencies and lock are unchanged. The first malformed-input fixture
needed shortening to fit V8's diagnostic excerpt. The pnpm launcher failed its
registry/version-verification fetch; no security setting was weakened, and
installed Prettier was invoked directly with Node.

The prior complete source review of `81bda1e` / tree `2e7ddfe` reported no
P0/P1 and one P2, with `INTERNAL CODE REVIEW PASS WITH P2/P3 FINDINGS`.
That disposition does not carry forward to these changed bytes. A replacement
freeze and focused correction-closure review are next; no release acceptance
is claimed. Durable review/control evidence is outside the repository in the
owner's `rc2-review-evidence` archive.

Phil approved isolated local WSL/Docker installation, upgrade, rollback and
compatibility checks, conditioned on resource coordination. Coordination with
the prior infrastructure task is complete, but it
has not admitted another Discourse stack during its retained-forum phase.
Keep all Brand Navigation services stopped until an agreed serial window and
fresh capacity/port checks. No mutation of existing resources or shared caps,
cache release, or pruning is authorized. The six-slot matrix plan and prior RC1
archive are saved externally; the old candidate archive must be replaced for
these corrected bytes. No publication, merge, tag or live migration has occurred.

## Active RC2 work — core-header text links

Phil authorized adding the text-link capability missing from the separate
Custom Header Links component and accepted `v1.0.0-rc.2` as the next candidate.
The Bridge currently retains Custom Header Links component 5 for Versions &
Status; Brand Navigation is component 6. That text link has not been migrated.
Implementation adds `header_presentation` to top-level navigation items with
an `icon_only` default so existing core-header icons retain their appearance.
Explicit `label_only` and `icon_and_label` support direct text links using the
existing supported header API and shared audience/device/embed/safe-URL rules.
Implementation and verification are prepared in draft
[PR 25](https://github.com/CodeWorksLabs/brand-navigation/pull/25), targeting
main from `feature/site-header-text-links`.

- Tested implementation commit: `6c7383dd5597d65c7f1e0f9ffdf123d075fab898`.
- Tested tree: `4682d861dec9029622459a5a3e633730d63aba94`.
- CI merge commit: `0fa60378a91d11bd2dc5f6a645cf0e348cbf3975`, with that same
  tree, based on main `3129838a8e102219e05568ea5c7058420723593c`.
- [Discourse CI run 38812437699](https://github.com/CodeWorksLabs/brand-navigation/actions/runs/38812437699)
  passed the full lint gate and all four frontend/backend/system lanes.
  Each frontend lane passed 27 tests and each system lane passed 34 examples.
- [Configuration run 38812437412](https://github.com/CodeWorksLabs/brand-navigation/actions/runs/38812437412)
  passed all 26 tests. Local configuration tests, template/style/type checks,
  Ruby syntax, and formatting also passed.

Windows ESLint reproduces a local environment failure on unchanged HEAD
(Babel file-URL path handling and theme globals); the clean Linux CI lint gate
passes. The first CI attempt at `93f7c24` found two test-harness issues (RSpec
context wording and a Selenium-only keyboard API); both are corrected, and the
replacement run above is green. CI screenshots were inspected for desktop text
rendering and mobile truncation with the full accessible label retained.

The subsequent evidence-record update changes documentation only. Resolve the
latest PR head and checks before release review. No RC2 release or live-site
change has occurred. Formal review, manual release acceptance, and The Bridge
cutover remain pending. The screenshot-gallery administration image is still
waiting for Phil's replacement attachment and has not been re-added.

## Repository preview gallery — 2026-10-15

Phil authorized publication of a dedicated `README.md#preview` section for the
Brand Navigation component topic. The reviewer twice mishandled an unrelated
Discourse global Branding-settings screenshot: first by inventing a connection
to Brand Navigation and later by restoring the same wrong image as a Brand
Navigation administration example. The final correction removes the image and
the entire inaccurate Administration subsection. It must not be restored or
used as Brand Navigation product evidence.

The preview gallery also contains three visitor-facing Brand Navigation
examples from Repeal OBBBA Forum, The Bridge demonstration site, and RVing
Community, with links to the live DiscussionBridge demo and each pictured
site. Validation passed local Prettier for `README.md` and this checkpoint, all
24 configuration tests, PNG decoding/dimension inspection for the assets, and
`git diff --check`. No executable component, settings schema, release tag,
compatibility branch, live Discourse configuration, or deployment changed.

## Public documentation owner correction — 2026-09-14

Phil authorized a local canonical-documentation correction after the first
read-only public owner gate. The correction updates `README.md`,
`docs/USER_GUIDE.md`, and `docs/MIGRATION.md` to identify
`v1.0.0-rc.1` as the current published prerelease, scope the browser-only
bundle workflow and English-only bundled locale accurately to RC1, and give
troubleshooting a direct GitHub Issues route while preserving private security
reporting. The shared public documentation site and its Brand Navigation
section are published. The accepted documentation history now culminates at
commit `8cd82e099fd181e0b3403ea2181190d12abcf037`, tree
`5714747b9137042cf03eb5d3709bfbfe2d7e9c07`, and both `main` and
`docs/project-history` resolved to that exact commit on GitHub at publication.
The shared site mirrors the nine canonical source documents from that commit;
this checkpoint-only closeout changes none of those nine sources.

No executable, setting, package, release tag, compatibility branch, shared-docs
mirror, live site, or deployment state changed. Targeted Prettier validation,
local Markdown link checks, the public documentation/release/issues/security
destinations, and all 24 configuration tests passed. Commit
`93b72ce74fb0fbbe72d1748450a98079eb61d44c` adds only
`* text=auto eol=lf` to `.gitattributes`, closing the former Windows
clean-checkout report of 31 Prettier failures. Full lint, all 24 configuration
tests, and a repository-wide Prettier check in a fresh detached Windows
worktree passed at that identity. The 31-file report is superseded and is not a
current failure.

Manual Boss first returned **NOT READY** on exact commit
`12bcfa1c51e5d182231647dbf33224e4ab5cf42c` because this checkpoint was
ambiguous about the already-published documentation site versus the unpublished
correction. Commit `de5fd2e004991eea3a1dd90c322ea7ec237ca1fb` corrected that
ambiguity, after which Manual Boss returned **READY** for Product Boss. Product
Boss then found the documentation itself product-truthful and coherent but
blocked its first gate because this checkpoint still carried the superseded
Manual Boss and Prettier states and incorrectly routed the next gate to Brand
Boss. Commit `8cd82e0` corrected those statements. Product Boss independently
verified that exact replacement and returned **READY — PRODUCT/DOCUMENTATION
GATE CLOSED** with no remaining P0, P1, or P2 correction.

## Current disposition

Brand Navigation `v1.0.0-rc.1` is published as a GitHub prerelease and is in
its release-candidate aging period. It is independently maintained by
CodeWorksLabs and is not an official Discourse product. No release-blocking
defect is known at this checkpoint.

The development application no longer displays the original development transcript.
The active task still received retained context, but that context is not a
durable user-visible archive. A readable reconstruction is now preserved in
[`docs/PROJECT_HISTORY.md`](docs/PROJECT_HISTORY.md). Exact claims continue to
be governed by Git, the release metadata, and the repository evidence records.

## Authoritative repository state

- Repository: `https://github.com/CodeWorksLabs/brand-navigation`
- Local checkout: this repository's workspace directory, named
  **Discourse Brand Navigation** in the original workspace.
- Documentation branch: `docs/project-history`
- Preview-gallery content commit:
  `de25bfe` (tree `8d64a050527cac8b98e78259131f03d2d2ed5dae`)
- Candidate commits: `12bcfa1c51e5d182231647dbf33224e4ab5cf42c`,
  `de5fd2e004991eea3a1dd90c322ea7ec237ca1fb`, and
  `93b72ce74fb0fbbe72d1748450a98079eb61d44c`, followed by checkpoint closure
  commit `8cd82e099fd181e0b3403ea2181190d12abcf037`
- Pre-gallery repository state: remote `main` and `docs/project-history` both
  resolved to `f87fa98ceccab92285bbc40fc28a817ec09cf4d0`; the gallery advances
  repository documentation only and does not change the nine mirrored source
  documents
- Published documentation source commit:
  `8cd82e099fd181e0b3403ea2181190d12abcf037`
- Published documentation source tree:
  `5714747b9137042cf03eb5d3709bfbfe2d7e9c07`
- Published prerelease: `v1.0.0-rc.1`
- Annotated tag object:
  `06c7b0386eef69f4ad358aa9f0e7590558975ef9`
- Immutable tag target:
  `ed1640b049763c37694f8c3bb5f9f69cbd21f658`, tree
  `f3b97c11c93dc00c2e66df346ec4c0b032ab5581`
- Shared-docs source commit:
  `85ceeb1053d9ce9f0397d3cd0964e615a4d6c1dc`, tree
  `4e6eac803252ba7a32da82cf0864b11b4a226d49`
- Live shared-docs Worker version:
  `9b0092d1-3dcf-49b8-8e2f-bd358dfa4837`
- Release URL:
  `https://github.com/CodeWorksLabs/brand-navigation/releases/tag/v1.0.0-rc.1`
- Published preview: `v0.9.0`
- Maintained compatibility branches: `d-compat/2026.7` and
  `d-compat/2026.8`

Resolve live moving refs before acting; do not assume the hashes above remain
the current branch heads after later work. Never mutate a published tag.

## Product invariants

- Public identity is **Brand Navigation**, repository slug
  `brand-navigation`, described as a brand header and submenu navigation theme
  component for Discourse.
- It is independently maintained and makes no official Discourse-status claim.
- Discourse's component-level **Enabled?** control is the single activation
  switch.
- Administration remains a first-class surface with structured validated
  settings, safe defaults, color inheritance, and browser-based configuration
  bundle import/export.
- Site-global Brand Navigation content must never mount in supported Discourse
  embed contexts. Enforcement stays at the component render and connector
  boundaries using supported Discourse state.
- Do not introduce CSS hiding, hostname checks, downstream DOM-selector embed
  detection, or DiscussionBridge-specific compatibility code.
- Core topic navigation, embedded discussion content, authentication, reply,
  like, quote, composer, and full-app behavior remain owned by Discourse.
- One submenu child level is intentional.
- License remains `GPL-2.0-or-later`; attribution and provenance must precisely
  distinguish inspiration, historical study, and current code.

## Verified release state

The release candidate went through exact-candidate CI, two complementary
review lanes, correction-closure review, manual acceptance, exact-tree merge,
post-merge CI, annotated tagging, and GitHub prerelease publication.

The canonical multi-site installation and update evidence is in
[`docs/TESTING.md`](docs/TESTING.md). It includes current/default and
compatibility-branch behavior across the DiscussionBridge sandbox, Repeal
OBBBA Forum, DiscussionBridge Forum, The Bridge, Citizen Activist Network,
RVing Community, and R744 Community.

The exact release contents are summarized in [`CHANGELOG.md`](CHANGELOG.md).
The release includes:

- native single-switch activation;
- staging-theme bundle preparation guidance and test coverage;
- protection against stale asynchronous bundle reads;
- corrected mobile linked-parent submenu flow;
- Discourse compatibility-branch automation and packages; and
- the latest-release badge.

## CodeWorksLabs public-site handoff

Phil authorized a source-backed content handoff for the separate CodeWorksLabs
Astro and Starlight build on 2026-09-08. The complete bundle is
[`docs/PUBLIC_SITE_HANDOFF.md`](docs/PUBLIC_SITE_HANDOFF.md). It records the
approved product identity and copy, release and installation links,
compatibility and testing limits, support and contribution routes, provenance,
canonical-source ownership, live-demo evidence, and publication checks.

The settled host architecture is:

- `codeworkslabs.dev` for the apex and product catalog;
- `docs.codeworkslabs.dev` for shared Astro Starlight documentation;
- `demo.codeworkslabs.dev` for the demo index and chooser; and
- `{platform}.demo.codeworkslabs.dev` for platform demonstrations, beginning
  with `astro.demo.codeworkslabs.dev` and
  `discourse.demo.codeworkslabs.dev`.

No CodeWorksLabs site or external system was changed from this repository
task. A read-only check on 2026-09-08 found the existing The Bridge demo URL
returning HTTP 200, while the settled CodeWorksLabs apex, docs, and demo hosts
did not yet resolve in the task environment. A follow-up read-only review on
2026-09-09 confirmed that the apex, documentation, demo index, and Discourse
demo hub were deployed and returning HTTP 200. The separate site task reported
that its site-owned review corrections were then live. The repository still
contains no approved product screenshots, logos, or video assets; no
CodeWorksLabs-hosted Brand Navigation product demo was verified in this task.

A second read-only review on 2026-09-09 found all 28 sitemap routes returning
HTTP 200, the nine mirrored source pages carrying one H1 and the exact source
commit, and the earlier content, provenance, metadata, and routing corrections
substantially complete. Phil then authorized the remaining site-owned fixes and
they were queued to the existing CodeWorksLabs site task: reorganize the
product-hero actions so installation, documentation, and demo status are
prominent while release, source, and issue links form a compact secondary row;
route the install action through the staging-first guide; route the footer
Security link through the published security guidance; and either add approved
social-card imagery or downgrade the docs Twitter card from
`summary_large_image` to `summary`. The handoff explicitly preserves all
confirmed-good corrections and does not authorize merging Brand Navigation
pull request 24.

On 2026-09-09, Phil authorized publishing the documentation-recovery branch.
`docs/project-history` now tracks `origin/docs/project-history`, and
[pull request 24](https://github.com/CodeWorksLabs/brand-navigation/pull/24)
is the active documentation-only reconciliation into `main`. Resolve its live
head and checks before acting. The pull request does not authorize merging or
change the immutable `v1.0.0-rc.1` tag.

## Accepted residual risks and limitations

- Full current-candidate human screen-reader coverage remains incomplete. A
  bounded VoiceOver pass confirmed several key announcements and states, but
  the documentation does not claim complete accessibility acceptance.
- Dense mobile core-header icon sets can crowd Discourse's own controls.
  Operators should use per-item device visibility to reserve mobile space.
- Complete pin-and-return rollback remains provisional until the full workflow
  is recorded on staging.
- Ruby lint transitives and some reusable CI dependencies are not completely
  immutable and require ongoing release-engineering monitoring.
- Framework coupling in the administrator editor and SVG sprite readiness
  remains a maintenance watch area as Discourse evolves.

## Review process position

For important candidates, retain both review lanes:

- internal subagent review for fast candidate-bound technical scrutiny and
  iterative correction closure; and
- the visible sidebar Code Reviewer for independent, operator-observable
  formal release gates.

Neither lane replaces the controlling Code Review Doctrine. A changed
candidate requires fresh evidence and disposition. The sidebar reviewer should
wait for Phil's in-task `proceed` before starting when Phil wants to select its
model.

## Exact next actions

1. Resolve the latest head and checks of draft PR 25, then freeze the RC2
   candidate and obtain the required doctrine-controlled release review and
   manual acceptance. Implementation CI is green at the identity above.
2. After release acceptance and publication authority, merge/tag/publish
   `v1.0.0-rc.2` under the existing release procedure. Preserve the RC1 tag.
3. Migrate The Bridge's Versions & Status link to Brand Navigation only after
   the accepted version is installed and live cutover is authorized; verify
   the link once per theme and retire the separate text-link component there.
4. Resume the administration screenshot insertion when Phil supplies the
   replacement image. Embed it directly after “screenshots are captured.” and
   before “Repeal OBBBA Forum,” as requested.

## Out of scope

- CMS behavior, general page building, or arbitrary deep navigation nesting.
- Authentication replacement or changes to core Discourse embedding.
- DiscussionBridge-specific compatibility code.
- Hostname, CSS, or DOM-selector embed workarounds.
- Literal Discourse-core integration, official-status claims, repository
  transfer, or official branding without Discourse maintainer acceptance.
- Live installation, deployment, or publication without explicit authority.
