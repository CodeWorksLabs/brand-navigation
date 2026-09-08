# CodeWorksLabs public-site handoff

Prepared: 2026-09-08

This is the source-backed content bundle for presenting Brand Navigation on the
CodeWorksLabs Astro product site and shared Starlight documentation site. It is
not a deployment specification and does not authorize publishing or changing a
live site. Product, release, compatibility, testing, security, licensing, and
provenance claims remain governed by this repository.

## Evidence snapshot

- Repository basis before this handoff change:
  `d6258226f3019d593f6581b3426b28405f58b5e0`
- Basis tree: `acf4d40deef3018fcb426752ce5b3c02396c94e5`
- Published release: `v1.0.0-rc.1`
- Release commit: `ed1640b049763c37694f8c3bb5f9f69cbd21f658`
- Release tree: `f3b97c11c93dc00c2e66df346ec4c0b032ab5581`
- Annotated tag object: `06c7b0386eef69f4ad358aa9f0e7590558975ef9`
- Repository: <https://github.com/CodeWorksLabs/brand-navigation>
- Release: <https://github.com/CodeWorksLabs/brand-navigation/releases/tag/v1.0.0-rc.1>

The basis commit is a documentation commit one commit beyond the published
release tree. This handoff also changes documentation only; it does not change
the published component runtime. Resolve moving refs again before publication;
never replace or move the published tag.

## Settled CodeWorksLabs site architecture

Use the following ownership model:

| Host                                | Role                                                                               | Status at handoff                                                                   |
| ----------------------------------- | ---------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------- |
| `codeworkslabs.dev`                 | CodeWorksLabs apex, product catalog, and Brand Navigation product page             | Settled architecture; not DNS-resolvable from the handoff environment on 2026-09-08 |
| `docs.codeworkslabs.dev`            | Astro Starlight documentation for all CodeWorksLabs products                       | Settled architecture; not DNS-resolvable from the handoff environment on 2026-09-08 |
| `demo.codeworkslabs.dev`            | Demo index and chooser                                                             | Settled architecture; not DNS-resolvable from the handoff environment on 2026-09-08 |
| `astro.demo.codeworkslabs.dev`      | Astro-specific demos                                                               | Settled architecture; not DNS-resolvable from the handoff environment on 2026-09-08 |
| `discourse.demo.codeworkslabs.dev`  | Discourse-specific demos, including the eventual Brand Navigation demo destination | Settled architecture; not DNS-resolvable from the handoff environment on 2026-09-08 |
| `{platform}.demo.codeworkslabs.dev` | Future platform-specific demos                                                     | Naming convention only                                                              |

Do not restore the older proposal that used `discourse.codeworkslabs.dev` and
`astro.codeworkslabs.dev` as platform discovery hubs. Do not present any of the
new hosts as live until the site project verifies DNS, TLS, deployment, and
content at the exact destination.

Suggested routes, subject to the site repository's routing conventions:

- apex product page: `/products/brand-navigation/`
- Starlight documentation root: `/brand-navigation/`
- demo chooser entry: `/brand-navigation/`
- platform demo: a Brand Navigation route under
  `discourse.demo.codeworkslabs.dev`

## Public-ready identity

| Field                   | Approved content                                                              |
| ----------------------- | ----------------------------------------------------------------------------- |
| Product name            | Brand Navigation                                                              |
| Repository slug         | `brand-navigation`                                                            |
| Category                | Discourse theme component                                                     |
| One-line description    | A brand header and submenu navigation theme component for Discourse.          |
| Maintainer              | CodeWorksLabs                                                                 |
| Independence statement  | Independently maintained by CodeWorksLabs. Not an official Discourse product. |
| License                 | GNU General Public License, version 2 or later (`GPL-2.0-or-later`)           |
| Current release         | `v1.0.0-rc.1` prerelease, published 2026-09-08                                |
| Stable release status   | `v1.0.0` has not been published                                               |
| Installation repository | `https://github.com/CodeWorksLabs/brand-navigation.git`                       |

The public presentation must not use a Discourse logo, an official badge, or
language that implies Discourse ownership, endorsement, or maintenance.

## Copy deck

### Catalog card

**Brand Navigation**

A responsive brand header and one-level navigation component for Discourse,
with structured administration, mobile layouts, accessible interaction, and
safe configuration portability.

