# Brand Navigation

> A brand header and submenu navigation theme component for Discourse.

Brand Navigation gives a Discourse site one coherent place for brand identity,
primary links, submenus, and compact header icons. It is responsive,
keyboard-aware, straightforward to administer, and independently maintained.
It is not an official Discourse product. Automated accessibility coverage is
supplemented by the explicit manual evidence and open checks in the
[testing record](docs/TESTING.md).

## What Brand Navigation does

- Adds an optional logo, brand name, destination, and light/dark logo pairing.
- Supports direct links, submenu-only groups, and linked parents with a separate
  submenu caret.
- Organizes top-level items into left and right sections with intentional
  one-level dropdown navigation.
- Moves compact destinations such as social links into the Discourse core
  header when navigation-bar space is limited.
- Controls every item's audience and desktop/mobile visibility independently.
- Provides responsive mobile menu, full-bar, and hidden presentation modes.
- Offers administrator color controls for the bar, text, hover state, and
  submenus while allowing each value to inherit the active Discourse palette.
- Imports and exports validated, versioned JSON configuration bundles for
  migration, backup, and repeatable multi-site setup.
- Uses structured object settings with validation rather than delimiter-based
  configuration text.
- Provides keyboard-operable submenus, accessible labels, safe new-window
  links, and graceful icon fallbacks.
- Ships translation-ready interface text that administrators can override per
  locale.
- Renders on normal Discourse application pages but never mounts in supported
  Discourse embed contexts.
- Leaves Discourse authentication, topic navigation, and composer behavior
  untouched and contains no DiscussionBridge-specific compatibility code.

## Installation

In Discourse, open **Admin → Appearance → Themes & components**, select the
**Components** tab, choose **Install → From a git repository**, and use:

```text
https://github.com/CodeWorksLabs/brand-navigation.git
```

Then include **Brand Navigation** on the theme or themes that should use it.

The component starts with practical sample navigation and a compact mobile
menu. Configure the structured `navigation_items` editor directly, or use a
validated configuration bundle to move settings without re-entering each row.

## Known working Discourse versions

Brand Navigation has recorded manual and native-update evidence across
Discourse 2026.7 ESR, 2026.8, and 2026.9 installations. Exact builds, core
commits, component refs, dates, and coverage limits change as sites are updated,
so the canonical evidence lives only in the
[testing record](docs/TESTING.md). These known-working builds are not minimum
version declarations.

## In use on

### Production installations

