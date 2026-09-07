# Migration and rollback

Migrate in a staging theme or a copied production theme first.

## Configuration bundles

Use the **Configuration bundles** panel to export and import a versioned JSON
configuration without recreating every object-setting row. The browser panel
updates only the portable Brand Navigation settings listed in the bundle. It
does not attach or enable the component.

Bundle validation is fail-closed for field types, allowed values, URL schemes,
unknown fields, navigation depth, size limits, and cross-field requirements.
The browser importer sends one complete theme update after preflight rather than
saving settings one at a time. If connectivity is lost after submission, reload
the target component and verify its settings before retrying.
The same 1,000,000-byte file ceiling applies to imports and generated exports.
The structured navigation data must also fit Discourse's 524,288-byte
serialized object-setting limit. Brand Navigation checks both limits before an
import request or downloadable bundle is created; oversized settings must be
shortened first.

For normal administrator use, the same operation is available in the
**Configuration bundles** panel near the bottom of Brand Navigation's
administration page. A newly installed component must be attached to the
administrator's active theme before Discourse can load that panel; keep the
component's `enabled` setting off until after import and verification.

The repository's `configurations/repeal-obbba.json` file is the first migration
fixture. It was assembled from observed Brand Header, Dropdown Header, and
Custom Header Links (icons) settings and is also useful for exercising larger
menus, external destinations, icon-only links, and left/right sections.

The `v0.9.x` preview line intentionally provides no credentialed command-line
apply/export client. A local checkout can validate a saved bundle without
contacting a forum by running
`pnpm bundle validate configurations/repeal-obbba.json`. Logo uploads remain a
separate site-local step.

## From Brand Header

1. Record `brand_name`, `website_url`, light/dark/mobile logos, text links,
   icon links, targets, mobile behavior, and outlet.
2. Install Brand Navigation but leave `enabled` off.
3. Map the brand name and `website_url` to `brand_name` and `brand_url`.
4. Upload the light and dark logos. Brand Navigation intentionally uses the
   light logo as the dark fallback and responsive sizing instead of a separate
   mobile-logo setting.
5. Add text links as top-level `navigation_items`.
6. Add icon-only links from the earlier component as labeled navigation
   entries. A visible label is required for clear administration and
   accessibility.
7. Select the equivalent outlet and mobile mode.
8. Disable Brand Header, enable Brand Navigation, and run the acceptance checks.

## From Header Submenus

1. Export or copy the `Menu_items`, `Submenu_items`, icon list, placement, and
   color choices before changing anything.
2. Install Brand Navigation but leave `enabled` off.
3. Create one structured top-level item for every menu item.
4. Add each submenu entry under its parent. Divider-only entries have no direct
   equivalent; use grouping and ordering instead.
5. Omit placeholder links such as `#` until they have real destinations; Brand
   Navigation validates submenu destinations instead of preserving no-op links.
6. Map `vdm` to `both`, `vdo` to `desktop`, and `vmo` to `mobile` in each
   item's `device_visibility`. Then choose the component-wide mobile mode that
   controls whether mobile navigation uses the menu, full bar, or stays hidden.
7. Keep color customization in the parent theme when needed; Brand Navigation
   defaults to Discourse color-scheme variables.
8. Disable Header Submenus, enable Brand Navigation, and run acceptance checks.

The same mapping applies to Pavilion's Dropdown Header: header links become
top-level items, dropdown rows become children matched to their parent, and
its icon list becomes `custom_font_awesome_icons`.

## From Custom Header Links (icons)

1. Export or record each title, icon, URL, device view, width, and target.
2. Map each link to a top-level Brand Navigation item. Choose the `right`
   section on the `bar` surface, or choose `site_header` to retain its compact
   location among Discourse's core header icons.
3. Use `icon_only` presentation while retaining the full title as the required
   accessible label.
4. Map `blank` to `_blank` and `self` to `_self`.
5. Add every used icon to `custom_font_awesome_icons`.
6. Map each device view to `both`, `desktop`, or `mobile`, then review the
   component-wide mobile mode. For crowded mobile headers, keep only priority
   icons on `both` and mark the rest `desktop`.

## Roll back to an earlier component

Do not remove either earlier component until the replacement has passed
staging. Rollback is:

1. Disable Brand Navigation.
2. Re-enable the earlier component on the parent theme.
3. Restore its exported settings if they were changed.
4. Verify normal pages, mobile navigation, authentication, and an embedded
   discussion.

Brand Navigation does not mutate settings from either earlier component, core
site settings, or DiscussionBridge, so rollback has no data migration to
reverse.

## Roll back Brand Navigation to a release tag

Use this procedure when a Brand Navigation update causes a regression and the
site needs the previous known-working Brand Navigation release. It keeps the
same Discourse component record so its settings and theme attachments can be
preserved. This procedure is provisional: the project has not yet recorded the
complete pin-and-return workflow on staging. Review the current evidence in
[`TESTING.md`](TESTING.md) and test the complete procedure on staging first.

Prerequisites:

- Choose an existing Brand Navigation release tag that is documented as
  compatible with the site's Discourse release. Do not invent or move a tag.
- Export the current **Configuration bundle** and store it outside Discourse.
- Record the current component commit, the exact configured **Branch** field
  value (including blank/default), the separately displayed or resolved
  compatibility ref, `enabled` value, and every attached parent theme.
- Keep administrator access through Discourse safe mode available in case the
  active theme cannot render normally.

To pin the existing component to a release:

1. Open **Admin → Appearance → Themes & components → Components → Brand
   Navigation**.
2. Set Brand Navigation's `enabled` setting off. Do not delete or detach it.
3. Select **Change source**. Leave the repository URL as
   `https://github.com/CodeWorksLabs/brand-navigation.git`.
4. Enter the exact release tag, such as `v0.9.0`, in **Branch**, then submit the
   source change. Current Discourse uses this field for a named Git branch or
   tag; the release tag pins the component to that immutable revision.
5. Confirm the component reports the intended tag/commit with no import error.
   Verify that its parent-theme attachments and settings remain present.
6. If a setting needs restoration, import the saved configuration bundle only
   after confirming that the selected release supports that bundle schema.
7. Re-enable Brand Navigation and run the focused desktop, mobile,
   anonymous/authenticated, link, color, and embed checks before ending the
   rollback window.

While pinned to a tag, the component does not advance with `main` or a
`d-compat/<YYYY>.<M>` branch. Automatic update checks may still run, but the tag
itself is immutable.

To return to the supported current channel:

1. Export the current bundle again and set Brand Navigation's `enabled` setting
   off.
2. Open **Change source**, leave the repository URL unchanged, clear **Branch**,
   and submit the source change.
3. Select **Check for updates**, then **Update to latest** when offered.
   Discourse will follow repository-default `main` on current core or resolve
   the maintained `d-compat/<YYYY>.<M>` ref appropriate to an older supported
   core.
4. Confirm the intended commit/ref, zero import errors, preserved settings, and
   parent-theme attachments.
5. Re-enable Brand Navigation and repeat the focused acceptance checks.

Do not edit a Git-installed remote component locally, force-move a release tag,
or delete and reinstall the component as a normal rollback method. If the
source change fails, keep the component disabled, capture the displayed error,
and restore the exact prior configured **Branch** field value—including a
blank/default value—before making another attempt. After a native update,
separately verify the resolved compatibility ref rather than copying that
resolved ref into **Branch**.
