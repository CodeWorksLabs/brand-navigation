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

- `brand-navigation` initializer: guarded outlet registration.
- `BrandNavigationBar`: desktop and optional mobile-bar boundary.
- `brand-navigation-menu`: guarded compact mobile header entry.
- `BrandNavigationContent`: shared brand and navigation presentation.
- `brand-navigation` library: audience and safe-link policy.

## Configuration model

`navigation_items` uses Discourse's supported nested `objects` theme setting.
Ordering is the editor's list order. A top-level entry with children becomes a
native `details` submenu; otherwise its URL creates a direct link. Only one
child level is represented by the schema. Top-level entries are grouped into
logical `left` and `right` sections; CSS logical properties keep that layout
usable in both left-to-right and right-to-left interfaces.

Each item can render as icon-and-label, label-only, or icon-only. Labels remain
required and provide accessible names even when visually omitted. An icon-only
entry with no usable icon falls back to visible label text.

## Intentional constraints

Native `details`/`summary` provides keyboard operation and persistent expanded
state without a custom focus state machine. Internal and external URLs use the
same validated setting; `_blank` links automatically receive
`noopener noreferrer`.
