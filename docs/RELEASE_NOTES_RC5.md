# Brand Navigation v1.0.0-rc.5

Draft release notes — not published or approved for publication.

This release candidate corrects administrator color-saving behavior, improves
keyboard entry and control labels, and clarifies safe configuration workflows.
It builds on the navigation, core-header links, colors and sizing introduced in
earlier release candidates.

## Changes

- Preserve independently saved native color settings when another color is
  saved through Appearance. Untouched colors follow the current saved values;
  intentional Appearance edits remain drafts until saved.
- Keep a no-change **Inherit all** action from retaining an obsolete color
  snapshot that could overwrite a later native save.
- Make a group-only submenu control keyboard-focusable in the compact menu.
- Give each **Custom** color checkbox a purpose-specific accessible name.
- Retain checkbox focus while Space toggles **Custom** on and off.
- Keep a long linked-parent label and its submenu caret within the mobile bar.
- Omit the compact-menu trigger when neither a brand nor navigation content is
  available to render.
- Avoid unnecessary icon-loading subscriptions for label-only navigation items.
- Clarify separate-copy staging, shared component settings, global disabling
  versus detaching one theme, and the different Escape behavior in the bar and
  compact menu.
- Correct outdated handoff information and machine-specific historical paths.

## Updating

Update through Discourse's normal theme-component update controls. This
candidate does not introduce a settings-schema or configuration-bundle format
change, or change dependencies.

Try updates on a staging site or separate component copy first. Themes sharing
one component also share its code and settings; previewing another parent theme
does not isolate changes to that component. See the
[administrator guide](USER_GUIDE.md#updates-and-upgrades).

## Verification recorded so far

The working candidate `238d5ad829eb6053e5c2aefc94f495cf5f83791f` completed
[Discourse Theme CI](https://github.com/CodeWorksLabs/brand-navigation/actions/runs/39506144090)
and [Configuration bundles CI](https://github.com/CodeWorksLabs/brand-navigation/actions/runs/39506143547):

- Four existing system-test lanes each passed 49 examples, including Discourse
  core interactions with Brand Navigation active.
- The complete **Inherit all → native color save → different Appearance color
  save → reload** regression passed on every lane. All eleven saved color
  values and displayed states were checked before and after reload.
- Lint, frontend/backend jobs and 44 configuration cases plus the lint-coverage
  guard passed. Four conditional job skips have explained dispositions; they
  are not counted as executed passes.
- Independent read-only reviewers confirmed the exact overwrite-regression
  result and retained its limits. Their conclusions are focused correction
  reviews, not complete release acceptance.

See [Testing and acceptance](TESTING.md#rc5-candidate-verification) for exact
Core commits. In particular, the R744-derived `2026.7.2+14` revision is not the
exact official `v2026.7.2` release tag. Its passing result applies to the
recorded revision only.

## Supported-release policy and transition

Brand Navigation is adopting Discourse's supported-release schedule: supported
ESR and monthly lines at their latest patches, including the oldest supported
ESR and both ESRs during an overlap, plus separate development coverage.

The existing CI targets have been prepared locally for 2026.7.3 ESR, 2026.8.1,
2026.9.0 and development `latest`. The refreshed targets have **not run**.
They are planned for the next authorized normal CI cycle, not an additional
testing campaign. Existing results remain valid for their actual revisions;
they are not compatibility results for the new pins. Recheck Discourse's
support schedule before that cycle. See the
[phased adoption plan](TESTING.md#discourse-support-policy-adoption).

## Remaining acceptance and publication status

Later focused Chrome work verified the long-label mobile-bar and empty compact-
menu corrections, plus the E03 checkbox-focus correction. Tested English/Arabic,
light/dark, Foundation/Horizon compact keyboard sequences showed no issue in
the actual desktop-Chrome mobile-view contexts. E04's missing label-only
subscription case passed on the representative target.

E01 immediate native-field/picker display staleness remains **unresolved**.
Saved values persisted in the corrected save/reload sequence, but the display
cause remains unknown. Other incomplete checks are missing coverage, not
demonstrated product bugs. Twelve human screen-reader procedures remain deferred.
See the [known-issues record](KNOWN_ISSUES.md) for current results and limits.

Phil closed this testing effort. No new testing, investigation or campaign is
assigned; reopening requires new explicit instruction from Phil. Closure is the
human stopping decision, not all-nine verification, release acceptance, or an
E01 fix. This main update uses `[skip ci]` and does not publish an RC5 release.

The final RC5 commit, release date, changelog entry, badge and prerelease are
not yet finalized. Do not treat the draft's tested commit as an accepted final
release identity. Published RC4 remains unchanged.

## Support

For installation and configuration help, use
[Brand Navigation Support](https://forum.codeworkslabs.dev/c/brand-navigation/support/7).
Report security issues privately using the [security policy](../SECURITY.md).
