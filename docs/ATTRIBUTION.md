# Attribution and licensing

Brand Navigation was newly authored from its product specifications as an
independent theme component.

See the [authorship and provenance record](PROVENANCE.md) for the AI-assisted
authorship model, pinned upstream revisions, implementation-history evidence,
and release controls behind this summary.

## Product inspiration

The following projects informed product discovery, administrator workflows, or
presentation choices. Brand Navigation does not incorporate source code from
these projects merely because they inspired a feature or demonstrated a common
Discourse theme-component pattern.

- [Discourse Brand Header](https://github.com/discourse/discourse-brand-header)
  demonstrated a distinct, site-wide brand surface.
- [Discourse Header Submenus](https://github.com/discourse/discourse-header-submenus)
  demonstrated structured header navigation and exposed administration and
  usability concerns that Brand Navigation addresses independently.
- [Pavilion Dropdown Header](https://github.com/paviliondev/discourse-dropdown-header)
  informed exploration of descriptive dropdown presentation and coexistence
  with other header components.
- [Custom Header Links (icons)](https://github.com/discourse/discourse-icon-header-links)
  demonstrated compact, accessible destinations registered in Discourse's core
  header.

## Adapted implementation pattern

Brand Navigation's core-header icon integration uses Discourse's documented
`api.headerIcons` API. Its narrow `curryComponent` registration pattern was
adapted from Custom Header Links (icons): importing `curryComponent`, binding a
component and its arguments to the Discourse owner, and supplying the result to
`api.headerIcons.add`.

Permanent upstream reference:
[initialize-for-header-icon-links.gjs at `dee14e3`](https://github.com/discourse/discourse-icon-header-links/blob/dee14e37185e5e4db38497bd952352405a5826af/javascripts/discourse/initializers/initialize-for-header-icon-links.gjs#L1-L27).

Custom Header Links (icons) supplies GPL version 2 license text. Brand
Navigation declares `GPL-2.0-or-later` and preserves the permanent upstream
reference above. No other copied or adapted external code is currently
identified. If future work copies or adapts code, this record and any required
copyright or license notice must be updated in the same change.
