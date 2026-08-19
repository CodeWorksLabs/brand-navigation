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

In Discourse, open **Admin → Customize → Themes → Components → Install** and
install this repository, then attach **Brand Navigation** to a theme.

The component starts with safe defaults: the brand area is enabled but empty,
navigation is empty, and mobile uses a compact menu. Configure the brand first,
then add navigation entries through the structured `navigation_items` editor.

## Navigation model

Each top-level item may be either:

- a direct link, when it has a URL and no children; or
- a submenu, when it has one or more children.

Only one child level is supported intentionally. Visibility can be `everyone`,
`anonymous`, or `authenticated`. Use `_self` for normal forum navigation and
`_blank` only when a new browsing context is genuinely useful.

See [`docs/`](docs/) for scope, architecture, migration, testing, attribution,
and release procedures.

## Support status

This independent-stage repository does not use Discourse logos, official
badges, or language implying Discourse ownership or maintenance. If accepted
by Discourse in the future, maintainers may rename or transfer it according to
their conventions.

## License

MIT. See [LICENSE](LICENSE) and [docs/ATTRIBUTION.md](docs/ATTRIBUTION.md).
