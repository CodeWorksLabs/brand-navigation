# Brand Navigation

[![Release v1.0.0-rc.2](https://img.shields.io/badge/release-v1.0.0--rc.2-orange)](https://github.com/CodeWorksLabs/brand-navigation/releases/tag/v1.0.0-rc.2)

Give your Discourse community a recognizable identity and clear navigation.
Brand Navigation adds a branded bar with your logo, useful links and dropdown
menus. It can also add links to Discourse's own header. It is independently
maintained, not an official Discourse product.

**[Install](#installation) · [Documentation](https://docs.codeworkslabs.dev/brand-navigation/) · [Live examples](#preview)**

## What Brand Navigation does

- **Give your forum its own identity.** Display your brand name, a logo, or
  both, with separate logos for light and dark themes. Place the navigation
  bar above or below Discourse's header.
- **Organize links into useful menus.** Add direct links and one level of
  dropdowns. A parent can open a page while a separate arrow opens its menu,
  or act only as a menu heading. Use text, icons and optional descriptions.
- **Adapt navigation to your visitors.** Choose which items appear for
  signed-in or signed-out visitors and on desktop or mobile. On phones, use
  a compact menu, a wrapping bar, or hide the component.
- **Fit your forum's colors.** Follow the active light/dark palette by
  default, or customize the bar, dropdowns and header-icon colors.
- **Manage everything in Discourse.** Edit Menu item and Submenu item rows
  in the component settings, then export a backup or import your saved
  configuration on another installation.
- **Add optional links to the core header.** Place text, icons, or both beside
  the forum logo or before the native header controls. Choose alignment,
  same-tab/new-tab behavior and separate normal/hover icon colors.

## Preview

Compare these live configurations. Site content and navigation may change
after the screenshots are captured.

### Repeal OBBBA Forum

[Open the live forum](https://forum.repealobbba.org/)

![Repeal OBBBA Forum: red brand bar, dropdowns and social icons](docs/images/previews/repeal-obbba-header.png)

### The Bridge demonstration site

[Open the live demo](https://bridge.demo.discussionbridge.dev/)

![The Bridge: publishing, release and ecosystem navigation](docs/images/previews/the-bridge-header.png)

In this screenshot, the “Versions & Status” text link is supplied by the
separate Custom Header Links component.

### RVing Community

[Open the live community](https://www.rving.community/)

![RVing Community: blue brand bar, community menus and sign-up controls](docs/images/previews/rving-community-header.png)

## Installation

In **Admin → Appearance → Themes & components → Components**, choose
**Install → From a git repository**:

```text
https://github.com/CodeWorksLabs/brand-navigation.git
```

Start on a non-default staging theme. Attach Brand Navigation there, turn its
native **Enabled?** control on, then use Discourse's theme **Preview** to
configure and verify it before attaching it to visitor-facing themes.

If the component is already used by a live theme, use a separate test copy or
staging site. Themes attached to the same component share its code and settings.

**Enabled?** is the only activation switch. A disabled component cannot load
its custom bundle panel. Follow the
[administrator guide](docs/USER_GUIDE.md#install-the-component) for setup,
bundle import and verification. Sample navigation is included.

## Known working Discourse versions

Recorded checks cover Discourse 2026.7 ESR, 2026.8 and 2026.9 installations.
See the [testing record](docs/TESTING.md) for exact builds and limits—not a
blanket compatibility or accessibility guarantee. Keep labels short on narrow
screens; header space is finite.

## In use on

Alongside the previews above, recorded installations include
[DiscussionBridge Forum](https://forum.discussionbridge.dev/),
[Citizen Activist Network](https://forum.citizenactivist.network/),
[R744 Community](https://www.r744.community/) and the
[DiscussionBridge sandbox](https://sandbox-forum.discussionbridge.dev/).
They do not necessarily run the same revision; consult the testing record.

## Navigation model

Use direct links, submenu-only groups, or linked parents with separate carets.
Core-header destinations are direct links, not submenus. See the
[administrator guide](docs/USER_GUIDE.md) and [technical reference](docs/) for
configuration, architecture, testing and [project history](docs/PROJECT_HISTORY.md).

## Versions and updates

Use Discourse's component updater to check for updates. Back up your settings
and read the [changelog](CHANGELOG.md) first. Versioned downloads and their
notes are available from
[GitHub Releases](https://github.com/CodeWorksLabs/brand-navigation/releases).

`main` targets current Discourse; maintained older versions use
`d-compat/<YYYY>.<M>`. Review
[migration and rollback](docs/MIGRATION.md#roll-back-brand-navigation-to-a-release-tag)
and its testing limits before restoring an earlier version and updating again. Older
compatibility branches may not include every feature shown here.

## Translations

English is bundled; administrators can override interface text in **Theme
translations**. Detailed validation messages remain English. Configured link
labels are shared site content, not per-locale translations.

## Thanks

Brand Navigation was newly authored from its specifications. Thanks to
[Discourse Brand Header](https://github.com/discourse/discourse-brand-header)
and
[Discourse Header Submenus](https://github.com/discourse/discourse-header-submenus)
for product inspiration, and
[Custom Header Links (icons)](https://github.com/discourse/discourse-icon-header-links)
for demonstrating compact header destinations. Pavilion's
[Dropdown Header](https://github.com/paviliondev/discourse-dropdown-header)
also informed presentation and administration exploration. The current header
binding is independently authored using Discourse's documented API. See
[attribution and licensing](docs/ATTRIBUTION.md) and
[authorship and provenance](docs/PROVENANCE.md) for precise source credits.

## Support

Ask questions or report bugs through
[GitHub Issues](https://github.com/CodeWorksLabs/brand-navigation/issues).
Include component/Discourse versions, theme, browser/device, reproduction steps
and sanitized settings. Never post credentials, personal data or private vulnerability details;
report suspected vulnerabilities to
[security@codeworkslabs.dev](mailto:security@codeworkslabs.dev) under the
[security policy](SECURITY.md).

## License

Copyright (c) 2026 CodeWorksLabs. Licensed under the
[GNU General Public License, version 2 or later](LICENSE)
(`GPL-2.0-or-later`).
