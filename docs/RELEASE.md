# Release procedure

Workflow dependencies are pinned to reviewed commit SHAs. Before changing a
pin, resolve the intended upstream version, review its source and release notes,
then run both workflows on the candidate. Retain the human-readable upstream
major tag in the adjacent YAML comment.

1. Confirm the default branch is `main`.
2. Run all lint, type, configuration, unit, and system-test gates.
3. Execute the manual acceptance matrix in `TESTING.md`.
4. Verify the migration and rollback procedures on a staging theme.
5. Review dependency and Discourse compatibility changes.
6. Confirm the README thanks and product-inspiration credit remain accurate.
7. Confirm no secrets, site-specific hosts in executable defaults, special
   DiscussionBridge logic, official badges, Discourse logos, or official-status
   claims are present. Named compatibility evidence and migration fixtures may
   retain their necessary site origins.
8. Confirm `Brand Navigation` and `brand-navigation` remain appropriate for the
   independent release stage.
9. Confirm `CHANGELOG.md` moves the released entries out of **Unreleased**.
10. Tag the exact tested commit as `vMAJOR.MINOR.PATCH` and publish a matching
    GitHub Release with compatibility, upgrade, migration, and rollback notes.

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