Status label: **Release candidate**

Primary action: **View Brand Navigation**

### Product-page hero

Eyebrow: **Discourse theme component**

Heading: **Give your Discourse community a coherent brand and navigation
surface.**

Body:

Brand Navigation combines brand identity, primary links, one-level submenus,
and compact header destinations in one responsive component. Administrators
get structured settings, color inheritance, audience and device visibility,
and validated configuration bundles for repeatable multi-site setup.

Primary action: **Read the documentation**

Secondary actions: **View the release** and **View the source**

Required adjacent note:

Independently maintained by CodeWorksLabs. Not an official Discourse product.

### Short positioning statement

Brand Navigation is for Discourse operators who need more than a row of custom
links but do not want a general page builder. It provides an intentional
one-level navigation model, optional brand identity, responsive presentation,
and an administrator workflow designed for staging and reuse across forums.

### Feature copy

- **One coherent navigation model.** Use direct links, submenu-only groups, or
  linked parents with a separate submenu caret. One child level is supported
  intentionally.
- **Responsive by design.** Choose a compact mobile menu, a wrapping mobile
  bar, or no Brand Navigation mobile surface, with per-item desktop and mobile
  visibility.
- **Audience-aware destinations.** Show items to everyone, anonymous visitors,
  or authenticated members, and place compact destinations in Discourse's
  core header.
- **Administrator-friendly configuration.** Work with structured object
  settings, validated inputs, palette-inheriting color controls, and sample
  navigation instead of delimiter-based text.
- **Portable setup.** Export and import versioned JSON configuration bundles
  through the administrator browser workflow for backup and repeatable
  multi-site preparation.
- **Accessible interaction.** Keyboard-operable submenus, accessible names,
  visible descriptions, safe new-window links, and graceful icon fallbacks are
  covered by automated and bounded manual evidence.
- **Embed-safe boundaries.** Brand Navigation does not mount in supported
  Discourse embed contexts and leaves core topic, authentication, reply, like,
  quote, and composer behavior to Discourse.
- **Native updates.** Current Discourse follows `main`; maintained older
  releases can follow Discourse-compatible `d-compat/<YYYY>.<M>` branches
  through the normal remote-theme updater.

## Installation copy

In Discourse, open **Admin → Appearance → Themes & components**, select
**Components**, choose **Install → From a git repository**, and enter:

```text
https://github.com/CodeWorksLabs/brand-navigation.git
```

For preparation, attach the enabled component only to a non-default staging
theme and use Discourse's theme preview. Configure or import the navigation,
verify it there, and attach the component to a visitor-facing theme only when
it is ready. Discourse's component-level **Enabled?** control is the single
activation switch; Brand Navigation has no second enable setting.

The public site should link to the complete [administrator guide](USER_GUIDE.md)
instead of reproducing advanced bundle, update, disable, or troubleshooting
procedures.

## Compatibility copy and claim limits

Public-ready summary:

> Brand Navigation has recorded manual, automated, and native-update evidence
> across Discourse 2026.7 ESR, 2026.8, and 2026.9 installations. These are
> known-working records, not minimum-version declarations. See the testing
> record for exact builds, commits, refs, contexts, and open checks.

The detailed evidence includes seven installations recorded in
[`TESTING.md`](TESTING.md): Repeal OBBBA Forum, DiscussionBridge sandbox,
DiscussionBridge Forum, The Bridge, Citizen Activist Network, RVing Community,
and R744 Community. Coverage differs by site. Do not claim that every feature
was tested on every installation or that every site is currently on the same
Brand Navigation commit.

Do not publish any of these unsupported simplifications:

- "supports all Discourse versions";
- "requires Discourse 2026.7 or later";
- "fully accessibility tested" or "WCAG certified";
- "complete RTL acceptance";
- "zero-risk rollback";
- "official Discourse component"; or
- "works in embeds."

The accurate embed claim is that Brand Navigation's site-global surfaces do
not mount in supported Discourse embed contexts. It does not replace or claim
ownership of Discourse's embedded discussion features.

## Release status and limitations

`v1.0.0-rc.1` is the first stable-track release candidate and is a GitHub
prerelease. It uses Discourse's native component activation control, adds the
staging-theme configuration workflow, prevents stale asynchronous bundle reads
from replacing newer administrator input, keeps linked-parent submenu children
in normal mobile flow, and adopts Discourse compatibility branches.

