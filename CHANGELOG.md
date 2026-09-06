# Changelog

Brand Navigation follows [Semantic Versioning](https://semver.org/). Git tags
and matching GitHub Releases identify published versions; Discourse continues
to discover component updates from commits on the installed remote branch.

## Unreleased

- Formalize release versioning and compatibility evidence.
- Remediate the findings from complete codebase review
  `BN-CODEBASE-20260905`.
- Serialize structured object settings for Discourse's administrator update
  endpoint while retaining parsed values in the local settings model.
- Add the standard Ruby development harness and compatible theme-test imports
  required by the official Discourse component workflow.
- Pin the Ruby lint-tool versions used by verification CI.

The first tagged preview candidate is planned as `v0.9.0` after correction
review and required runtime verification. Version `v1.0.0` is reserved for the
documented, multi-site-tested release with no known release blockers.
