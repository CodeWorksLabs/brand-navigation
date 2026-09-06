# Release procedure

Workflow dependencies are pinned to reviewed commit SHAs. Before changing a
pin, resolve the intended upstream version, review its source and release notes,
then run both workflows on the candidate. Retain the human-readable upstream
major tag in the adjacent YAML comment.

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

`main` is the stable update channel used by ordinary Discourse remote-component
installations. Build changes on short-lived branches and merge only a complete,
reviewed batch. Discourse update detection remains commit-based; release tags
provide durable human and rollback identities. Record both the version and
short commit in every compatibility result.

Use `v0.9.x` for reviewed preview releases. Publish `v1.0.0` only after the
documentation and planned multi-site compatibility work are complete and no
known release blocker remains. After `v1.0.0`, increment PATCH for compatible
fixes, MINOR for compatible features, and MAJOR for intentionally breaking
configuration or migration changes.

If Discourse accepts and maintains the component, follow maintainer direction
for repository transfer, naming, metadata, branding, compatibility, and
release procedures.
