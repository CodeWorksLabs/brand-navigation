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
2. Select the **Components** tab, choose **Install → From a git repository**,
   and enter:

   ```text
   https://github.com/CodeWorksLabs/brand-navigation.git
   ```

3. Do not attach the component to a visitor-facing theme yet. Add it to a
   non-default staging theme that visitors do not use.
4. Turn Discourse's component-level **Enabled?** control on. Discourse does not
   load a disabled component's JavaScript, including Brand Navigation's bundle
   panel.
5. Use Discourse's **Preview** control for the staging theme, then open Brand
   Navigation's settings in that preview context. Configure the supplied sample
   settings or import a configuration bundle and verify the staging preview.
6. Attach the prepared component to the intended visitor-facing theme only when
   the navigation is ready.

Discourse's component-level **Enabled?** control is the single source of truth
for activation. Brand Navigation intentionally has no separate enable setting.

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

Install from the repository's default branch rather than pinning a custom
branch. Brand Navigation's `main` branch targets current Discourse. For a
maintained older Discourse release, the updater automatically selects the
matching `d-compat/<YYYY>.<M>` branch when one exists. This selection is part of
Discourse's native remote-theme update behavior; administrators do not need to
choose the compatibility branch manually.

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
each navigation row again. Bundles contain the portable theme settings plus
non-functional export metadata: `exported_at`, `source_theme_id`, and
`source_theme_name`. The importer does not apply those metadata fields. Bundles
do not contain API credentials, uploaded logo identifiers, theme attachments,
or an instruction to enable the component.

On the Brand Navigation administration page, the **Configuration bundles**
panel appears immediately above the Preview/Export/Disable controls. Select
**Export settings** to download the current portable configuration. To import,
select **Choose bundle** and pick a `.json` bundle, or paste its contents into
**Or paste bundle JSON**. Review any validation errors and then select **Import
settings**.

