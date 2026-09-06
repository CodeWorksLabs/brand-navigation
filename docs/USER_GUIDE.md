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
5. Leave the default `enabled` setting off while preparing and reviewing the
   supplied sample settings on a live site.

The exact administration labels can vary slightly between Discourse releases.

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

### Move settings with a configuration bundle

Brand Navigation includes a versioned JSON bundle tool so an administrator can
export, validate, and apply a complete portable configuration without entering
each navigation row again. Bundles contain portable theme settings only. They
do not contain API credentials, uploaded logo identifiers, theme attachments,
or an instruction to enable the component.

On the Brand Navigation administration page, the **Configuration bundles**
panel appears immediately above the Preview/Export/Disable controls. Select
**Export settings** to download the current portable configuration. To import,
select **Choose bundle** and pick a `.json` bundle, or paste its contents into
**Or paste bundle JSON**. Review any validation errors and then select **Import
settings**.

Discourse loads a theme component's administrator panel only when that
component belongs to the administrator's active theme. If the bundle panel is
not visible on a newly installed component, leave Brand Navigation's `enabled`
setting off, attach the component to the administrator's active theme, and
reload its administration page. Import the bundle before enabling its visible
navigation.

The browser importer validates the complete portable schema and submits all
settings in one Discourse theme update. It does not intentionally save a partial
bundle. If the browser loses the response after submission, reload the
component settings and verify the displayed values before retrying.

The same operations are available from a local checkout for automation:

```text
pnpm bundle validate configurations/repeal-obbba.json
pnpm bundle export my-navigation.json --url https://forum.example.com --theme-id 19
pnpm bundle apply my-navigation.json --url https://forum.example.com --theme-id 19
```

The `export` and `apply` commands read `DISCOURSE_API_KEY` and
`DISCOURSE_API_USERNAME` from the process environment. Keep the API key out of
the bundle, shell history, documentation, and source control. Review and
validate a bundle before applying it.

The CLI accepts only a canonical HTTPS forum origin: no path, query, embedded
credentials, or fragment. It refuses redirects, bounds response time and size,
and sanitizes server error text. Export refuses to replace an existing file
unless `--overwrite` is supplied explicitly.

Applying a bundle updates only Brand Navigation settings through Discourse's
admin theme endpoint. It cannot attach the component to a theme,
enable it, change another component, or delete anything. Upload light and dark
logos separately because Discourse upload identifiers are site-specific.

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
Selecting **Save Changes** persists the complete navigation configuration and
keeps you in the structured editor so you can continue working or verify the
saved entry. Use the Brand Navigation breadcrumb when you are ready to return
to the component's main settings page.

Each top-level entry supports:

| Field               | Purpose                                                                                    |
| ------------------- | ------------------------------------------------------------------------------------------ |
| `label`             | Required visible text.                                                                     |
| `url`               | Destination for the top-level label. It may also be used when the entry has submenu items. |
| `link_mode`         | Use the parent label as a live link or as a submenu-only grouping control.                 |
| `title`             | Optional hover tooltip.                                                                    |
| `icon`              | Optional Font Awesome 6 icon name.                                                         |
| `presentation`      | Show the icon and label, label only, or icon only.                                         |
| `section`           | Keep the item beside the brand (`left`) or align it to the far edge (`right`).             |
| `surface`           | Show the item in the Brand Navigation `bar` or as a `site_header` icon.                    |
| `device_visibility` | Show on both device classes, desktop/tablet only, or mobile phones only.                   |
| `target`            | Open in the same window (`_self`) or a new window (`_blank`).                              |
| `visibility`        | Show to everyone, anonymous visitors, or authenticated users.                              |
| `children`          | Ordered submenu links below this entry.                                                    |

A top-level entry behaves as:

- a direct link when it has a URL and no children; or
- a submenu control when it has children but no URL; or
- a functioning parent link with a separate submenu caret when it has both a
  URL and children.

Choose `group` when the top-level label should only open its submenu. Group
mode preserves the saved URL for easy re-enabling but does not render it. This
is preferable to placeholder destinations such as `#`.

Every child entry requires a label and URL. Child entries also support a hover
tooltip, optional visible description, icon, target, audience visibility, and
device visibility. A visible description appears as secondary text below its
label. Empty descriptions retain the compact menu. Only one submenu level is
supported; child entries cannot contain another submenu.

