# Brand Navigation successor checkpoint

Date: 2026-09-14

## Public documentation owner correction — 2026-09-14

Phil authorized a local canonical-documentation correction after the first
read-only public owner gate. The correction updates `README.md`,
`docs/USER_GUIDE.md`, and `docs/MIGRATION.md` to identify
`v1.0.0-rc.1` as the current published prerelease, scope the browser-only
bundle workflow and English-only bundled locale accurately to RC1, and give
troubleshooting a direct GitHub Issues route while preserving private security
reporting. The shared public documentation site and its Brand Navigation
section already exist and are published. Canonical product-document correction
commit `12bcfa1c51e5d182231647dbf33224e4ab5cf42c`, tree
`f38495198c7402539a491dacdd4834913899b261`, has not yet been synchronized or
published to that site.

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
blocked its gate because this checkpoint still carried the superseded Manual
Boss and Prettier states and incorrectly routed the next gate to Brand Boss.
Those are historical dispositions against earlier exact candidates; Product
Boss read-only verification of this corrected checkpoint is the current gate.

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
- Documentation candidate HEAD:
  `93b72ce74fb0fbbe72d1748450a98079eb61d44c`
- Documentation candidate tree:
  `370820eba2c005816a93298f26c7e3b78a4eec96`
- Candidate commits: `12bcfa1c51e5d182231647dbf33224e4ab5cf42c`,
  `de5fd2e004991eea3a1dd90c322ea7ec237ca1fb`, and
  `93b72ce74fb0fbbe72d1748450a98079eb61d44c`
- Candidate state before this checkpoint-only correction: clean, three commits
  ahead of `origin/docs/project-history`, with nothing pushed
- Default branch at checkpoint:
  `ed1640b049763c37694f8c3bb5f9f69cbd21f658`
- Default-branch tree:
  `f3b97c11c93dc00c2e66df346ec4c0b032ab5581`
- Published prerelease: `v1.0.0-rc.1`
- Annotated tag object:
  `06c7b0386eef69f4ad358aa9f0e7590558975ef9`
- Tag target: the exact default-branch commit and tree above
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

1. Preserve Manual Boss's initial **NOT READY** disposition on exact commit
   `12bcfa1` as superseded history and its later **READY** disposition after
   checkpoint clarification as the current completed Manual gate.
2. Commit only this checkpoint correction and the dated-history heading
   clarification, then return the exact replacement identity to Product Boss
   for read-only verification.
3. Evaluate and close any Product Boss finding before any shared-docs
   synchronization or publication action.
4. After Product Boss closes its gate and only with separate authority,
   synchronize and publish
   this correction through the shared-docs mirror, build, and deployment lanes.
5. Verify the live Brand Navigation pages, release/source/edit/support/security
   targets, and corrected wording at the exact deployed identity.
6. Then continue `v1.0.0-rc.1` aging, triage meaningful compatibility or
   operator reports, and keep [`docs/TESTING.md`](docs/TESTING.md) current as
   supported Discourse versions and installation refs change.
7. When stable-release criteria are met, freeze a new exact `v1.0.0`
   candidate, run required CI and doctrine-controlled review, perform final
   manual acceptance, then merge, tag, and publish the exact accepted tree.

## Out of scope

- CMS behavior, general page building, or arbitrary deep navigation nesting.
- Authentication replacement or changes to core Discourse embedding.
- DiscussionBridge-specific compatibility code.
- Hostname, CSS, or DOM-selector embed workarounds.
- Literal Discourse-core integration, official-status claims, repository
  transfer, or official branding without Discourse maintainer acceptance.
- Live installation, deployment, or publication without explicit authority.
