# Release procedure

## CI dependencies and evidence

Direct actions in the component-owned configuration workflow and the outer
Discourse reusable workflow are pinned to reviewed commit SHAs. The pinned
Discourse workflow intentionally follows its own maintained action tags,
Discourse core target, and test-container tags so CI exercises the current
supported Discourse boundary. Exact release evidence must record the candidate,
outer workflow revision, resolved Discourse core commit, tool versions, and
available container/action identities from the run logs. This is a deliberate
upstream-trust and compatibility-testing policy, not a claim that the complete
transitive execution graph is immutable. Before changing a direct pin, resolve
the intended upstream version, review its source and release notes, then run
both workflows on the candidate. Retain the human-readable upstream major tag
in the adjacent YAML comment.

## Release sequence

Choose the intended Semantic Versioning identifier before opening the release
pull request. In the steps below, `<VERSION>` means that exact version without
the leading `v`; the Git tag and GitHub Release use `v<VERSION>`. Never reuse or
move an existing release tag.

1. Finish release preparation and manual documentation/product polish.
2. Open one clean draft `v<VERSION>` release-preparation pull request.
3. Run CI and freeze the exact candidate commit and tree.
4. Conduct the formal complete codebase review against that immutable
   candidate, including the Discourse review requirements below.
5. Evaluate all findings together and remediate them as one coherent batch.
6. After corrections, freeze the replacement candidate commit and tree, rerun
   CI and affected tests, and complete independent correction-closure review.
   Associate every result with the candidate it actually tested; do not carry
   an earlier candidate's approval forward as approval of changed bytes.
7. Conduct final manual acceptance on the resulting candidate.
8. Merge only when review, CI, documentation, and manual acceptance are
   complete and every required finding is resolved. An unexecuted required
   check means verification is incomplete, not passed.
9. Confirm the merged tree matches the accepted candidate, then create the
   annotated `v<VERSION>` tag and matching GitHub Release.

