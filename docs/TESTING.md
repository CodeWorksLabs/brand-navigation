# Testing and acceptance

## Automated gates

- JavaScript, template, style, formatting, and type linting.
- Discourse shared core-feature system specification.
- Normal-page rendering of brand, direct links, and native submenu.
- Mobile compact-menu behavior.
- Negative render assertion for `embed_mode=true`.
- Unit coverage for audience visibility and `_blank` link safety.
- Unit coverage for left/right navigation section grouping.
- Unit coverage for icon/label presentation and missing-icon fallback.

## Manual acceptance matrix

Test the current stable and tests-passed Discourse branches where practical.

| Context                    | Required result                                                             |
| -------------------------- | --------------------------------------------------------------------------- |
| Desktop, anonymous         | Allowed brand and links render; keyboard opens submenus                     |
| Desktop, authenticated     | Authenticated entries render; anonymous-only entries do not                 |
| Mobile menu                | One header control opens usable brand navigation                            |
| Mobile bar                 | Responsive bar scrolls navigation without covering core controls            |
| Mobile hidden              | No brand-navigation surface renders                                         |
| Light/dark schemes         | Correct logo fallback and readable scheme colors                            |
| RTL locale                 | Logical positioning and submenu alignment remain usable                     |
| `embed_mode=true` full app | No bar or mobile trigger mounts                                             |
| Classic embedded comments  | No global brand/navigation content appears                                  |
| Embedded interaction       | Core topic, sign-in, reply, like, quote, and composer behavior is unchanged |
| Normal sign-in             | Full-application sign-in remains core Discourse behavior                    |

Also test long labels, empty configuration, missing optional icons, external
links, browser zoom, reduced viewport width, keyboard-only use, and screen
reader navigation landmarks.