Keep these limits visible in documentation and release-oriented content:

- The complete human screen-reader matrix remains open. A bounded iPhone
  VoiceOver pass and browser accessibility-tree evidence cover specific states
  only.
- Browser/runtime RTL evidence exists, but complete human RTL acceptance is
  not claimed.
- Dense mobile core-header icon sets can crowd Discourse controls. Operators
  should use per-item device visibility to reserve narrow-screen capacity.
- The complete release-tag pin-and-return rollback workflow remains
  provisional until its full staging exercise is recorded.
- Known-working builds are evidence points, not a declared minimum supported
  version.

The site may say that no release-blocking defect was known at the dated
2026-09-08 successor checkpoint. It must not convert that dated statement into
a timeless guarantee.

## Live installations and demo evidence

### Public-ready links with bounded claims

- [The Bridge](https://bridge.demo.discussionbridge.dev/) is the existing
  demonstration installation recorded in `README.md` and `TESTING.md`. The
  testing record documents publishing-focused navigation on Discourse
  `2026.9.0-latest+188` at core commit `7dfd824b1` and a native `main` update.
  The URL returned HTTP 200 during a read-only availability check on
  2026-09-08. That HTTP result alone does not reverify the installed component
  version or interaction matrix.
- [DiscussionBridge sandbox](https://sandbox-forum.discussionbridge.dev/) is a
  test and compatibility installation, not the polished public demo.
- The production installations listed in `README.md` are adoption evidence,
  not substitutes for a controlled product demo.

### Missing demo work

No Brand Navigation demo was verified at `demo.codeworkslabs.dev` or
`discourse.demo.codeworkslabs.dev` for this handoff. The builder may prepare
links and routing for those settled hosts, but must keep them unpublished or
clearly unavailable until deployment and product behavior are verified at the
exact URL.

## Media and asset inventory

The repository contained no PNG, JPEG, WebP, GIF, SVG, video, or other product
media asset at handoff. There is therefore:

- no approved Brand Navigation logo or lockup;
- no repository-sourced product screenshot;
- no demo video;
- no screenshot license or capture provenance to transfer; and
- no authorized use of a Discourse logo or trademark asset.

Do not treat GitHub's automatically generated source archives as product media.
Until approved assets exist, use typography, interface-neutral layout, and
native CodeWorksLabs visual language. Do not scrape screenshots from production
forums.

Recommended future capture set, requiring a separate capture and approval
step:

1. desktop brand bar with a linked parent and open submenu;
2. mobile Brand Navigation menu;
3. administrator structured navigation editor;
4. administrator color controls and configuration-bundle panel; and
5. embed-context comparison showing core Discourse content without a Brand
   Navigation surface.

For every accepted capture, record the source URL, capture date, Brand
Navigation commit/ref, Discourse build and core commit, theme, viewport,
account state, any visible third-party marks or user content, creator, license,
approval, and repository path. Sanitize personal and administrator data.

## Documentation information architecture

The Starlight site can adapt the repository documentation into this order:

1. Overview — product identity, model, feature summary, and independence note.
2. Install — the staging-theme-first installation workflow from
   [`USER_GUIDE.md`](USER_GUIDE.md).
3. Configure — brand, navigation items, colors, visibility, icons, and mobile
   behavior from `USER_GUIDE.md` and [`SCOPE.md`](SCOPE.md).
4. Configuration bundles — browser import/export workflow and limits from
   `USER_GUIDE.md`.
5. Updates and compatibility — native updates, `main`, compatibility branches,
   and the exact evidence in [`TESTING.md`](TESTING.md).
6. Migration and rollback — adapt [`MIGRATION.md`](MIGRATION.md) without
   removing its provisional warning.
7. Troubleshooting — adapt the administrator guide.
8. Release notes — summarize [`CHANGELOG.md`](../CHANGELOG.md) and link each
   immutable GitHub Release.
9. Security — route private reports according to [`SECURITY.md`](../SECURITY.md).
10. Attribution and license — preserve [`ATTRIBUTION.md`](ATTRIBUTION.md),
    [`PROVENANCE.md`](PROVENANCE.md), and the repository license.

The site may improve navigation and presentation, but must not silently fork
procedural or evidentiary truth from the repository.

## Links and calls to action

| Purpose                          | Destination                                                                  | Public status                                 |
| -------------------------------- | ---------------------------------------------------------------------------- | --------------------------------------------- |
| Source                           | <https://github.com/CodeWorksLabs/brand-navigation>                          | Ready                                         |
| Current release                  | <https://github.com/CodeWorksLabs/brand-navigation/releases/tag/v1.0.0-rc.1> | Ready; label as prerelease                    |
| All releases                     | <https://github.com/CodeWorksLabs/brand-navigation/releases>                 | Ready                                         |
| Issues and non-sensitive support | <https://github.com/CodeWorksLabs/brand-navigation/issues>                   | Ready                                         |
| Private security reports         | <mailto:security@codeworkslabs.dev>                                          | Ready according to `SECURITY.md`              |
| License                          | <https://github.com/CodeWorksLabs/brand-navigation/blob/main/LICENSE>        | Ready                                         |
| Contributions                    | Repository pull requests and issues                                          | Ready; no separate contribution guide exists  |
| CodeWorksLabs docs               | `https://docs.codeworkslabs.dev/`                                            | Architecture settled; deployment not verified |
| Demo chooser                     | `https://demo.codeworkslabs.dev/`                                            | Architecture settled; deployment not verified |
| Discourse demos                  | `https://discourse.demo.codeworkslabs.dev/`                                  | Architecture settled; deployment not verified |

For public issues, ask reporters for the Brand Navigation release, branch, or
commit; Discourse version and active theme; browser/device/viewport and sign-in
state; reproduction steps; and sanitized settings or console evidence. Never
ask users to post credentials, personal data, or non-public vulnerability
details in a public issue.

No standalone `CONTRIBUTING.md`, community code of conduct, hosted
documentation, shared support portal, or CodeWorksLabs demo deployment is
presently verified. Do not imply otherwise.

## Provenance and attribution copy

Public-ready summary:

> Brand Navigation was newly authored from its product specifications under
> Phil Henry's product direction, with implementation and documentation
> generated and modified by OpenAI Codex. It is independently maintained by
> CodeWorksLabs and licensed under `GPL-2.0-or-later`.

Discourse Brand Header, Discourse Header Submenus, Pavilion Dropdown Header,
and Custom Header Links (icons) are recorded inspiration or neighboring
components. A narrow historical implementation-stage pattern from Custom
Header Links (icons) was replaced before the first tagged release. Do not
compress these facts into a claim that Brand Navigation is a fork, merger, or
official successor. Link to the full provenance and attribution records when
publishing this summary.

## Canonical-source contract

These subjects must remain sourced from the Brand Navigation repository:

- current version, release identity, release notes, and upgrade warnings;
- install, configuration-bundle, update, migration, rollback, and disable
  procedures;
- supported-line and known-working compatibility evidence;
- manual and automated testing claims and their limits;
- security intake and supported-version policy;
- license, authorship, attribution, and source provenance;
- product invariants, especially embed exclusion and one-level navigation; and
- residual risks and open acceptance gates.

The CodeWorksLabs site repository may own page composition, catalog metadata,
shared navigation, visual design, search, analytics, deployment, and redirects.
When it copies product facts, it should record the source repository commit and
provide a visible route back to the canonical document. Prefer concise site
summaries and canonical links over maintaining two complete procedural texts.

## Publication checklist

Before the site builder publishes Brand Navigation content:

1. Resolve the current repository default branch, latest published release,
   immutable tag, release commit, and tree again.
2. Check `CHANGELOG.md`, `SUCCESSOR_CHECKPOINT.md`, and `TESTING.md` for changes
   after this handoff.
3. Verify DNS, TLS, routing, canonical URLs, and redirects for every destination
   the page exposes.
4. Verify any live demo at the exact advertised URL and record its component
   ref, Discourse build, theme, viewport, account state, and tested behaviors.
5. Use only approved media with complete provenance and accessible alternative
   text.
6. Preserve the independence statement, RC label, compatibility limits,
   accessibility limits, mobile-capacity note, and provisional rollback note.
7. Check every installation, release, documentation, support, security, and
   license link.
8. Do not publish `v1.0.0` language until an immutable stable release exists.
