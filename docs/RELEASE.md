# Release procedure

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

## Release gates

Before completing that sequence:

1. Confirm the default branch is `main`.
2. Run all lint, type, configuration, unit, and system-test gates.
3. Execute the manual acceptance matrix in `TESTING.md`.
4. Verify the migration and rollback procedures on a staging theme.
5. Review dependency and Discourse compatibility changes.
6. Confirm every referenced translation key exists in `locales/en.yml`, the
   English fallback is complete, and the README and administrator guide state
   which languages are bundled. Treat additional locale files as reviewed
   release content.
7. Confirm the README thanks and product-inspiration credit remain accurate and
   `docs/ATTRIBUTION.md` identifies any copied or adapted code precisely.
8. Confirm no secrets, site-specific hosts in executable defaults, special
   DiscussionBridge logic, official badges, Discourse logos, or official-status
   claims are present. Named compatibility evidence and migration fixtures may
   retain their necessary site origins.
9. Confirm `Brand Navigation` and `brand-navigation` remain appropriate for the
   independent release stage.
10. Confirm `CHANGELOG.md` moves the released entries out of **Unreleased**.
11. Confirm the accepted candidate, merged tree, `v0.9.0` tag, and GitHub
    Release all identify the same tree. Include compatibility, upgrade,
    migration, and rollback notes in the release.

## Public documentation direction and open questions

The selected direction is a shared CodeWorksLabs documentation site at
`https://docs.codeworkslabs.dev/` plus platform-oriented discovery sites such
as `discourse.codeworkslabs.dev` and `astro.codeworkslabs.dev`. Brand Navigation
would be presented through the Discourse platform site, with its canonical
documentation in the shared documentation site. Mature products that warrant
an independent ecosystem may retain their own domain, documentation, demos,
and support surfaces.

The exact documentation paths, source repository, release-tag synchronization,
shared navigation, deployment ownership, and timing remain under discussion.
The recommended framework split is Astro for public product and platform
surfaces and Starlight for the shared documentation corpus. This direction does
not require a public site for the first Brand Navigation release and does not
authorize creating, publishing, or deploying any site.

`support.codeworkslabs.dev` is the selected durable umbrella support front door.
It may route visitors to documentation, repositories, issue trackers, shared
CodeWorksLabs community resources, or an independent product community as
appropriate. Mature product communities remain independent; in particular,
`forum.discussionbridge.dev` remains the DiscussionBridge community and support
forum. This support-routing decision does not authorize creating or deploying
the support site or a shared CodeWorksLabs forum.

`main` is the stable update channel for current Discourse. Build changes on
short-lived branches and merge only a complete, reviewed batch. Maintained
older Discourse releases use branches named `d-compat/<YYYY>.<M>`. The official
daily compatibility workflow creates a branch for each newly released
Discourse version from the last first-parent `main` commit predating that core
release.

Brand Navigation requires a one-time manual bootstrap for both `2026.7` and
`2026.8`. Seed both branches from released `v0.9.0` merge commit
`d2527bfb3acdcf4204a33d35e0b13504f6d7c36e` before merging or manually running
the scheduled workflow. The workflow fails closed unless both branches contain
that accepted seed, and serialized runs prevent concurrent branch writers. If
either branch already exists at the wrong commit, do not run the workflow:
inspect the ref, correct it through an explicitly authorized release operation,
verify it contains the accepted seed, and only then retry.

When a compatible fix lands on `main`, backport it through a reviewed pull
request whose base is the affected `d-compat` branch. Do not merge new features
or unverified framework changes into compatibility branches. On `main` pull
requests, keep an exact-core CI lane for every Discourse release that Brand
Navigation actively maintains. On a pull request targeting a `d-compat` branch,
Discourse's reusable workflow deliberately selects the matching moving release
branch and Brand Navigation runs one clearly named compatibility-branch lane;
obtain separate exact-core evidence when a backport needs it.
Discourse update detection remains commit-based; release tags provide durable
human and rollback identities. Record the Brand Navigation version, component
commit, compatibility branch, Discourse version, and exact core commit in every
compatibility result.

Use `v0.9.x` for reviewed preview releases. Publish `v1.0.0` only after the
documentation and planned multi-site compatibility work are complete and no
known release blocker remains. After `v1.0.0`, increment PATCH for compatible
fixes, MINOR for compatible features, and MAJOR for intentionally breaking
configuration or migration changes.

If Discourse accepts and maintains the component, follow maintainer direction
for repository transfer, naming, metadata, branding, compatibility, and
release procedures.
