# Release procedure

1. Confirm the default branch is `main`.
2. Run all lint, type, unit, and system-test gates.
3. Execute the manual acceptance matrix in `TESTING.md`.
4. Verify the migration and rollback procedures on a staging theme.
5. Review dependency and Discourse compatibility changes.
6. Confirm the README thanks and product-inspiration credit remain accurate.
7. Confirm no secrets, site-specific hosts, DiscussionBridge logic, official
   badges, Discourse logos, or official-status claims are present.
8. Confirm `Brand Navigation` and `brand-navigation` remain appropriate for the
   independent release stage.
9. Tag the tested commit and publish release notes with upgrade and rollback
   guidance.

If Discourse accepts and maintains the component, follow maintainer direction
for repository transfer, naming, metadata, branding, compatibility, and
release procedures.