- [Repeal OBBBA Forum](https://forum.repealobbba.org/) — configured navigation,
  descriptions, audience/device visibility, and core-header social icons.
- [DiscussionBridge Forum](https://forum.discussionbridge.dev/) — configured
  navigation and accessible core-header links for GitHub, Bluesky, Discord, and
  YouTube.
- [Citizen Activist Network](https://forum.citizenactivist.network/) —
  configured community and issue navigation.
- [RVing Community](https://www.rving.community/) — configured community and
  RVing Network navigation.
- [R744 Community](https://www.r744.community/) — compatibility installation
  pinned to the Discourse 2026.7 ESR release branch.

### Demonstration installation

- [The Bridge](https://bridge.demo.discussionbridge.dev/) — publishing-focused
  navigation and the same restrained DiscussionBridge social set.

### Test and compatibility installation

- [DiscussionBridge sandbox](https://sandbox-forum.discussionbridge.dev/) —
  current Discourse administrator and rendering checks.

Sites are added here only after Brand Navigation has been installed and its
stated coverage has been verified. These groupings describe site purpose, not
an assurance that every site runs the same component commit. Exact installed
versions and planned checks are tracked in the
[testing record](docs/TESTING.md).

## Navigation model

Each top-level item may be either:

- a direct link, when it has a URL and no children; or
- a submenu trigger, when it has children but no URL; or
- a linked parent with a separate submenu caret, when it has both a URL and
  children.

Only one child level is supported intentionally. Visibility can be `everyone`,
`anonymous`, or `authenticated`. Use `_self` for normal forum navigation and
`_blank` only when a new browsing context is genuinely useful.

Start with the [administrator guide](docs/USER_GUIDE.md) for installation,
configuration, verification, and troubleshooting. See [`docs/`](docs/) for
scope, architecture, migration, testing, and release procedures.

## Versions and updates

Discourse detects updates from commits on the installed remote branch. Brand
Navigation additionally uses Semantic Versioning tags and matching GitHub
Releases as human-readable release, support, and revision-recovery identities.
The same-component procedure is documented in
[Migration and rollback](docs/MIGRATION.md#roll-back-brand-navigation-to-a-release-tag).
Treat it as provisional until the complete pin-and-return workflow is recorded
on staging in the [testing record](docs/TESTING.md).
`main` targets current Discourse; maintained older releases use Discourse's
`d-compat/<YYYY>.<M>` compatibility branches. Development occurs on short-lived
branches, and fixes for an older supported release are reviewed and backported
to its matching compatibility branch.

The reviewed `v0.9.0` preview was published on 2026-09-07. Version `v1.0.0` is
reserved for the documented, multi-site-tested release with no known release
blockers. See the [changelog](CHANGELOG.md) and
[release procedure](docs/RELEASE.md).

## Translations

Brand Navigation uses Discourse's theme-translation system for its visitor
accessibility labels, administration panels, setting descriptions, and status
messages. Detailed bundle-schema validation messages are generated in English.
English is the only language bundled in the `v0.9.x` preview line.
Administrators can provide local per-locale overrides in **Theme
translations**, and reviewed translations are welcome as repository pull
requests.

Navigation labels, tooltips, and visible descriptions entered in component
settings are site content rather than translation keys. The same configured
content is currently shown in every visitor locale. See the
[administrator guide](docs/USER_GUIDE.md#translate-the-interface) for details.

## Thanks

Brand Navigation was newly authored from its product specifications. Thanks to
[Discourse Brand Header](https://github.com/discourse/discourse-brand-header)
and
[Discourse Header Submenus](https://github.com/discourse/discourse-header-submenus)
for product inspiration and for their contributions to the Discourse theme
component ecosystem. Thanks also to
[Custom Header Links (icons)](https://github.com/discourse/discourse-icon-header-links)
for demonstrating compact, accessible icon destinations in the core header.
Brand Navigation's header-icon registration follows Discourse's documented
`api.headerIcons` API. Its current component-binding implementation is
independently authored; the earlier implementation study is preserved in the
provenance record. Pavilion's
[Dropdown Header](https://github.com/paviliondev/discourse-dropdown-header)
also informed the presentation and administration exploration. See
[Attribution and licensing](docs/ATTRIBUTION.md) for the precise source
classifications, and the
[authorship and provenance record](docs/PROVENANCE.md) for the AI-assisted
authorship model and reproducible source ledger.

## Support

Use [GitHub Issues](https://github.com/CodeWorksLabs/brand-navigation/issues)
for bug reports, installation or configuration questions, compatibility
reports, and feature requests. Search existing issues first and, where
relevant, include:

- the Brand Navigation release, branch, or commit;
- the Discourse version and active theme;
- browser, device, viewport, and signed-in state;
- steps to reproduce, expected behavior, and actual behavior; and
- a sanitized configuration bundle or relevant settings and console output.

Never post credentials, personal data, or non-public vulnerability details in
a public issue. A private security-reporting channel is not yet published; for
now, open a detail-free issue requesting private contact. The earlier
[Discourse Meta proposal](https://meta.discourse.org/t/combining-brand-header-and-header-submenus-plugins/389913)
is historical product-discussion context, not a Brand Navigation support desk.

This independent-stage repository does not use Discourse logos, official
badges, or language implying Discourse ownership or maintenance. If accepted
by Discourse in the future, maintainers may rename or transfer it according to
their conventions.

## License

Copyright (c) 2026 CodeWorksLabs. Licensed under the
[GNU General Public License, version 2 or later](LICENSE)
(`GPL-2.0-or-later`).
