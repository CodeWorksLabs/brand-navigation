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
`brand_navigation_item_v1`. Its save-stay behavior requires that identity. The
component-wide appearance and bundle panel requires a theme component with the
five-setting Brand Navigation signature. This avoids repository-location and
mutable-name coupling while failing closed for incomplete signatures; it is a
product signature, not cryptographic identity. Bundle imports validate the
complete portable schema, preflight every target, snapshot the submitted data,
and submit one Discourse theme update rather than issuing a separate request
for each setting. While a request is pending, conflicting controls are disabled.
After success, the model and appearance controls reconcile from the submitted
snapshot. This does not assert a server-side transaction guarantee; after a
server error, reload the current settings before retrying.

Top-level items with the `site_header` surface are excluded from the bar and
registered as direct icon links through `api.headerIcons`. They require a URL
and icon and do not support children. A locally authored lexical component
factory binds each validated item to its header component without
repository-specific owner state.

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
The optional local bundle validator reads bounded files and never connects to a
forum. Browser import/export uses the authenticated Discourse administrator
session and the component's administration page.

## Intentional constraints

Native `details`/`summary` provides keyboard operation without a custom focus
state machine. Brand Navigation permits one open submenu at a time and closes
it after outside interaction, Escape, or link selection. Escape returns focus
to the submenu summary. Internal and external URLs use the same validated
setting; `_blank` links automatically receive `noopener noreferrer`.
