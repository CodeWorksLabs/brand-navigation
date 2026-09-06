# Architecture

## Render boundary

The initializer registers the configured full-application outlet only when
`EmbedMode.enabled` is false. The bar and mobile-menu components repeat the
same guard so an already-registered component still refuses to render if the
context changes.

`EmbedMode` comes from the supported `discourse/lib/embed-mode` module. No
hostname, parent-frame, DOM selector, or CSS visibility test is used.

Classic `/embed/comments` discussions use Discourse's separate server-rendered
embed layout. That layout exposes `embedded_header`, not the normal
`above-site-header`, `below-site-header`, or `home-logo__before` application
outlets used here. Brand Navigation provides no `embedded_header` customization.

Together these boundaries keep site-global content out of both supported embed
paths without touching topic content, navigation, sign-in, reply, like, quote,
or composer behavior.

## Components

- `brand-navigation` initializer: guarded bar outlet and site-header icon
  registration.
- `BrandNavigationBar`: desktop and optional mobile-bar boundary.
- `brand-navigation-menu`: guarded compact mobile header entry.
- `BrandNavigationContent`: shared brand and navigation presentation.
- `BrandNavigationHeaderIcon`: guarded direct links registered through
  Discourse's supported `api.headerIcons` API.
- `brand-navigation` library: audience and safe-link policy.

## Configuration model

`navigation_items` uses Discourse's supported nested `objects` theme setting.
Ordering is the editor's list order. A top-level entry with children uses a
native `details` submenu. When that entry also has a URL, its label remains a
normal link and a separate summary caret controls the submenu; without a URL,
the complete summary is the submenu control. Only one child level is represented
by the schema. Top-level entries are grouped into
logical `left` and `right` sections; CSS logical properties keep that layout
usable in both left-to-right and right-to-left interfaces.

The objects editor uses the component-specific schema identity
`brand_navigation_item_v1`. Administrator extensions require either that
identity or the exact canonical remote repository; mutable names and URL
substrings do not grant write scope. Bundle imports validate the complete
portable schema, preflight the target, and submit one Discourse theme update so
individual settings are not committed piecemeal.

Top-level items with the `site_header` surface are excluded from the bar and
registered as direct icon links through `api.headerIcons`. They require a URL
and icon and do not support children. The registration uses `curryComponent`,
adapting the established GPL-2.0 pattern in Discourse Icon Header Links.

Each item can render as icon-and-label, label-only, or icon-only. Labels remain
required and provide accessible names even when visually omitted. An icon-only
entry with no usable icon falls back to visible label text. Top-level and child
items independently select `both`, `desktop`, or `mobile` device visibility.
The components evaluate that setting against Discourse's supported
`capabilities.isMobileDevice` state and omit nonmatching items from rendering,
so phone rotation cannot reclassify items. Component-wide responsive layout
continues to use `site.mobileView` through the bar and menu boundaries.

Navigation sinks independently recheck URL safety and fail closed for malformed,
protocol-relative, credential-bearing, non-HTTPS external, and script URLs.
The optional CLI restricts administrator credentials to a canonical HTTPS
origin, refuses redirects, and bounds response time, size, and terminal output.

## Intentional constraints

Native `details`/`summary` provides keyboard operation without a custom focus
state machine. Brand Navigation permits one open submenu at a time and closes
it after outside interaction, Escape, or link selection. Escape returns focus
to the submenu summary. Internal and external URLs use the same validated
setting; `_blank` links automatically receive `noopener noreferrer`.