Discourse loads a theme component's custom administrator JavaScript only when
the component is enabled and belongs to the resolved theme. For a newly
installed component, use the non-default staging-theme procedure in
[Install the component](#install-the-component): attach Brand Navigation only to that staging
theme, enable the component, open the staging theme's Discourse preview, and
then open Brand Navigation's settings within the preview context. Import and
verify the bundle before attaching the component to a visitor-facing theme.

Turning the native **Enabled?** control off also removes the custom bundle
panel. This is expected Discourse component loading behavior, not a separate
Brand Navigation activation state.

The browser importer validates the complete portable schema and submits all
settings in one Discourse theme update. It does not intentionally save a partial
bundle. If the browser loses the response after submission, reload the
component settings and verify the displayed values before retrying.
Conflicting appearance, file, paste, and export controls remain disabled while
a save or import is pending. Export refuses to create a download larger than
the 1,000,000-byte file ceiling or with navigation data larger than Discourse's
524,288-byte serialized object-setting limit, so every successful download
remains eligible for re-import.

An optional local command validates a saved bundle without contacting a forum:

```text
pnpm bundle validate configurations/repeal-obbba.json
```

Import and export are intentionally administrator-browser operations in
`v1.0.0-rc.1`. Brand Navigation does not ship a credentialed command-line
client; adding one would be future product scope rather than part of the
current RC. Upload light and dark logos separately because Discourse upload
identifiers are site-specific.

### If an upgrade causes a problem

1. Turn off Discourse's component-level **Enabled?** control to stop Brand
   Navigation from rendering.
2. If Brand Navigation replaced another component, follow the documented
   rollback procedure and temporarily re-enable that component.
3. To return Brand Navigation itself to a known release, follow
   [Roll back Brand Navigation to a release tag](MIGRATION.md#roll-back-brand-navigation-to-a-release-tag).
   That procedure remains provisional until its complete staging evidence is
   recorded in [`TESTING.md`](TESTING.md). It handles an already-disabled
   component by first isolating it on a non-default staging theme, then turning
   native **Enabled?** on before requiring the preview or configuration export.
4. Restore the previously recorded settings when required.
5. Report the Brand Navigation release, Discourse version, active theme, and
   observed error before trying the update again.

Do not edit a Git-installed remote component locally to patch an upgrade.
Maintain custom overrides in a separate local component, or use a maintained
fork when code changes are required.

## Settings reference

Open Brand Navigation under **Appearance → Themes & components → Components**.
This reference follows its administration page. Your saved values may differ
from the installation defaults below.

The **navigation bar** is Brand Navigation's separate branded bar. The
**Discourse header** is the area containing the forum logo and login/profile
controls. Header color and size settings affect only the links and icons added
by Brand Navigation, not Discourse's own controls.

### Component and update controls

| Control                               | What it does                                                                                                                                    |
| ------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------- |
| Component name                        | Identifies this installed copy in administration. Renaming it does not change the brand name visitors see.                                      |
| Repository and License links          | Open the installed component's source repository and license.                                                                                   |
| Check for updates / Update to latest  | Check the configured remote source, then install its newer revision when an update is available. Back up settings first.                        |
| Change source                         | Changes the component's Git source or tracked revision. This is not a navigation setting; do not change it merely to configure links or colors. |
| Auto update when Discourse is updated | Allows Discourse to update this remote component during a Discourse update. It does not select or save navigation options.                      |
| Include component on these themes     | Chooses which themes use this component. Removing one attachment affects that theme; disabling the component affects every attached theme.      |
| View change history                   | Opens the staff action log for the component or individual setting.                                                                             |
| Extra files                           | Lists additional files supplied by the component. It is not a place to configure navigation.                                                    |
| Reset beside a setting                | Restores that setting's supplied default, not the whole component. A dot/highlight indicates a value changed from its default.                  |

### Brand and placement settings

| On-screen setting / saved name            | Options and purpose                                                                                                                                         |
| ----------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Outlet (`outlet`)                         | `above-site-header` (default): bar above Discourse's header. `below-site-header`: bar below it. Does not reposition links assigned to the Discourse header. |
| Show brand (`show_brand`)                 | On by default. Show the configured logo/name area; turn off for navigation without a brand link. Does not disable the menus or header links.                |
| Brand name (`brand_name`)                 | The visible name and accessible name of the brand link; default `Brand Navigation`. Up to 100 characters.                                                   |
| Brand URL (`brand_url`)                   | Where the brand logo/name links; default `/`. Use a site-relative path or a complete HTTPS URL.                                                             |
| Brand logo (`brand_logo`)                 | Upload the light-theme logo. Empty by default.                                                                                                              |
| Brand logo dark (`brand_logo_dark`)       | Optional dark-theme logo. When empty, uses the light logo.                                                                                                  |
| Brand presentation (`brand_presentation`) | `logo_and_name` (default), `logo_only`, or `name_only`. A missing logo/name is not invented automatically.                                                  |
| Brand target (`brand_target`)             | `_self` (default): same tab. `_blank`: new tab. Applies only to the brand logo/name; menu links have their own Target.                                      |
| Mobile mode (`mobile_mode`)               | `menu` (default): compact menu button. `bar`: full navigation bar. `hidden`: hide Brand Navigation, including its Discourse-header links, in mobile view.   |

### Color settings and Appearance

Use the color pickers in **Appearance**, below Theme translations. All eleven
settings below have a picker: turn **Custom** on, choose a color, then select
**Save colors**. With Custom off, the default color stays in effect. You do not
need to know a CSS variable name or type a hex code to use the pickers.

| On-screen setting / saved name                                  | What changes                                                                                                             |
| --------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------ |
| Bar background color (`bar_background_color`)                   | Background of the separate navigation bar.                                                                               |
| Bar text color (`bar_text_color`)                               | Text and icons in that bar.                                                                                              |
| Hover background color (`hover_background_color`)               | Background of navigation menu items on hover/focus and active highlights, including dropdown destinations.               |
| Submenu background color (`submenu_background_color`)           | Dropdown menu background.                                                                                                |
| Submenu text color (`submenu_text_color`)                       | Normal dropdown text and icons, including descriptions.                                                                  |
| Submenu hover text color (`submenu_hover_text_color`)           | Dropdown text and icons on hover/focus. With no override, follows the normal dropdown text color.                        |
| Header icon color (`header_icon_color`)                         | Normal color of Brand Navigation's icons in the Discourse header. Does not recolor link text.                            |
| Header icon hover color (`header_icon_hover_color`)             | Those icons on hover/focus. With no override, uses the theme's header-icon hover color.                                  |
| Header text color (`header_text_color`)                         | Normal color of Brand Navigation's link text in the Discourse header. Does not recolor icons.                            |
| Header text hover color (`header_text_hover_color`)             | That text on hover/focus. With no override, uses the theme's header text color independently of any custom normal color. |
| Header hover background color (`header_hover_background_color`) | Background behind both Brand Navigation text links and icon links in the Discourse header on hover/focus.                |

The raw fields above Theme translations are the same saved color settings, not
a second set of colors. A blank field means no override; a custom field accepts
six hexadecimal digits with or without `#`, such as `#002147`. **Inherit all**
in Appearance clears color overrides only. It does not reset sizes, links or
logos. Choose custom colors that remain readable in both light and dark themes.

### Header size settings

These number controls stay in the component settings; they are not color
pickers. Each is independent. Enter `0` to keep the theme/component default,
or a whole number from `1` to `48` for pixels. For example, `20` means 20px.

| On-screen setting / saved name                        | What changes                                                                        |
| ----------------------------------------------------- | ----------------------------------------------------------------------------------- |
| Header icon size desktop (`header_icon_size_desktop`) | Brand Navigation icons in the Discourse header in desktop view.                     |
| Header icon size mobile (`header_icon_size_mobile`)   | Those icons in Discourse's mobile view. Does not inherit a custom desktop value.    |
| Header text size desktop (`header_text_size_desktop`) | Brand Navigation link text in the Discourse header in desktop view.                 |
| Header text size mobile (`header_text_size_mobile`)   | That link text in Discourse's mobile view. Does not inherit a custom desktop value. |

Mobile means Discourse's mobile view, not just a narrow desktop window. These
settings do not resize the separate navigation bar or native Discourse controls.

### Navigation and icon settings

**Navigation items** (`navigation_items`) opens the structured menu editor.
Its defaults are sample Community/Resources links plus visitor/account links;
replace them with your destinations. See [Add navigation](#add-navigation) for
every menu-item field, option and example. Save there, then refresh the forum
page to load the changed navigation.

**Custom font awesome icons** (`custom_font_awesome_icons`) is the list of icon
names Discourse needs to include for your navigation. Add each icon you use,
one entry per name; this list does not create links by itself. The supplied
examples use `comments`, `book-open`, `circle-info`, `globe`, `user-plus` and
`user-gear`. See [Configure icons](#configure-icons).

### Configuration bundles and bottom-page actions

| Control              | What it does                                                                                                                                                                                                           |
| -------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Choose bundle        | Select a Brand Navigation JSON configuration previously exported from another installation or backup.                                                                                                                  |
| Or paste bundle JSON | Supply the same configuration as text instead of a file. Validation errors must be resolved before import.                                                                                                             |
| Import settings      | Apply the validated configuration. Does not attach/enable the component, upload logos, or import Theme translations.                                                                                                   |
| Export settings      | Download a portable settings backup. Does not include uploaded logos, theme attachments or translation overrides.                                                                                                      |
| Preview              | Open a preview using Discourse's theme preview controls. Does not publish settings to another site.                                                                                                                    |
| Export               | Discourse's component archive export, distinct from Brand Navigation's JSON settings export.                                                                                                                           |
| Convert              | Convert this component into a theme. Not needed to use Brand Navigation; it changes how Discourse treats the installed copy.                                                                                           |
| Disable / Enable     | Stop or resume the component on every attached theme without deleting its settings.                                                                                                                                    |
| Settings Editor      | Advanced JSON editor for setting names and values. It is not the component's source-code editor or Brand Navigation's portable bundle format. Back up settings first; use the individual controls for routine changes. |
| Delete               | Remove this installed component. Back up configuration first; disabling is the appropriate temporary stop.                                                                                                             |

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

## Configure colors

The **Appearance** panel on the Brand Navigation administration page provides
color pickers for the bar background, bar text and icons, hover/highlight
background, submenu background, submenu text and icons, submenu hover text,
core-header icons, core-header link text and the core-header hover background.
Normal and hover/focus colors can be overridden independently.

Leave **Custom** off to inherit the active Discourse color scheme. This is the
recommended starting point because inherited colors automatically follow the
site's light and dark palettes. Turn **Custom** on for a color, choose a value,
and select **Save colors** to override it. **Inherit all** clears all eleven
overrides and returns the component to Discourse's palette variables.

The two core-header controls (`header_icon_color` and
`header_icon_hover_color`) affect only Brand Navigation icons on the
`site_header` surface, in either alignment and with either icon-only or
icon-and-label presentation. The hover color also applies to keyboard focus.
They do not change link text, brand-bar icons, or Discourse's own header icons.
Blank values inherit the active theme's `--d-header-icon-color` and
`--d-header-icon-color--hover`, including light/dark palette changes. Custom
colors are fixed across palettes; choose readable colors for both modes.

Use the Discourse-header **link text** and **link text on hover/focus** pickers to control
text separately from icons. The **link and icon background on hover/focus** picker applies to both
text and icon links. Blank values retain the theme/default colors. These
settings do not recolor Discourse's own header controls.

Use **Dropdown menus — text and icons on hover/focus** for a submenu destination
on hover and keyboard focus, including its description. If your normal text
and the menu highlight background are both navy, choose a contrasting
hover text color such as white. With Custom off, submenu hover text uses the
normal submenu text color.

Appearance values are included in Brand Navigation configuration bundle
exports. Colors may be entered as `#1A2B3C` or `1A2B3C`; the component renders
both forms and normalizes picker and bundle values to canonical `#RRGGBB`.

## Core-header sizes

The component settings provide separate **header_icon_size_desktop**,
**header_icon_size_mobile**, **header_text_size_desktop** and
**header_text_size_mobile** values. Leave each at `0` to use the Discourse
theme/default size, or choose an integer pixel size from `1` to `48`.

Icon and text sizes are independent, as are desktop and mobile values. Mobile
means Discourse's mobile view, not simply a narrow desktop window. Sizes apply
only to Brand Navigation's core-header links; the brand bar and native Discourse
icons are unchanged. Check larger values on a phone and in both alignments,
because long labels still have to fit the available header space.

Size settings are included in configuration bundles. **Inherit all** in
Appearance resets colors only; reset a size to `0` to restore its default.

## Add navigation

Open `navigation_items` and add entries in the order they should appear.
Selecting **Save Changes** persists the complete navigation configuration and
keeps you in the structured editor so you can continue working or verify the
saved entry. Use the Brand Navigation breadcrumb when you are ready to return
to the component's main settings page.

Each top-level entry supports:

| Field                 | Purpose                                                                                                           |
| --------------------- | ----------------------------------------------------------------------------------------------------------------- |
| `label`               | Required visible text.                                                                                            |
| `url`                 | Destination for the top-level label. It may also be used when the entry has submenu items.                        |
| `link_mode`           | `link` (default): label opens its URL. `group`: label only opens its submenu and keeps any saved URL unused.      |
| `title`               | Optional hover tooltip.                                                                                           |
| `icon`                | Optional Font Awesome 6 icon name.                                                                                |
| `presentation`        | Bar: `icon_and_label` (default), `label_only`, or `icon_only`. Does not select the Discourse-header presentation. |
| `header_presentation` | For site-header items, choose `icon_only` (default), `label_only`, or `icon_and_label`.                           |
| `header_alignment`    | For site-header items, choose `left` beside the logo or `right` with the header controls (default).               |
| `section`             | Keep the item beside the brand (`left`) or align it to the far edge (`right`).                                    |
| `surface`             | Show the item in the Brand Navigation `bar` or as a direct `site_header` link.                                    |
| `device_visibility`   | `both` (default), `desktop`, or `mobile`. Follows device capability, not window width.                            |
| `target`              | Open in the same window (`_self`) or a new window (`_blank`).                                                     |
| `visibility`          | `everyone` (default), `anonymous` (signed out), or `authenticated` (signed in). Not an access-permission rule.    |
| `children`            | Ordered submenu links below this entry.                                                                           |

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

| Submenu field                           | Options and purpose                                                                                |
| --------------------------------------- | -------------------------------------------------------------------------------------------------- |
| Label (`label`)                         | Required text and accessible link name, up to 100 characters.                                      |
| URL (`url`)                             | Required safe destination, up to 2,048 characters.                                                 |
| Tooltip (`title`)                       | Optional hover text, up to 200 characters.                                                         |
| Visible description (`description`)     | Optional second line below the label, up to 300 characters.                                        |
| Icon (`icon`)                           | Optional Font Awesome icon name. Add it to Custom font awesome icons.                              |
| Presentation (`presentation`)           | `icon_and_label` (default), `label_only`, or `icon_only`.                                          |
| Device visibility (`device_visibility`) | `both` (default), `desktop`, or `mobile`. Parent visibility must also allow the item.              |
| Target (`target`)                       | `_self` (default): same tab. `_blank`: new tab.                                                    |
| Audience (`visibility`)                 | `everyone` (default), `anonymous`, or `authenticated`. Parent visibility must also allow the item. |

For an icon-only link, keep a clear `label`: Brand Navigation uses it as the
link's accessible name. If the configured icon is missing from Discourse's
active icon set, the visible label appears automatically instead of leaving an
empty bar or submenu link.

Top-level items in the `left` section appear beside the brand. Items in the
`right` section form a group at the far edge of the bar, which is useful for
account links and calls to action. On mobile, both sections become one compact
ordered list so every item remains easy to reach.

Set a direct link's `surface` to `site_header` to place it before Discourse's
core header controls instead of in the Brand Navigation bar. Choose its
**Site-header presentation** (`header_presentation`):

- `icon_only` retains the existing compact icon behavior and requires an icon.
  An unavailable icon omits the link until the icon becomes available.
- `label_only` displays text such as “Versions & Status” and needs no icon.
- `icon_and_label` displays both, retaining the text when its optional icon is
  unavailable or still loading.

Site-header items require a safe URL and cannot contain children or use group
mode. Their label remains the accessible name and their title remains the
optional tooltip. Existing entries default to `icon_only`; their separate bar
`presentation` value does not change their header appearance. Header links
follow the navigation list order within each side; `section` applies only to bar
items. Use **Site-header alignment** to place core-header links beside the logo
(`left`) or immediately before the header controls (`right`). Both positions
keep Brand Navigation links and icons before Sign Up and Log In, including
the default right-side placement. Missing or blank alignment defaults to right.
Left/right positions follow the reading
direction on RTL sites.

The editor's plus buttons use the friendly names **Menu item** and **Submenu
item**. These display labels do not rename stored schemas or change saved links.
After saving Target or other navigation changes, refresh the forum page before
testing them; already-open pages can retain their previous navigation settings.

Text is constrained to the smaller of 14rem and 30% of the viewport and uses
an ellipsis when needed. Its full label stays available to assistive technology
and as the default tooltip. Keep labels short and use device visibility to
reserve mobile space for Discourse's controls. Other items keep the default
`bar` surface. These capabilities are included in `v1.0.0-rc.2` and later;
RC1 supports only icon links in this surface.
Use the repository's tags and releases to identify published versions.

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

`outlet` controls the bar location:

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

## Theme translations

**Theme translations** changes the words used by the component, not what its
settings do. For example, editing `brand_navigation.appearance.header_text`
renames a color picker's label; it does not change that link's color. Use
**Appearance** for colors and **Navigation items** for your link destinations.

1. Open **Theme translations** on Brand Navigation's component page.
2. Choose the language in its locale selector (English is bundled).
3. Find the key for the label or message you want to change and edit its text.
4. Save the row's change and refresh the page where that text appears.

Preserve placeholders exactly: `%{label}` inserts a menu item's name,
`%{count}` inserts the file-size limit, and older inherited-color wording may
contain `%{variable}`. Translate the surrounding words, not the placeholder.

The available keys are grouped as follows; all start with `brand_navigation.`:

| Key after that prefix                                                                       | Text it changes                                                                          |
| ------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------- |
| `open_menu`                                                                                 | Accessible instruction for the compact mobile menu button.                               |
| `open_submenu`                                                                              | Accessible instruction for a submenu button; keep `%{label}`.                            |
| `navigation_label`                                                                          | Accessible name for the navigation area.                                                 |
| `editor.menu_item`, `editor.submenu_item`                                                   | Friendly names in the structured editor's add-item controls.                             |
| `bundles.title`, `bundles.description`                                                      | Configuration bundles heading and explanation.                                           |
| `bundles.choose`, `bundles.paste`, `bundles.paste_placeholder`                              | File chooser label and JSON paste-field instructions.                                    |
| `bundles.import`, `bundles.export`                                                          | Import and export button text.                                                           |
| `bundles.import_success`, `bundles.import_error`                                            | Import outcome messages.                                                                 |
| `bundles.file_too_large`                                                                    | Oversized-file message; keep `%{count}`.                                                 |
| `appearance.title`, `appearance.description`, `appearance.scope`                            | Appearance heading, explanation and affected-area guidance.                              |
| `appearance.custom`, `appearance.inherited`                                                 | Custom checkbox label and default-color status.                                          |
| `appearance.save`, `appearance.reset`                                                       | Save colors and Inherit all button labels. Renaming them does not change their behavior. |
| `appearance.save_success`, `appearance.save_error`                                          | Color-saving outcome messages.                                                           |
| `appearance.bar_background`, `appearance.bar_text`, `appearance.hover_background`           | Navigation-bar and menu-highlight color picker labels.                                   |
| `appearance.submenu_background`, `appearance.submenu_text`, `appearance.submenu_hover_text` | Dropdown background, normal text/icons and hover/focus text/icons labels.                |
| `appearance.header_icon`, `appearance.header_icon_hover`                                    | Discourse-header icon normal and hover/focus color labels.                               |
| `appearance.header_text`, `appearance.header_text_hover`                                    | Discourse-header link-text normal and hover/focus color labels.                          |
| `appearance.header_hover_background`                                                        | Shared header-link/icon hover-background picker label.                                   |

New guidance keys appear after the component update containing them; an older
installed revision may show fewer rows. Translation overrides are local to this
site and language and are not included in Brand Navigation configuration bundles.

Brand Navigation uses Discourse's theme-translation system for fixed visitor
and administrator interface text. Brand Navigation bundles only English in
`locales/en.yml`. Other languages can be customized through Discourse's theme
translations. The English catalog includes
navigation accessibility labels, appearance and configuration-bundle controls,
setting descriptions, and status messages.

An administrator can open **Theme translations** for Brand Navigation, select
the locale to customize, and override individual strings without editing the
component repository. These overrides belong to that Discourse site and locale;
repeat the customization for every supported locale that needs different text.
Repository updates normally retain local overrides, but removed or renamed
translation keys should be checked during an upgrade.

Detailed bundle-schema validation messages currently remain English. Standard
panel labels, accessibility text, controls, success messages, and fallback
failure messages use theme translation keys.

Navigation labels, tooltips, and visible descriptions entered in
`navigation_items` are site configuration rather than translation keys. One
configured value is currently shown to every locale. Sites that require
localized navigation content should account for that limitation when enabling
per-user locales.

Reviewed translations can be contributed upstream by adding the appropriate
locale YAML file with the same key structure as `locales/en.yml`. Do not rely on
unreviewed machine translation for public interface text, accessibility labels,
or administrator instructions.

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

Automated checks cover accessible names, responsive visibility, mobile layout,
and embed exclusion. Keyboard and focus-return behavior has source and partial
manual evidence, but not a dedicated current-candidate automated focus-return
regression. These checks do not replace human screen-reader or RTL-locale
acceptance. The exact completed and outstanding manual evidence is maintained
in [`TESTING.md`](TESTING.md).

## Disable or roll back

Turn off Discourse's component-level **Enabled?** control to stop Brand
Navigation from rendering. Disabling the component does not delete its
configuration.

When replacing Brand Header, Header Submenus, or Custom Header Links (icons),
keep the earlier component and an export of its settings until Brand Navigation
has passed staging. See
[Migration and rollback](MIGRATION.md) for the detailed procedure.

For a regression caused by a Brand Navigation update, keep the existing
component record and review the provisional
[release-tag rollback](MIGRATION.md#roll-back-brand-navigation-to-a-release-tag).
It is not release-supported until its complete pin-and-return workflow is
recorded on staging in [`TESTING.md`](TESTING.md).

## Troubleshooting

### Nothing appears

- Confirm Discourse's component-level **Enabled?** control is on.
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

### Report a problem

Use [GitHub Issues](https://github.com/CodeWorksLabs/brand-navigation/issues)
for non-sensitive bugs, installation or configuration questions, compatibility
reports, and feature requests. Include the Brand Navigation release, branch, or
commit; Discourse version and active theme; browser, device, viewport, and
signed-in state; reproduction steps; and sanitized settings or console evidence
when relevant.

Never post credentials, personal data, or non-public vulnerability details in a
public issue. Report suspected vulnerabilities privately to
[security@codeworkslabs.dev](mailto:security@codeworkslabs.dev) under the
[security policy](../SECURITY.md).
