# Migration and rollback

Migrate in a staging theme or a copied production theme first.

## Configuration bundles

Use `pnpm bundle validate`, `pnpm bundle export`, and `pnpm bundle apply` to
move a versioned JSON configuration without recreating every object-setting
row. The tool calls Discourse's supported admin theme endpoint and
updates only the portable Brand Navigation settings listed in the bundle. It
does not attach or enable the component.

For normal administrator use, the same operation is available in the
**Configuration bundles** panel near the bottom of Brand Navigation's
administration page. A newly installed component must be attached to the
administrator's active theme before Discourse can load that panel; keep the
component's `enabled` setting off until after import and verification.

The repository's `configurations/repeal-obbba.json` file is the first migration
fixture. It was assembled from observed Brand Header, Dropdown Header, and
Custom Header Links (icons) settings and is also useful for exercising larger
menus, external destinations, icon-only links, and left/right sections.

API credentials are supplied through `DISCOURSE_API_KEY` and
`DISCOURSE_API_USERNAME`; they must never be stored in a bundle. Logo uploads
remain a separate site-local step.

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
6. Replace `vdm`, `vdo`, and `vmo` device tokens with the component-wide mobile
   mode. Per-link device visibility is intentionally not retained.
7. Keep color customization in the parent theme when needed; Brand Navigation
   defaults to Discourse color-scheme variables.
8. Disable Header Submenus, enable Brand Navigation, and run acceptance checks.

The same mapping applies to Pavilion's Dropdown Header: header links become
top-level items, dropdown rows become children matched to their parent, and
its icon list becomes `custom_font_awesome_icons`.

## From Custom Header Links (icons)

1. Export or record each title, icon, URL, device view, width, and target.
2. Map each link to a top-level Brand Navigation item in the `right` section.
3. Use `icon_only` presentation while retaining the full title as the required
   accessible label.
4. Map `blank` to `_blank` and `self` to `_self`.
5. Add every used icon to `custom_font_awesome_icons`.
6. Review mobile behavior. Brand Navigation intentionally uses a component-wide
   mobile mode rather than per-link `vdm`, `vdo`, and `vmo` tokens.

## Rollback

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
