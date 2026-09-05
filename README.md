# Brand Navigation

> A brand header and submenu navigation theme component for Discourse.

Brand Navigation provides an optional brand identity and one-level navigation
hierarchy in a single responsive, accessible component. It is independently
maintained and is not an official Discourse product.

## Product guarantees

- Brand and navigation content renders on normal Discourse application pages.
- It never mounts in supported Discourse embed contexts.
- Desktop navigation and intentional mobile bar, menu, or hidden modes.
- Structured object settings with validation instead of delimiter-based text.
- Internal and external destinations, visibility rules, logos, names, and icons.
- Keyboard-operable submenus built with native `details` and `summary` elements.
- No DiscussionBridge-specific code or changes to Discourse authentication.

## Installation

In Discourse, open **Admin → Appearance → Themes & components**, select the
**Components** tab, and install this repository from its Git URL. Then include
**Brand Navigation** on the theme or themes that should use it.

The current testing release includes a visible sample brand and navigation set
that demonstrates direct links, a submenu, an external link, icons, and
audience visibility. Replace the sample values with site-specific content
before production use. Mobile uses a compact menu by default.

## Navigation model

Each top-level item may be either:

- a direct link, when it has a URL and no children; or
- a submenu, when it has one or more children.

Only one child level is supported intentionally. Visibility can be `everyone`,
`anonymous`, or `authenticated`. Use `_self` for normal forum navigation and
`_blank` only when a new browsing context is genuinely useful.

Start with the [administrator guide](docs/USER_GUIDE.md) for installation,
configuration, verification, and troubleshooting. See [`docs/`](docs/) for
scope, architecture, migration, testing, and release procedures.

## Thanks

Brand Navigation was newly authored from its product specifications. Thanks to
[Discourse Brand Header](https://github.com/discourse/discourse-brand-header)
and
[Discourse Header Submenus](https://github.com/discourse/discourse-header-submenus)
for product inspiration and for their contributions to the Discourse theme
component ecosystem.

## Support status

This independent-stage repository does not use Discourse logos, official
badges, or language implying Discourse ownership or maintenance. If accepted
by Discourse in the future, maintainers may rename or transfer it according to
their conventions.

## License

Copyright (c) 2026 CodeWorksLabs. Licensed under the
[GNU General Public License, version 2 or later](LICENSE)
(`GPL-2.0-or-later`).
