# Brand Navigation successor checkpoint

Date: 2026-09-07

## Current disposition

Brand Navigation `v0.9.0` is a released public preview. The component is
independently maintained by CodeWorksLabs and is not an official Discourse
product. Current product code is released and deployed; a documentation-only
operator-readiness correction and the browser/runtime embed and RTL evidence
are merged. A bounded iPhone VoiceOver pass is now recorded, but complete human
screen-reader acceptance is explicitly not claimed. The selected next release
identity is the SemVer prerelease `v1.0.0-rc.1`; final `v1.0.0` follows RC aging
and the planned public documentation work. Release preparation is active on
`release/v1.0.0-rc.1`. The release-branch correction removes the duplicate
Brand Navigation `enabled` setting so Discourse's component-level **Enabled?**
control becomes the single activation source.

## Authoritative repository state

- Repository: `https://github.com/CodeWorksLabs/brand-navigation`
- Canonical local checkout:
  `C:\CodeProjects\Products\Discourse Brand Navigation`
- Stable repository line: `main`, currently
  `56ee6f874efb85dfd6976928954f0dcd74aab3c8`. Obtain the live identity with
  `git rev-parse origin/main` rather than relying on this checkpoint after
  later merges.
- Published preview: `v0.9.0`, release commit
  `d2527bfb3acdcf4204a33d35e0b13504f6d7c36e`, tree
  `23328df16e2703920778d71c226abe0a00f97cfb`
- Maintained compatibility refs: `d-compat/2026.7` and `d-compat/2026.8`, both
  at `a628dcd74c9465903c7eacd59f63e50f6c9d37b6`
- Active release-preparation branch: `release/v1.0.0-rc.1`, based on `main`.
  Commit `a92788a8415f0f6f644127ef9ec76b2e502a800e` publishes the RC support policy
  and monitored `security@codeworkslabs.dev` route. Obtain the branch's current
  identity with `git rev-parse release/v1.0.0-rc.1` after later corrections.

The detailed pre-release and compatibility-branch chronology is preserved in
[`docs/HISTORICAL_CHECKPOINT.md`](docs/HISTORICAL_CHECKPOINT.md). It must not be
used as current operational instruction.

## Product invariants

- Brand Navigation is a modern, independently designed Discourse theme
  component for optional brand identity, primary links, one-level submenus,
  responsive navigation, and compact core-header destinations.
- Administration is a first-class product surface with structured settings,
  validation, safe defaults, appearance controls, and browser-based
  configuration bundle import/export.
- Site-global Brand Navigation content must never mount in supported Discourse
  embed contexts. Enforcement stays at the component render/connector boundary
  using supported Discourse embed state—never CSS hiding, hostname checks, DOM
  selectors, or DiscussionBridge-specific compatibility code.
- Core topic navigation, embedded discussion content, sign-in, reply, like,
  quote, composer, and normal full-application behavior remain owned by
  Discourse.
- Normal non-embed pages retain the intended brand and navigation surfaces.
- Public identity remains **Brand Navigation**, repository slug
  `brand-navigation`, with no official-status claim or Discourse branding.
- License remains `GPL-2.0-or-later`; attribution and provenance records remain
  precise about inspiration, independently authored work, and adapted source.

## Verified installations

The canonical table and exact evidence are in
[`docs/TESTING.md`](docs/TESTING.md). Current coverage includes:

- Discourse `2026.9`: DiscussionBridge sandbox, DiscussionBridge Forum, The
  Bridge, and Citizen Activist Network on repository-default `main`.
- Discourse `2026.8`: RVing Community on `d-compat/2026.8`.
- Discourse `2026.7` ESR: Repeal OBBBA Forum and R744 Community on the maintained
  2026.7 line. R744 intentionally remains the oldest real-world compatibility
  canary while that core remains supported.

Native update checks, compatibility selection, setting preservation, theme
attachments, import state, and HTTP availability were recorded during the
2026-09-07 multi-site pass. Historical duplicate components remain only where
explicitly documented as unattached rollback/test copies.

## Completed documentation correction

