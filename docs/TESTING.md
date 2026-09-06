# Testing and acceptance

## In use on

### Verified installations

| Site                     | Discourse build       | Core commit  | Verified Brand Navigation coverage                                                                                                                    |
| ------------------------ | --------------------- | ------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------- |
| Repeal OBBBA Forum       | `2026.7.0-latest+319` | `988c31e00f` | Authenticated desktop render, linked parents and submenus, visible descriptions, core-header icons, administrator settings, and component coexistence |
| DiscussionBridge sandbox | `2026.9.0-latest+307` | `b8565672b9` | Authenticated normal-page render and administrator component/settings surface                                                                         |

The builds above were read directly from each site's administrator dashboard on
2026-09-05. They are evidence of known compatibility, not minimum-version
declarations. Features not named in a row should be evaluated through the
acceptance matrix below before claiming coverage on that environment.

## Verification candidate record

The `v0.9.0` candidate is maintained on
`codex/v0.9.0-verification` in draft pull request
`https://github.com/CodeWorksLabs/brand-navigation/pull/1`. At implementation
commit `13005b7`, official Discourse Theme workflow run `34010799758` passed
linting, English-locale validation, frontend QUnit, backend, and Ruby system
tests. Configuration workflow run `34010799448` passed all 18 Node bundle tests.

The same branch was installed as sandbox component id `2` and verified for the
desktop, 390px mobile menu/bar/hidden, keyboard submenu, safe external-link,
structured import, site-header icon, full-app embed-exclusion, and structured
editor save-stay cases. Classic embedded comments remain unverified because the
sandbox has no embed hosts configured. Anonymous browser, light/dark, RTL,
screen-reader, current export-download delivery, and older-version checks also
remain open manual cases; automated visibility/export logic is green.

After pull request 1 merged as `e22dce2`, sandbox component id `2` was switched
to `main` and reported up to date. A focused post-merge smoke test reconfirmed
authenticated normal rendering, safe submenu behavior and Escape focus return,
successful structured re-import with reload persistence, and complete
Brand Navigation exclusion from `?embed_mode=true` while core main content
remained. No production or consumer site was changed during this check.

## Planned compatibility targets

- Install and fully configure on `https://forum.discussionbridge.dev/`, then use
  `https://bridge.demo.discussionbridge.dev/` as the paired downstream embed
  exclusion test rather than as a theme-component installation target.
- `https://www.r744.community/` runs Discourse `2026.2.0-latest` and is the
  planned older-version installation target. Brand Navigation has not yet been
  installed or tested there, so this version is not listed as known working.
- After the primary pair and older-version target, expand validation to
  `https://forum.citizenactivist.network/` and
  `https://www.rving.community/`.

## Automated gates

- JavaScript, template, style, formatting, and type linting.
- Discourse shared core-feature system specification.
- Normal-page rendering of brand, direct links, and native submenu.
- Mobile compact-menu behavior.
- Negative render assertion for `embed_mode=true`.
- Unit coverage for audience visibility and `_blank` link safety.
- Unit coverage for backward-compatible desktop/mobile item visibility.
- Unit coverage for left/right navigation section grouping.
- Unit coverage for excluding site-header items from the brand bar.
- Unit coverage for optional visible submenu descriptions.
- Unit coverage for icon/label presentation and missing-icon fallback.
- Scoped administrator save behavior that remains in the navigation editor.
- Fail-closed bundle schema, URL, size, nested-field, and conditional validation.
- Canonical HTTPS CLI origins, redirect refusal, bounded responses, and safe
  error output.
- Exact component identity for administrator extensions, complete client
  preflight, and one bundle update request.

## Manual acceptance matrix

Test the current stable and tests-passed Discourse branches where practical.

| Context                     | Required result                                                                                         |
| --------------------------- | ------------------------------------------------------------------------------------------------------- |
| Desktop, anonymous          | Allowed links render; only one submenu opens and Escape restores focus                                  |
| Desktop, authenticated      | Authenticated entries render; anonymous-only entries do not                                             |
| Mobile menu                 | One header control opens usable brand navigation                                                        |
| Mobile bar                  | Responsive bar wraps navigation and exposes unclipped submenus                                          |
| Mobile hidden               | No brand-navigation surface renders                                                                     |
| Site-header item            | Direct icon appears once with its tooltip, audience, target, and safe rel                               |
| Device-specific item        | Renders only for its selected device class, unchanged across phone rotation                             |
| Descriptive submenu         | Description appears below its label; empty entries remain compact                                       |
| Administrator object save   | Settings persist and the structured editor remains open                                                 |
| Administrator bundle import | Complete bundle preflight occurs before one update request; reload after a server error before retrying |
| Light/dark schemes          | Correct logo fallback and readable scheme colors                                                        |
| RTL locale                  | Logical positioning and submenu alignment remain usable                                                 |
| `embed_mode=true` full app  | No bar or mobile trigger mounts                                                                         |
| Classic embedded comments   | No global brand/navigation content appears                                                              |
| Embedded interaction        | Core topic, sign-in, reply, like, quote, and composer behavior is unchanged                             |
| Normal sign-in              | Full-application sign-in remains core Discourse behavior                                                |

Also test long labels, empty configuration, missing optional icons, external
links, browser zoom, reduced viewport width, keyboard-only use, and screen
reader navigation landmarks.
