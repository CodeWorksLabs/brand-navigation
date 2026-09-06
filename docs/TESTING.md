# Testing and acceptance

## Automated gates

- JavaScript, template, style, formatting, and type linting.
- Discourse shared core-feature system specification.
- Normal-page rendering of brand, direct links, and native submenu.
- Mobile compact-menu behavior.
- Negative render assertion for `embed_mode=true`.
- Unit coverage for audience visibility and `_blank` link safety.
- Unit coverage for left/right navigation section grouping.
- Unit coverage for excluding site-header items from the brand bar.
- Unit coverage for optional visible submenu descriptions.
- Unit coverage for icon/label presentation and missing-icon fallback.
- Scoped administrator save behavior that remains in the navigation editor.

## Manual acceptance matrix

Test the current stable and tests-passed Discourse branches where practical.

| Context                    | Required result                                                             |
| -------------------------- | --------------------------------------------------------------------------- |
| Desktop, anonymous         | Allowed links render; only one submenu opens and Escape restores focus      |
| Desktop, authenticated     | Authenticated entries render; anonymous-only entries do not                 |
| Mobile menu                | One header control opens usable brand navigation                            |
| Mobile bar                 | Responsive bar scrolls navigation without covering core controls            |
| Mobile hidden              | No brand-navigation surface renders                                         |
| Site-header item           | Direct icon appears once with its tooltip, audience, target, and safe rel   |
| Descriptive submenu        | Description appears below its label; empty entries remain compact           |
| Administrator object save  | Settings persist and the structured editor remains open                     |
| Light/dark schemes         | Correct logo fallback and readable scheme colors                            |
| RTL locale                 | Logical positioning and submenu alignment remain usable                     |
| `embed_mode=true` full app | No bar or mobile trigger mounts                                             |
| Classic embedded comments  | No global brand/navigation content appears                                  |
| Embedded interaction       | Core topic, sign-in, reply, like, quote, and composer behavior is unchanged |
| Normal sign-in             | Full-application sign-in remains core Discourse behavior                    |

Also test long labels, empty configuration, missing optional icons, external
links, browser zoom, reduced viewport width, keyboard-only use, and screen
reader navigation landmarks.
