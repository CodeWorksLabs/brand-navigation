# Administrator guide

This guide explains how to install, configure, verify, and disable Brand
Navigation. The component adds site-wide brand identity and one-level
navigation to normal Discourse application pages.

## Before you begin

- Test the component on a staging site or copied theme before enabling it for
  visitors.
- You need access to Discourse theme administration.
- Decide whether the bar should appear above or below the normal Discourse
  header.
- Prepare a brand name, destination, and optional light- and dark-scheme logos.
- List the navigation links and submenus you want to create.

Brand Navigation does not replace Discourse authentication, topic navigation,
the composer, or other core controls. It does not appear inside supported
Discourse embed contexts.

## Install the component

1. In Discourse administration, open **Appearance → Themes & components**.
2. Select the **Components** tab and install the component from its Git
   repository URL.
3. Add **Brand Navigation** to the theme or themes that should use it.
4. Open the component settings.
5. Leave `enabled` off while preparing settings on a live site.

The exact administration labels can vary slightly between Discourse releases.

## Start with the sample configuration

The current testing release includes a sample brand and navigation set. It is
designed to exercise a direct internal link, a submenu, an external
new-window link, icons, and anonymous/authenticated visibility without manual
data entry.

Use the sample for evaluation, then replace its labels, URLs, and icons with
site-specific values before production use. The sample is temporary while its
shape is evaluated for a future explicit testing and migration/move preset.

## Updates and upgrades

Yes. When Brand Navigation is installed from its Git repository, it uses the
normal Discourse remote-theme update system. The component does not implement
its own updater and does not contact a separate Brand Navigation service.

Discourse periodically checks remote themes and components for changes. An
administrator can also open Brand Navigation under **Appearance → Themes &
components** and select **Check for updates**. When Discourse finds a newer
revision, the control changes to **Update to latest**. Remote components are
eligible for Discourse's automatic-update behavior when that option is enabled
for the installation.

This tracking only applies when Brand Navigation was installed from its Git
repository. A component imported from a file or created locally is not linked
to this repository and therefore cannot receive its updates through the normal
remote-theme check.

### Recommended upgrade process

1. Read the Brand Navigation release notes for configuration, compatibility,
   and migration information.
2. Record or export the current component settings.
3. Apply the update to a staging site or staging theme first.
4. Verify desktop and mobile navigation, signed-in and signed-out visibility,
   links, color schemes, and an embedded discussion.
5. Update the production component through Discourse's **Update to latest**
   control.
6. Repeat the focused checks on production.

Discourse normally retains site-specific theme settings when it updates the
component's code from Git. Recording the settings first still provides a safe
recovery reference if a release changes the settings schema or defaults.

### If an upgrade causes a problem

1. Set `enabled` off to stop Brand Navigation from rendering.
2. If Brand Navigation replaced another component, follow the documented
   rollback procedure and temporarily re-enable that component.
3. Restore the previously recorded settings when required.
4. Report the Brand Navigation release, Discourse version, active theme, and
   observed error before trying the update again.

Do not edit a Git-installed remote component locally to patch an upgrade.
Maintain custom overrides in a separate local component, or use a maintained
fork when code changes are required.

## Configure the brand

The brand area is optional. Set `show_brand` off when you only want navigation.

| Setting              | Purpose                                                                       |
| -------------------- | ----------------------------------------------------------------------------- |
| `brand_name`         | Brand text and the accessible label for the brand link.                       |
| `brand_url`          | Destination opened when a visitor selects the brand.                          |
| `brand_logo`         | Logo for light color schemes.                                                 |
| `brand_logo_dark`    | Optional logo for dark color schemes. The light logo is the fallback.         |
| `brand_presentation` | Display the logo and name, only the logo, or only the name.                   |
| `brand_target`       | Open the destination in the same window (`_self`) or a new window (`_blank`). |

If neither a usable logo nor a brand name is configured, the brand area stays
empty even when `show_brand` is on.

## Add navigation

Open `navigation_items` and add entries in the order they should appear.

Each top-level entry supports:

| Field        | Purpose                                                                              |
| ------------ | ------------------------------------------------------------------------------------ |
| `label`      | Required visible text.                                                               |
| `url`        | Destination for a direct link. Leave it empty when the entry contains submenu items. |
| `title`      | Optional additional description.                                                     |
| `icon`       | Optional Font Awesome 6 icon name.                                                   |
| `target`     | Open in the same window (`_self`) or a new window (`_blank`).                        |
| `visibility` | Show to everyone, anonymous visitors, or authenticated users.                        |
| `children`   | Ordered submenu links below this entry.                                              |

