# Brand Navigation successor checkpoint

Date: 2026-10-16

## RC2 main integration handoff

Phil instructed completing [PR 25](https://github.com/CodeWorksLabs/brand-navigation/pull/25)
and putting `main` on RC2 after the completed engineering review. This authorizes
the bounded release-record update, push and PR merge, not a GitHub Release,
tag publication or live-site mutation. Ask before any additional product-code
change. The Bridge's Versions & Status link has not been migrated.

The reviewed executable candidate is
`e7a16be653be8ccc045b73833d44ab38330689f1`, tree
`7eee3e5416a9ed2c15bc36b15b54d1bb65c84960`, already pushed to
`feature/site-header-text-links`. The final integration delta changes only
`CHANGELOG.md`, `docs/TESTING.md` and this checkpoint. Resolve the PR's current
head, checks, merge state and remote `main` before acting; this preparation
record does not predict the eventual merge commit.

Current engineering evidence and honest RC2 limits are recorded at the top of
[`docs/TESTING.md`](docs/TESTING.md#rc2-final-engineering-verification--2026-10-16).
Configuration CI passed 33 tests; each of four Discourse lanes passed 30
frontend tests and 36 system examples. Additional isolated evidence passed 21
mobile/header examples, exact native ZIP import with 19 old and 19 new fields
verified, and 30 installed-component frontend tests on Core `3086c087`.
Native Git upgrade/rollback/lifecycle observations are explicitly bounded
carry-forward evidence, not a new complete replay on every later revision.

Independent engineering review used the complete CodeWorksLabs Discourse review
package and closed the CLI, editor-save and mobile-layout findings. No required
engineering finding remains in that reviewed scope. Documentation-only changes
must receive proportional independent identity/claim review and fresh CI; prior
runtime observations carry only across the proven unchanged executable boundary.

Final manual acceptance is not fabricated: genuine browser zoom and native
palette/focused-color transitions remain unverified; full RTL, real external
classic embed and complete human screen-reader acceptance remain stable-v1
gates. The RC2 changelog is not proof of a published tag or GitHub prerelease.

Both owned test environments are parked. Their databases, original backup,
component 34 and all failed/successful evidence are retained. The current
environment's PostgreSQL and Redis were shut down natively before container
stop. No reset, prune, broad cleanup or live cutover is required. External
`rc2-review-evidence/FINAL-STATE.json` and `HANDOFF.md` retain the detailed
recovery identities; do not recreate the test framework or rerun passing suites
merely because release documentation changed. The disclosed untracked
`.pnpm-store/` is excluded from the candidate and must be preserved.

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
is claimed. Durable review/control evidence is outside the repository at
`C:/Users/Owner/.codex/visualizations/2026/09/08/01a08236-bcfa-73f2-85b0-b2be66290512/rc2-review-evidence/`.

Phil approved isolated local WSL/Docker installation, upgrade, rollback and
compatibility checks, conditioned on resource coordination. Coordination with
`5th YACCTTWF - Yet Another Crap Codex Task That Will Fail` is complete, but it
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

The Codex application no longer displays the original development transcript.
The active task still received retained context, but that context is not a
durable user-visible archive. A readable reconstruction is now preserved in
[`docs/PROJECT_HISTORY.md`](docs/PROJECT_HISTORY.md). Exact claims continue to
be governed by Git, the release metadata, and the repository evidence records.

## Authoritative repository state

- Repository: `https://github.com/CodeWorksLabs/brand-navigation`
- Canonical local checkout:
  `C:\CodeProjects\Products\Discourse Brand Navigation`
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