For an icon-only link, keep a clear `label`: Brand Navigation uses it as the
link's accessible name. If the configured icon is missing, the visible label
appears automatically instead of leaving an empty link.

Top-level items in the `left` section appear beside the brand. Items in the
`right` section form a group at the far edge of the bar, which is useful for
account links and calls to action. On mobile, both sections become one compact
ordered list so every item remains easy to reach.

Set a direct icon link's `surface` to `site_header` to place it among
Discourse's core header icons instead of in the Brand Navigation bar. This is
useful for social destinations when bar space is limited. Site-header items
must have a URL and icon and cannot contain children. Their label remains the
accessible name and their title remains the optional tooltip. Other items keep
the default `bar` surface.

Use `device_visibility` to control constrained mobile layouts independently for
each item:

- `both` shows the item on desktop/tablet devices and mobile phones and is the
  default.
- `desktop` shows the item only on desktop/tablet devices.
- `mobile` shows the item only on mobile phones.

Device visibility follows Discourse's supported physical-device capability, so
rotating a phone does not make Desktop-only items appear. It is independent of
`mobile_mode`, which controls whether the responsive mobile layout uses a menu,
bar, or no Brand Navigation surface.

For a large social set, keep a few priority `site_header` icons on `both`, mark
the remainder `desktop`, and retain a Social submenu on `both` so every
destination remains reachable on mobile. Existing configurations without this
field behave as `both`.

Example navigation plan:

| Top-level entry | URL       | Children               | Result                                                 |
| --------------- | --------- | ---------------------- | ------------------------------------------------------ |
| Community       | `/latest` | None                   | Direct internal link                                   |
| Resources       | `/about`  | Documentation, Support | Linked label plus a separate submenu caret             |
| Account help    | `/faq`    | None                   | Direct link that can be limited to authenticated users |

Use relative paths such as `/latest` for destinations on the same Discourse
site. Use complete `https://` URLs for external destinations. Protocol-relative,
HTTP, credential-bearing, script, placeholder, and malformed URLs are rejected
by bundle/editor validation and fail closed at rendering. New-window links
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
- `hidden` does not display any Brand Navigation surface on a responsive mobile
  view, including Brand Navigation links placed in the Discourse site header.

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
navigation entries open immediately. For a linked parent with children, select
its label to visit the parent destination or its down-caret to open the submenu.
When a parent has no URL, the complete entry opens its submenu.

Keyboard users can press Tab to reach links and submenu controls separately. Press Enter
or Space on a submenu control to expand or collapse it, or Escape to close it
and return focus to its control. Opening another submenu, selecting one of its
links, or selecting outside the submenu also closes it. On mobile sites using
`menu` mode, open the Brand Navigation menu from its menu button in the
Discourse header.

## Verify the configuration

Before enabling the component broadly, check:

1. A normal desktop page with a signed-out visitor.
2. A normal desktop page with a signed-in user.
3. Mobile layout in the selected mobile mode.
4. Every direct link, linked submenu parent, child link, and brand destination.
5. Light and dark color schemes.
6. Keyboard navigation: tab to links and submenu summaries, then use Enter or
   Space to open a submenu and Escape to close it.
7. New-window links.
8. A supported embedded discussion, confirming that Brand Navigation is absent
   while the embedded discussion and its core controls remain available.

## Disable or roll back

Set `enabled` off to stop Brand Navigation from rendering. Disabling the
component does not delete its configuration.

When replacing Brand Header, Header Submenus, or Custom Header Links (icons),
keep the earlier component and an export of its settings until Brand Navigation
has passed staging. See
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
- Check its device visibility in the current desktop or mobile layout.

### A submenu is empty or incomplete

- Confirm each child has both a label and a valid URL.
- Check the visibility rule on each child.
- Check the child device visibility in the current layout.

### The layout is crowded on mobile

Change `mobile_mode` from `bar` to `menu`, mark lower-priority items as
desktop-only, reduce the number of top-level entries, or group related
destinations under submenus.

### The colors do not match the site

Brand Navigation uses Discourse color-scheme variables. Check the active theme
and color scheme before adding parent-theme overrides.
