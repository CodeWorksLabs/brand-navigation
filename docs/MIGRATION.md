# Migration and rollback

Migrate in a staging theme or a copied production theme first.

## From Brand Header

1. Record `brand_name`, `website_url`, light/dark/mobile logos, text links,
   icon links, targets, mobile behavior, and outlet.
2. Install Brand Navigation but leave `enabled` off.
3. Map the brand name and `website_url` to `brand_name` and `brand_url`.
4. Upload the light and dark logos. Brand Navigation intentionally uses the
   light logo as the dark fallback and responsive sizing instead of a separate
   mobile-logo setting.
5. Add text links as top-level `navigation_items`.
6. Add icon-only predecessor links as labeled navigation entries. A visible
   label is required for clear administration and accessibility.
7. Select the equivalent outlet and mobile mode.
8. Disable Brand Header, enable Brand Navigation, and run the acceptance checks.

## From Header Submenus

1. Export or copy the `Menu_items`, `Submenu_items`, icon list, placement, and
   color choices before changing anything.
2. Install Brand Navigation but leave `enabled` off.
3. Create one structured top-level item for every menu item.
4. Add each submenu entry under its parent. Divider-only entries have no direct
   equivalent; use grouping and ordering instead.
5. Replace `vdm`, `vdo`, and `vmo` device tokens with the component-wide mobile
   mode. Per-link device visibility is intentionally not retained.
6. Keep color customization in the parent theme when needed; Brand Navigation
   defaults to Discourse color-scheme variables.
7. Disable Header Submenus, enable Brand Navigation, and run acceptance checks.

## Rollback

Do not remove either predecessor until the replacement has passed staging.
Rollback is:

1. Disable Brand Navigation.
2. Re-enable the predecessor component on the parent theme.
3. Restore its exported settings if they were changed.
4. Verify normal pages, mobile navigation, authentication, and an embedded
   discussion.

Brand Navigation does not mutate predecessor settings, core site settings, or
DiscussionBridge, so rollback has no data migration to reverse.