Manual Boss and Product Boss completed independent read-only documentation and
operator inspections of merged commit `f3f41e5`. Neither issued a formal code
review disposition. Their combined findings contained no P0 and no identified
product-code defect. The documentation correction was merged through pull
request 13 at `dc0e935ab54eead212e41681320470b52fc6a775`; all GitHub CI lanes passed.
Both Bosses then closed every submitted finding against the exact correction
candidate, with no new P0-P3 finding in the final delta. The batch closed:

1. stale instructions that could repeat the completed `v0.9.0` release;
2. contradictory current and historical checkpoint state;
3. the missing same-component revision rollback procedure;
4. the omitted copyable installation URL;
5. accessibility wording beyond completed human evidence;
6. a stale README sandbox build;
7. production/demo/sandbox classification;
8. the missing current support route; and
9. obsolete “first release” wording.

The complete closure reports remain in the originating Manual Boss and Product
Boss tasks. They are bounded documentation/product inspections, not formal code
review dispositions.

Subsequent repository verification confirmed that GitHub Issues is enabled on
the public repository. The stale statement that new issue creation was
restricted has been removed, and GitHub Issues is now the documented public
intake route for support and product feedback. A private security-reporting
channel is now published at `security@codeworkslabs.dev` through the repository
security policy; the mailbox is monitored by CodeWorksLabs.

## Remaining `v1.0.0` acceptance

On 2026-09-07, reproducible sandbox browser/runtime work exercised classic
comments, full-app embed exclusion and core-control availability, and Arabic
RTL desktop/mobile interaction on Foundation and Horizon. The temporary embed
fixture and all changed sandbox settings were removed or restored. Exact
evidence and boundaries are recorded in `docs/TESTING.md`.

Human confirmation remains required for these gates on a controlled test
environment:

1. classic Discourse embedded comments, including core interaction preservation
   and complete Brand Navigation exclusion;
2. a full RTL-locale desktop/mobile interaction pass; and
3. completion of the partial iPhone VoiceOver pass for landmarks, names, state,
   focus, dismissal, submenus, icons, responsive controls, and embed exclusion.

The partial VoiceOver pass confirmed announced menu items, submenu state,
child-link roles, and visible descriptions. It did not confirm the outer
trigger state or submenu dismissal/focus return. It also exposed a portrait
capacity limit when five mobile social icons compete with Discourse's anonymous
header controls: the Brand Navigation trigger can be obscured. The exact
evidence and current operator mitigation are in `docs/TESTING.md`.

Collect all findings before making another correction batch. `v1.0.0` becomes
appropriate when these gates and any resulting blockers are closed, the exact
candidate passes required CI/review, and final acceptance is complete.

## Exact next actions

1. Run pull request 19 CI on the final documentation-evidence commit. Its parent
   `f6ca29b9b911936df1cbb4306411574b5bd50e34` passed configuration workflow
   `34176240352` and all required current, 2026.8, and 2026.7 Discourse Theme
   lanes in workflow `34176242873`.
2. Freeze the resulting exact commit and tree, then conduct the
   doctrine-controlled complete codebase review before release.

Sandbox components are now named `Brand Navigation #1`, `Brand Navigation #2`,
and `Brand Navigation #3`. Components `1` and `2` remain disabled and
unattached. Component `3` is enabled on Foundation and Horizon and follows
`release/v1.0.0-rc.1`, with no import error and zero commits behind at the last
inspection. The single-switch runtime implementation entered that branch at
`86c9083b8f83dc21d95fc772d5fc7b08e475bc14`; obtain the exact live installed
identity from Discourse rather than treating this checkpoint as a moving branch
pointer. Its current schema contains no internal `enabled` setting.
Phil confirmed the RC rendered correctly and Discourse reported it up to date
with the release branch.

## Out of scope

- CMS behavior, general page building, or arbitrary deep navigation nesting.
- Authentication replacement or changes to core Discourse embedding.
- DiscussionBridge-specific compatibility code.
- Hostname, CSS, or DOM-selector embed workarounds.
- Literal Discourse-core integration, official-status claims, repository
  transfer, or official branding without Discourse maintainer acceptance.
- Live installation, deployment, or publication unless separately authorized.
