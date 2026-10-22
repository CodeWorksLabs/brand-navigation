# Brand Navigation v1.0.0-rc.5

Draft release notes — RC5 is not published or approved for publication.

The source and documentation changes below were implemented and pushed to
`main` in [`dcb01b2`](https://github.com/CodeWorksLabs/brand-navigation/commit/dcb01b28744aec1f06441ddacf713c1f8c407958).
Implementation and verification are separate: the recorded results establish
only the candidates and scenarios named below.

## Implemented changes

- Appearance saves submit only explicitly edited colors; **Inherit all** still
  explicitly resets every defined color. Successful save responses reconcile
  saved color values into the page model.
- Saved-value reads, native-setting observers and a native-save synchronization
  extension were added. They did **not** resolve E01's immediate stale display.
- A no-change **Inherit all** action clears its empty drafts instead of leaving
  them to mask a later native save.
- The compact menu's group-only submenu control is keyboard-focusable.
- Each **Custom** color checkbox has a purpose-specific accessible name; stable
  setting keys preserve checkbox elements during toggles.
- Mobile-bar item widths are constrained and long linked-parent text can shrink
  with ellipsis, reserving room for the separate submenu caret.
- The compact-menu trigger requires a renderable brand or visible navigation
  content.
- Label-only navigation items omit unnecessary icon-loading subscriptions.
- Documentation clarifies separate-copy staging, shared component settings,
  global disabling versus single-theme detachment, and Escape/focus behavior.
  Outdated handoff information and historical path references were corrected.
- Existing regression-source additions are included on main. Their presence is
  not proof that they ran against the final main revision.

## Updating

Update through Discourse's normal theme-component update controls. This
candidate does not introduce a settings-schema or configuration-bundle format
change, or change dependencies.

Try updates on a staging site or separate component copy first. Themes sharing
one component also share its code and settings; previewing another parent theme
does not isolate changes to that component. See the
[administrator guide](USER_GUIDE.md#updates-and-upgrades).

## Verified results and their limits

### Historical CI at `238d5ad`

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
recorded revision only. These CI results are **not** results for the later
`dcb01b2` product update or the latest main. The main update used `[skip ci]`;
no new suite was run for that push.

### Later local execution and focused Chrome results

| Area | Recorded result | Limit |
| --- | --- | --- |
| E01 corrected save sequence | The independently native-saved value survived a different Appearance save and reload. | Immediate native-field/picker display remained stale; E01 is unresolved. |
| E03 Custom controls | Names, keyboard operation and saved states were observed; the later focus correction retained focus through Space on/off toggles for all eleven checkboxes. | Focused Chrome observations on the local target, not whole-product accessibility acceptance. |
| Long-label mobile bar | The original overflow fixture passed after correction; the label and caret stayed within bounds and the submenu was usable. | Foundation, English, 390x844 desktop-Chrome mobile view. |
| Empty compact menu | No empty trigger or popup remained; Core controls stayed present. | Exact empty fixture in Foundation/Horizon, English, 390x844 desktop-Chrome mobile view. |
| E02 compact keyboard | Tested English/Arabic, light/dark, Foundation/Horizon sequences showed no issue. | Actual desktop-Chrome mobile-view contexts; no full eight-context or native-phone gate closure claimed. |
| E04 label-only subscriptions | The missing label-only group/child subscription and cleanup case passed in representative frontend runs. | That representative target and case, not blanket compatibility. |

The [known-issues record](KNOWN_ISSUES.md) preserves the installed source hashes,
evidence references, original failures and coverage limits. Original configuration
and normal viewport were restored after the focused Chrome work.

## Supported-release policy and transition

Brand Navigation is adopting Discourse's supported-release schedule: supported
ESR and monthly lines at their latest patches, including the oldest supported
ESR and both ESRs during an overlap, plus separate development coverage.

The workflow pins committed on main select 2026.7.3 ESR, 2026.8.1, 2026.9.0
and development `latest`. The refreshed targets have **not run**. No cycle is
queued by these notes; further testing requires new explicit instruction from
Phil. Existing results remain valid for their actual revisions, not the new
pins. Any future authorized cycle must use the then-current support schedule.
See the
[phased adoption plan](TESTING.md#discourse-support-policy-adoption).

## Unresolved behavior and incomplete coverage

E01 immediate native-field/picker display staleness remains **unresolved**.
Saved values persisted in the corrected save/reload sequence, but the display
cause remains unknown. Other incomplete checks are missing coverage, not
demonstrated product bugs. Twelve human screen-reader procedures remain deferred.
Incomplete lifecycle, role/permission, platform/native-input and external-embed
coverage remains unestablished. It is not a list of demonstrated product bugs.

## Testing execution failure and closure

The lengthy process failed to produce a clear overall answer. That is a
testing-process failure, not evidence of more product bugs. Phil's assessment
is explicit: **the testing execution is a failure that will have a resolution.**
That process failure remains unresolved; its resolution has not been specified
by these notes. Closing the testing effort does not mark the execution failure
resolved or authorize a new investigation.

Phil closed this testing effort. No new testing, investigation or campaign is
assigned; reopening requires new explicit instruction from Phil. Closure is the
human stopping decision, not all-nine verification, release acceptance, or an
E01 fix.

## Publication status

The final RC5 commit, release date, changelog entry, badge and prerelease are
not yet finalized. Do not treat the draft's tested commit as an accepted final
release identity. Published RC4 remains unchanged.

## Support

For installation and configuration help, use
[Brand Navigation Support](https://forum.codeworkslabs.dev/c/brand-navigation/support/7).
Report security issues privately using the [security policy](../SECURITY.md).