Published identities and release history are recorded in
[GitHub Releases](https://github.com/CodeWorksLabs/brand-navigation/releases)
and [`CHANGELOG.md`](../CHANGELOG.md).

## Required Discourse review

### Discourse support policy

Follow Discourse's [official support schedule](https://releases.discourse.org/)
and [release data](https://github.com/discourse/discourse/blob/main/versions.json).
Maintain compatibility with supported ESR lines, including the oldest still-supported
ESR, and supported monthly releases. Test released lines at their latest published
patch; a development snapshot is not a substitute for a released ESR. Keep a
separate development `latest` lane as an early warning of upcoming changes.
During an ESR overlap, retain both ESR lines until the older one reaches end of
support. An expired ESR is historical evidence, not a required current target.

Before a normal release verification cycle, check the schedule, refresh exact
Core pins and record the component commit, Core commits and results. Before
publication, compare those results with the support claims; identify gaps or
explicitly approved exceptions rather than implying untested compatibility.
New features must not silently break a supported ESR: preserve compatibility,
maintain a compatible product version, or obtain explicit approval for a changed
support requirement and document it.

This policy applies to subsequent releases and prereleases. Current
testing coverage is behind the ESR schedule; adopting the policy and committing
target pins do not establish completed operational adoption or compatibility.
Adoption is phased, not a new retrospective testing campaign. RC5's completed
evidence and prepared target updates are recorded in
[Testing and acceptance](TESTING.md#discourse-support-policy-adoption).
The existing workflows provide the target lanes for regular CI cycles.
This transition neither turns untested targets into passes nor waives other
existing release safeguards.

### Review method

Review the exact Brand Navigation candidate as a **theme component** using all
three files below from the `CodeWorksLabs/review-skills` repository, under
`.agents/skills/codeworkslabs-platform-review/references/platforms/discourse/`:

- [DiscourseSkill.md](https://github.com/CodeWorksLabs/review-skills/blob/main/.agents/skills/codeworkslabs-platform-review/references/platforms/discourse/DiscourseSkill.md) — Discourse Extension Review instructions.
- [DiscourseSkill.json](https://github.com/CodeWorksLabs/review-skills/blob/main/.agents/skills/codeworkslabs-platform-review/references/platforms/discourse/DiscourseSkill.json) — structured review rules.
- [LOCAL_TEST_MATRIX.md](https://github.com/CodeWorksLabs/review-skills/blob/main/.agents/skills/codeworkslabs-platform-review/references/platforms/discourse/LOCAL_TEST_MATRIX.md) — isolated compatibility and lifecycle testing requirements.

The Markdown guidance and structured rules must both be used; a summary,
source-only review, lint result or green CI run does not replace the required
installed verification. Record the exact `CodeWorksLabs/review-skills` Git
commit used for all three files.

Refresh supported Discourse targets from official support data before the
review. Test the same exact candidate in isolated installations for every
materially distinct supported release line claimed by Brand Navigation,
including applicable monthly and ESR targets, and development-head coverage
specified by the method. Do not infer one target's compatibility from another.

Complete clean-install and native upgrade, settings-retention, rollback or
recovery, and return-to-candidate checks in the separate lifecycle environment.
Preserve working configurations and use non-production fixtures and services.
Record exact candidate and Core identities, environments, commands, results,
review findings and correction closure in the release evidence.

Identify every applicable check as passed, failed or not verified, and explain
any not-applicable classification. Skipped jobs and missing evidence are not
passes. If a required check cannot be completed, report testing as incomplete
and do not claim release readiness or publish the release. Independent review
must check the evidence and outstanding findings, not merely repeat a green
summary. This process does not constitute official Discourse approval.

## Release gates

Before completing a release sequence:

1. Confirm the default branch is `main`.
2. Run all lint, type, configuration, unit, and system-test gates against the
   exact candidate. Confirm lint commands cover the full intended source and
   test file inventory, including scripts, rather than relying on the job name
   or exit status alone. Record commands, coverage, failures and skipped checks.
3. Execute the manual acceptance matrix in `TESTING.md`.
4. Verify migration and rollback on a staging site or separate component copy.
   A different parent theme or Preview alone does not isolate shared code,
   settings or enabled state from live themes using the same component.
5. Review dependency and Discourse compatibility changes.
6. Confirm every referenced translation key exists in `locales/en.yml`, the
   English fallback is complete, and the README and administrator guide state
   which languages are bundled. Treat additional locale files as reviewed
   release content.
7. Confirm the README thanks and product-inspiration credit remain accurate and
   `docs/ATTRIBUTION.md` identifies any copied or adapted code precisely. Complete
   the [source and license checks before release](PROVENANCE.md#source-and-license-checks-before-release).
8. Confirm no secrets, site-specific hosts in executable defaults, special
   DiscussionBridge logic, official badges, Discourse logos, or official-status
   claims are present. Named compatibility evidence and migration fixtures may
   retain their necessary site origins.
9. Confirm `Brand Navigation` and `brand-navigation` remain appropriate for the
   independent release stage.
10. Confirm `CHANGELOG.md` moves the released entries out of **Unreleased**.
11. Confirm the accepted candidate, merged tree, `v<VERSION>` tag, and GitHub
    Release all identify the same tree. Include compatibility, upgrade,
    migration, and rollback notes in the release.

## Documentation and support

Keep the README, administrator guide, changelog, release notes,
[product page](https://codeworkslabs.dev/products/brand-navigation/) and
[public documentation](https://docs.codeworkslabs.dev/brand-navigation/)
consistent with the shipped release. Screenshots, installation instructions,
compatibility claims and known limitations must describe the actual release.
Website documentation is published separately from component releases.

Use [Brand Navigation Support](https://forum.codeworkslabs.dev/c/brand-navigation/support/7)
for installation and configuration help,
[Feature Requests](https://forum.codeworkslabs.dev/c/brand-navigation/feature-requests/8)
for proposals, and the [Roadmap](https://forum.codeworkslabs.dev/t/brand-navigation-roadmap/14)
for planned work and status. Use
[GitHub Issues](https://github.com/CodeWorksLabs/brand-navigation/issues) for
non-sensitive bugs, compatibility reports and documentation corrections.
Reports should identify the component release, branch or commit; Discourse
version; active theme; browser/device context; reproduction steps; and settings
or console evidence with sensitive information removed.

Suspected vulnerabilities must be reported privately to
[security@codeworkslabs.dev](mailto:security@codeworkslabs.dev) under the
repository's [security policy](../SECURITY.md). Credentials, personal data, and
non-public vulnerability details must not be posted in a public forum topic or
GitHub issue.

## Update channels and compatibility branches

`main` is the stable update channel for current Discourse. Build changes on
short-lived branches and merge only a complete, reviewed batch. Maintained
older Discourse releases use branches named `d-compat/<YYYY>.<M>`. The official
daily compatibility workflow creates a branch for each newly released
Discourse version from the last first-parent `main` commit predating that core
release.

The original manual bootstrap is historical, not routine release preparation.
The branch-creation workflow retains accepted-seed checks and serialized writes.
Do not reseed or force-move existing compatibility branches. If a branch is
found at the wrong commit, stop the workflow, inspect the ref, and correct it
only through an explicitly authorized and reviewed release operation.

When a compatible fix lands on `main`, backport it through a reviewed pull
request whose base is the affected `d-compat` branch. Do not merge new features
or unverified framework changes into compatibility branches. On `main` pull
requests, keep an exact-core CI lane for every Discourse release that Brand
Navigation actively maintains. On a pull request targeting a `d-compat` branch,
Discourse's reusable workflow deliberately selects the matching moving release
branch and Brand Navigation runs one clearly named compatibility-branch lane;
obtain separate exact-core evidence when a backport needs it.
Discourse update detection remains commit-based; release tags provide durable
human and revision-recovery identities. Use the provisional procedure in
[`MIGRATION.md`](MIGRATION.md#roll-back-brand-navigation-to-a-release-tag)
rather than editing remote component code. It is not a release-supported
recovery path until its complete pin-and-return workflow is recorded on staging
in `TESTING.md`. Record the Brand Navigation version, component commit,
configured Branch field value, resolved compatibility ref, Discourse version,
and exact core commit in every compatibility result.

## Versioning and publication

### RC5 publication record — October 22, 2026

RC5 was published with E01 unresolved and the prior failed testing effort
closed. Publication does not establish complete verification or stable-release
acceptance. The testing-execution failure remains unresolved.

The October 22 existing CI at `676cc4a` completed with configuration, lint,
backend and all four system lanes passing, and seven failed frontend assertions
per target. Those failures are disclosed in the release notes, Known Issues
and testing record.
It does not claim clean CI, completed ESR catch-up, or complete acceptance.
The prior testing campaign remains closed.

Use SemVer prerelease identifiers in the form
`v<MAJOR>.<MINOR>.<PATCH>-rc.<N>` for release candidates. Mark each matching
GitHub Release as a prerelease. If a published RC changes, publish the next
numbered RC rather than moving or reusing its tag.

Publish the stable release only after documentation, required verification and
manual acceptance are complete and no required finding remains unresolved.
The stable tag may identify the same accepted tree as the final RC when no
repository change is required. For subsequent stable releases, increment PATCH
for compatible fixes, MINOR for compatible features, and MAJOR for intentionally
breaking configuration or migration changes.