A top-level entry behaves as:

- a direct link when it has a URL and no children; or
- a submenu when it has one or more children.

Every child entry requires a label and URL. Child entries also support a title,
icon, target, and visibility rule. Only one submenu level is supported; child
entries cannot contain another submenu.

Example navigation plan:

| Top-level entry | URL       | Children               | Result                                                 |
| --------------- | --------- | ---------------------- | ------------------------------------------------------ |
| Community       | `/latest` | None                   | Direct internal link                                   |
| Resources       | Empty     | Documentation, Support | Submenu                                                |
| Account help    | `/faq`    | None                   | Direct link that can be limited to authenticated users |

Use relative paths such as `/latest` for destinations on the same Discourse
site. Use complete `https://` URLs for external destinations. New-window links
automatically receive the appropriate safety relationship attributes.

## Configure icons

Enter a Font Awesome 6 icon name in an item's `icon` field. Add every icon used
by the component to `custom_font_awesome_icons` so Discourse includes it in the
site icon set. Labels remain required even when an icon is present.

If an icon does not appear, verify its name and confirm it is included in
`custom_font_awesome_icons`.

## Choose placement and mobile behavior

`outlet` controls the desktop bar location:

- `above-site-header` places Brand Navigation above the normal Discourse
  header.
- `below-site-header` places it below the normal Discourse header.

`mobile_mode` controls smaller screens:

- `menu` adds a compact menu button to the Discourse header.
- `bar` displays the full Brand Navigation bar.
- `hidden` does not display Brand Navigation on mobile.

Choose `menu` when space is limited or the navigation contains several items.
Check both portrait and landscape layouts before using `bar`.

## Control who sees a link

Each top-level and child item has an independent visibility setting:

- `everyone` shows the item to all visitors.
- `anonymous` shows the item only to signed-out visitors.
- `authenticated` shows the item only to signed-in users.

Visibility only controls presentation. It is not an authorization mechanism;
protect restricted destinations with Discourse permissions.

## Use Brand Navigation as a visitor

Select the brand logo or name to open the configured brand destination. Direct
navigation entries open immediately. Entries with a down-arrow are submenus;
select the entry to expand it and then select a child link.

Keyboard users can press Tab to reach links and submenu controls. Press Enter
or Space on a submenu control to expand or collapse it. On mobile sites using
`menu` mode, open the Brand Navigation menu from its menu button in the
Discourse header.

## Verify the configuration

Before enabling the component broadly, check:

1. A normal desktop page with a signed-out visitor.
2. A normal desktop page with a signed-in user.
3. Mobile layout in the selected mobile mode.
4. Every direct link, submenu, and brand destination.
5. Light and dark color schemes.
6. Keyboard navigation: tab to links and submenu summaries, then use Enter or
   Space to open a submenu.
7. New-window links.
8. A supported embedded discussion, confirming that Brand Navigation is absent
   while the embedded discussion and its core controls remain available.

## Disable or roll back

Set `enabled` off to stop Brand Navigation from rendering. Disabling the
component does not delete its configuration.

When replacing Brand Header or Header Submenus, keep the earlier component and
an export of its settings until Brand Navigation has passed staging. See
[Migration and rollback](MIGRATION.md) for the detailed procedure.

## Troubleshooting

### Nothing appears

- Confirm `enabled` is on.
- Confirm the component is attached to the active theme.
- Add at least one navigation item or configure a visible brand name or logo.
- If testing on mobile, confirm `mobile_mode` is not `hidden`.
- Brand Navigation is intentionally absent in supported embed contexts.

### A top-level item is missing

- Confirm it has either a URL or at least one child.
- Check its visibility rule using the appropriate signed-in or signed-out state.

### A submenu is empty or incomplete

- Confirm each child has both a label and a valid URL.
- Check the visibility rule on each child.

### The layout is crowded on mobile

Change `mobile_mode` from `bar` to `menu`, reduce the number of top-level
entries, or group related destinations under submenus.

### The colors do not match the site

Brand Navigation uses Discourse color-scheme variables. Check the active theme
and color scheme before adding parent-theme overrides.
