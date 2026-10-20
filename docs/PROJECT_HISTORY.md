# Brand Navigation project history

Reconstructed: 2026-09-08

Coverage: development through September 8, 2026. This is a historical account,
not a current feature list, release status or operating procedure. For current
information, use the [README](../README.md), [Administrator guide](USER_GUIDE.md),
[release procedure](RELEASE.md) and
[GitHub Releases](https://github.com/CodeWorksLabs/brand-navigation/releases).
The support routes and website proposals below describe the position at that
time, not current destinations. Current help is available in
[Brand Navigation Support](https://forum.codeworkslabs.dev/c/brand-navigation/support/7).

This document preserves the readable development history of Brand Navigation
after a development-tool update stopped displaying the original task
transcript. It is a reconstruction, not a verbatim transcript. Repository
commits, tags, release metadata, pull requests, CI records, and the detailed
testing and provenance documents remain the authoritative evidence for exact
technical claims.

## Evidence used

This history was reconstructed from:

- the Git history and repository tree available at reconstruction;
- [`CHANGELOG.md`](../CHANGELOG.md);
- [`TESTING.md`](TESTING.md), [`PROVENANCE.md`](PROVENANCE.md), and
  [`ATTRIBUTION.md`](ATTRIBUTION.md);
- the successor checkpoints available at reconstruction;
- retained task context containing the product decisions, operator feedback,
  review gates, and release sequence; and
- the published GitHub tag and release metadata.

Some conversational wording may have been compacted. Where retained context
and durable repository evidence differ, the repository evidence controls.

## Product origin and identity

Phil initiated the work as a modern Discourse theme component combining the
useful product ideas of a brand header and submenu navigation while avoiding a
mechanical merger, fork, CSS workaround, or DiscussionBridge-specific
customization. Administration, mobile behavior, accessibility, migration, and
supported render contexts were first-class requirements from the beginning.

The provisional name **Discourse Brand Navigation** was reconsidered after a
naming and trademark-position review. Phil settled the independent-stage
identity as:

- public name: **Brand Navigation**;
- repository slug: `brand-navigation`;
- description: “A brand header and submenu navigation theme component for
  Discourse”; and
- no Discourse logo, official badge, or claim of Discourse ownership or
  maintenance.

The canonical repository became
<https://github.com/CodeWorksLabs/brand-navigation>, with the local checkout in
a workspace directory named **Discourse Brand Navigation**.

## Non-negotiable architecture

The defining invariant is that site-global brand and navigation content must
not mount in supported Discourse embed contexts. Brand Navigation enforces
that boundary through supported Discourse application state at its own render
and connector boundaries. It does not use CSS hiding, hostname detection,
downstream DOM selectors, or DiscussionBridge compatibility code.

The component leaves Discourse's embedded discussion content, topic
navigation, authentication, reply, like, quote, composer, and normal full-app
behavior intact. It intentionally supports one submenu level rather than
becoming a general page builder or arbitrary navigation framework.

## Initial implementation

The first implementation was committed on 2026-08-19. It was developed with
AI assistance from Phil's product specifications and iteratively shaped through
Phil's administrator and device testing. The resulting component was newly
authored rather than copied from Brand Header or Header Submenus.

Early work established:

- optional brand logo, name, destination, and presentation;
- primary links and one-level submenus;
- internal and external destinations;
- responsive desktop, tablet, and mobile behavior;
- anonymous and authenticated visibility;
- keyboard interaction and accessible naming;
- structured Discourse object settings and validation; and
- explicit non-embed rendering.

The useful ideas in Discourse Brand Header and Discourse Header Submenus were
credited as product inspiration. Pavilion Dropdown Header and Custom Header
Links (icons) later informed presentation and ecosystem exploration. The exact
source classifications and the one historical implementation study are
preserved in [`PROVENANCE.md`](PROVENANCE.md) and
[`ATTRIBUTION.md`](ATTRIBUTION.md).

## Administrator experience and configuration portability

Phil repeatedly emphasized that operators should not have to hand-enter a
large configuration on every forum. Brand Navigation therefore gained a
browser-based, administrator-facing configuration bundle workflow:

- export the component's settings as versioned JSON;
- validate imports before writing settings;
- select which bundle to import;
- preserve structured navigation and icon settings; and
- use a staging theme and theme preview for safe preparation.

The workflow was exercised across sandbox and production installations. An
asynchronous file-selection race found during formal review was corrected so
an older file read cannot overwrite a newer selection or pasted bundle.

The navigation editor was also changed to remain open after saving. That
small interaction mattered in real administration because Discourse's default
return to the main settings screen interrupted repeated editing.

## Navigation and presentation developed through live use

Real installation and coexistence testing shaped the component substantially.
Brand Navigation was evaluated alongside Brand Header, Header Submenus,
Custom Header Links (icons), and Pavilion Dropdown Header. These components
were observed working together without requiring compatibility code.

The iterative product decisions included:

- left and right navigation sections so account-oriented or personal items can
  sit apart from primary site navigation;
- three top-level behaviors: direct link, submenu-only group, and linked parent
  with a separate submenu caret;
- a parent label and caret that highlight as one control group;
- persistent dropdowns that remain open until selection, dismissal, or an
  outside interaction;
- optional visible submenu descriptions, with tooltips retained for compact
  destinations;
- compact social and utility destinations registered in Discourse's core
  header when navigation-bar space is scarce;
- intentional above-header and below-header placement choices left to the
  administrator and active site design; and
- per-item audience and device visibility.

Several visual corrections came directly from live observation: removal of a
duplicate disclosure marker, alignment of submenu children with their parent,
tighter caret spacing, unified hover styling, and improved described-submenu
presentation.

## Responsive behavior and accessibility

Desktop, mobile portrait, and mobile landscape behavior were tested on real
sites. At that stage, device visibility followed responsive layout, so
desktop-only items could appear when a landscape viewport crossed the desktop
breakpoint. The contemporary checkpoint records this as a defect found by Phil,
corrected in `61db961` and verified by him on a physical iPhone. It was not the
intended device-visibility behavior. Device visibility now follows Discourse's
device capability, and rotating a phone does not expose desktop-only items.
See the [navigation settings guidance](USER_GUIDE.md#add-navigation).

An iPhone portrait pass found that too many core-header social icons can crowd
Discourse's anonymous login and menu controls. Marking less important icons
desktop-only restored the full menu. This remains an operator capacity
consideration rather than a hidden automatic-prioritization feature.

Automated keyboard and accessibility coverage was supplemented by a bounded
iPhone VoiceOver session. VoiceOver announced the Brand Navigation control,
menu items, submenu state, child-link roles, and visible descriptions. The
complete current-candidate screen-reader matrix was not finished, and the
release documentation intentionally says accessibility is not fully manually
tested. Classic embed and Arabic RTL browser/runtime checks were completed;
their exact limits are recorded in [`TESTING.md`](TESTING.md).

## Appearance and translations

Administrator color controls were added for bar background, text, hover and
highlight state, submenu background, and submenu text. Each value may be set
explicitly or inherited from the active Discourse color palette. Six-digit
hexadecimal input is accepted with or without a leading `#` and normalized for
the picker and configuration bundle.

Brand Navigation also uses Discourse theme translations for interface labels,
administration panels, setting descriptions, and status messages. Navigation
labels, visible descriptions, and tooltips remain operator-authored site
content. English is the bundled language for the first release line, with
administrator overrides and reviewed translation contributions supported.

## Licensing and provenance

Licensing began as MIT and was reconsidered after Phil clarified that
CodeWorksLabs uses GPL licensing and that Brand Navigation was newly authored
from specifications. The final first-release license is
`GPL-2.0-or-later`.

The repository does not claim that inspiration means copied code. It records
that an early core-header icon implementation adapted a narrow pattern from
Custom Header Links (icons); that implementation was replaced before the first
tagged release by an independently authored lexical component factory. No
copied or adapted external implementation is identified in the current release
tree. The permanent upstream reference remains in the provenance record so the
development history is not erased.

## Review and release engineering

Phil established a deliberate release sequence: finish product and
documentation polish, freeze an exact candidate, conduct complete review,
evaluate all findings together, remediate coherently, perform correction
closure, complete manual acceptance, merge the accepted tree, then tag and
publish that exact tree.

That sequence describes the required process. It does not establish that every
required check was completed on every candidate. The review reports and
[`TESTING.md`](TESTING.md) identify the actual checks, results and limitations
for each recorded candidate.

Important candidates were reviewed through two complementary lanes:

- an internal subagent lane for fast, candidate-bound technical inspection and
  iterative closure; and
- the visible sidebar Code Reviewer task for independent, operator-observable
  formal release gates.

Both lanes were required to follow the controlling Code Review Doctrine; their
individual reports determine what was actually reviewed and verified. The
internal lane found a substantive icon-readiness regression late in remediation,
while the sidebar lane supplied independent scrutiny. Findings were collected
before corrections and reviewed as coherent batches. These recorded activities
are not a claim that every testing requirement was satisfied.

The review and compatibility work added or strengthened:

- official Discourse theme-component system coverage;
- administrator save and import concurrency tests;
- configuration size and type validation;
- safe `_blank` handling and icon fallback behavior;
- production SVG sprite readiness across supported Discourse versions;
- mobile linked-parent submenu geometry and closure coverage;
- staging-theme bundle workflow coverage;
- Ruby lint and JavaScript/theme CI; and
- exact-candidate and post-merge verification.

## Compatibility branches and multi-site validation

Brand Navigation adopted Discourse's `d-compat/<YYYY>.<M>` convention. `main`
targets current Discourse, while maintained older releases use compatibility
branches. The first release cycle established `d-compat/2026.7` and
`d-compat/2026.8`, including guarded branch creation and reviewed backports.

Native Discourse update behavior, settings preservation, theme attachment,
branch selection, and public availability were exercised across:

- DiscussionBridge sandbox;
- Repeal OBBBA Forum;
- DiscussionBridge Forum;
- The Bridge;
- Citizen Activist Network;
- RVing Community; and
- R744 Community.

The exact versions, commits, component identifiers, and coverage boundaries
are maintained in [`TESTING.md`](TESTING.md). R744 served as the oldest
real-world compatibility canary during the initial cycle.

## Published versions recorded through September 8, 2026

### `v0.9.0`

The reviewed public preview was published on 2026-09-07. It established the
initial public installation, configuration, provenance, testing, and support
surfaces.

### `v1.0.0-rc.1`

The first stable-track release candidate was published on 2026-09-08 as a
GitHub prerelease:

<https://github.com/CodeWorksLabs/brand-navigation/releases/tag/v1.0.0-rc.1>

The annotated tag points to merge commit
`ed1640b049763c37694f8c3bb5f9f69cbd21f658` and tree
`f3b97c11c93dc00c2e66df346ec4c0b032ab5581`. The release added the native
single activation switch, documented staging preparation, async import-race
protection, corrected mobile linked-parent flow, compatibility-branch
automation, and a visible latest-release badge.

At reconstruction, version `v1.0.0` was reserved for the stable release after
candidate observation, resolution of release blockers and preparation of the
planned public CodeWorksLabs documentation. This records the plan at that time;
the current release requirements are in [`RELEASE.md`](RELEASE.md).

## Product decisions recorded at reconstruction

- **Brand Navigation** is the public name; `brand-navigation` is the repository
  slug.
- The component is independently maintained and does not claim official
  Discourse status.
- Discourse's native component **Enabled?** control is the sole activation
  switch.
- Configuration bundles are the supported UI-based migration and duplication
  mechanism; direct database manipulation is not required.
- Embed exclusion remains a component-boundary invariant.
- One submenu level is intentional.
- `main` follows current Discourse; maintained older releases use `d-compat`
  branches.
- Releases use Semantic Versioning tags and GitHub Releases while Discourse
  continues to detect updates from the installed remote branch.
- The license is `GPL-2.0-or-later`.
- GitHub Issues was the public support route at that time; private security
  reports went to `security@codeworkslabs.dev`. Use the current README and
  [security policy](../SECURITY.md) for today's reporting routes.

## Incidents that are not product doctrine

- The local task working directory temporarily pointed to a path that no
  longer existed. The canonical checkout is the Products path recorded above.
- Browser-control availability changed across development-tool crashes and
  updates. That tooling incident does not define the product's browser or test
  requirements.
- Duplicate sandbox component installations were retained temporarily for
  rollback and comparison; they are not an installation recommendation.
- SMTP failures and a Docker port-80 collision encountered while maintaining
  test forums were site-operations matters, not Brand Navigation defects.
- The original development transcript becoming invisible after an application update
  is why this reconstructed history exists. It does not supersede Git or the
  repository's evidence records.

## Position as reconstructed on 2026-09-08

This section records the position understood on its reconstruction date, not
current status or next actions. Use the [README](../README.md),
[release procedure](RELEASE.md) and
[GitHub Releases](https://github.com/CodeWorksLabs/brand-navigation/releases)
for current product information and release requirements.

Brand Navigation is published at `v1.0.0-rc.1` and is in its release-candidate
aging period. The next work is observation and issue triage, continued testing
on supported Discourse updates, and preparation of the broader CodeWorksLabs
public documentation presence. The discussed hostname model is:

- `codeworkslabs.dev` for the company and product overview;
- `docs.codeworkslabs.dev` for shared documentation;
- platform hubs such as `discourse.codeworkslabs.dev`; and
- `support.codeworkslabs.dev` for shared support.

Those sites are planned work, not part of the `v1.0.0-rc.1` release tree. A
future stable `v1.0.0` should be cut only from a newly frozen, reviewed,
verified, and manually accepted candidate.
