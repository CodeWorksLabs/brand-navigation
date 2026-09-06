# Authorship and provenance record

Record date: 2026-09-06

This is the durable evidence record for how Brand Navigation was specified and
implemented, which upstream projects were consulted, and where source code was
or was not adapted. Update it whenever a source classification changes. It is a
technical provenance record, not legal advice or a substitute for release
review.

## Authorship model

Phil Henry directed the product requirements, naming, licensing posture,
administrator experience, supported contexts, testing sites, and acceptance
decisions. OpenAI Codex generated and modified implementation and documentation
under that direction. Phil performed iterative administrator and device testing
on real Discourse installations, supplied product feedback, and accepted or
rejected behavior throughout development.

In this record, **independently authored** means that Brand Navigation was
generated from its product specifications as a new implementation. It does not
mean that every line was typed by a human, that no upstream project was studied,
or that ordinary framework patterns cannot resemble other Discourse code.
Brand Navigation is not a fork, mechanical merger, translation, or stylesheet
overlay of another component.

The durable specification and acceptance basis is distributed across
[`SCOPE.md`](SCOPE.md), [`ARCHITECTURE.md`](ARCHITECTURE.md),
[`TESTING.md`](TESTING.md), the settings schema, Git history, and the repository
successor checkpoint. Development transcripts provide additional working
history but are not treated as the only evidence required to reconstruct the
product position.

## Recorded upstream sources and classifications

The revisions below make the evidence reproducible. A newer upstream revision
does not silently change this record.

### Canonical-source verification

Discourse Meta identifies Brand Header, Header Submenus, and Custom Header
Links (icons) as official components maintained by the Discourse team. Each
official Meta page links to the same `discourse/*` repository recorded below;
those repositories are therefore the current canonical sources for this
review. Their repository-specific licenses differ: Brand Header and Header
Submenus provide MIT licenses, while Custom Header Links (icons) provides GNU
GPL version 2 text. Official maintenance status does not replace or normalize
those license files. Pavilion Dropdown Header is the community-maintained
source in this inventory.

| Upstream project                                                                        | Recorded revision                                                                                                   | License evidence                                                                                                                                  | How the source was used                                                                                                         |
| --------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------- |
| [Discourse Brand Header](https://github.com/discourse/discourse-brand-header)           | [`8fd8500`](https://github.com/discourse/discourse-brand-header/tree/8fd850083c15068cc420d87102a7862c559f4790)      | [MIT `LICENSE.txt`](https://github.com/discourse/discourse-brand-header/blob/8fd850083c15068cc420d87102a7862c559f4790/LICENSE.txt)                | Product inspiration only. No copied or adapted implementation is currently identified.                                          |
| [Discourse Header Submenus](https://github.com/discourse/discourse-header-submenus)     | [`9659f84`](https://github.com/discourse/discourse-header-submenus/tree/9659f849a07db6fe6c94374aef6641622b24b22b)   | [MIT `LICENSE`](https://github.com/discourse/discourse-header-submenus/blob/9659f849a07db6fe6c94374aef6641622b24b22b/LICENSE)                     | Product inspiration and administrator-workflow study only. No copied or adapted implementation is currently identified.         |
| [Pavilion Dropdown Header](https://github.com/paviliondev/discourse-dropdown-header)    | [`707425d`](https://github.com/paviliondev/discourse-dropdown-header/tree/707425d92c764a6f89516afcf304620a54872682) | [GPL version 2 `LICENSE.txt`](https://github.com/paviliondev/discourse-dropdown-header/blob/707425d92c764a6f89516afcf304620a54872682/LICENSE.txt) | Presentation and administrator-experience inspiration only. No copied or adapted implementation is currently identified.        |
| [Custom Header Links (icons)](https://github.com/discourse/discourse-icon-header-links) | [`dee14e3`](https://github.com/discourse/discourse-icon-header-links/tree/dee14e37185e5e4db38497bd952352405a5826af) | [GPL version 2 `LICENSE`](https://github.com/discourse/discourse-icon-header-links/blob/dee14e37185e5e4db38497bd952352405a5826af/LICENSE)         | The narrow `curryComponent`/`api.headerIcons.add` registration pattern was adapted. The permanent source range is linked below. |

Permanent adapted-pattern reference:
[initialize-for-header-icon-links.gjs at `dee14e3`, lines 1–27](https://github.com/discourse/discourse-icon-header-links/blob/dee14e37185e5e4db38497bd952352405a5826af/javascripts/discourse/initializers/initialize-for-header-icon-links.gjs#L1-L27).

## Implementation-history evidence

- Commit `857aba8e4fb45eacd0abc69332cec5ff22c80d2b` created Brand
  Navigation from the product specification. Its initial initializer rendered
  the component through Discourse's plugin API and did not contain the later
  core-header icon registration.
- Commit `3cd8910161f794764af299e551f4b6c5bebe9790` introduced the
  core-header icon feature and the recorded adapted registration pattern.
- The current initializer retains that pattern. The formal immutable-candidate
  codebase review must confirm that this ledger is complete before release.

## License posture and open verification

Brand Navigation declares `GPL-2.0-only`. The two MIT-licensed inspiration
sources did not supply copied code, so their MIT notices are not incorporated
as notices for copied code. They remain credited because they materially
informed the product.

The Custom Header Links (icons) repository contains the GPL version 2 license
text, and GitHub classifies it as `GPL-2.0`. No explicit upstream statement
granting the “or later” option was located in the inspected README, component
metadata, package metadata, initializer, or license file. Brand Navigation uses
the conservative `GPL-2.0-only` declaration for the initial release. A later
release may adopt an “or later” declaration only after evidence establishes the
necessary permission for the adapted expression, or after that expression is
replaced with independently authored code.

Because Custom Header Links (icons) is an official Discourse component, any
license clarification or additional permission should come from the Discourse
maintainers or another confirmed rights holder. An individual historical
contributor should not be assumed to have authority to clarify the license for
the complete repository.

No Brand Navigation version was tagged or published as a GitHub Release before
this decision. The repository was already public, however, so earlier commits
were distributed with the declarations present at that time. Changing the
current declaration does not withdraw permissions that recipients may already
hold for those published commits. No external human recipient, adoption, or
reliance is known: the repository currently has no forks, stars, or subscribers.
GitHub traffic does record automated/client clone activity consistent with CI
and the known Discourse installations, but it does not identify people. This
history requires an accurate record, not special support or continued release
of those commits. Do not erase the historical fact that the earlier pattern was
consulted.

## Release controls

Before each release:

1. Freeze the exact candidate commit and tree.
2. Compare the complete candidate against every source in this ledger and any
   additional source identified during review.
3. Record newly copied or adapted expression, including the exact upstream
   revision, file, lines, license, and required notice.
4. Confirm that inspiration-only classifications remain supported by evidence.
5. Confirm the repository license, package identifier, README, component
   metadata, attribution, and source notices agree.
6. Preserve the review findings and correction-closure evidence with the
   release record.

Statements such as “no other copied code is identified” describe the recorded
evidence at a point in time. They are not absolute guarantees about all possible
similarity and must be reevaluated when the candidate changes.
