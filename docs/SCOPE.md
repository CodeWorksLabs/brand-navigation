# Product scope

Brand Navigation is a Discourse theme component that adds your site's branding,
menus and links to the forum.

## Included

- A navigation bar above or below Discourse's header, with an optional brand area.
- Your brand name, logo and destination, with a separate logo for dark color
  schemes. Show the name, logo or both.
- Links to pages on your forum or other websites, arranged in your chosen order.
- One level of dropdown menus. A parent can open a page with a separate arrow
  for its submenu, or act only as a menu heading.
- Text, icons or both for navigation links, with optional tooltips and submenu
  descriptions.
- Direct text links, icons or both in Discourse's own header, placed beside the
  forum logo or before the header controls.
- Desktop, tablet and mobile layouts, with a compact mobile menu, wrapping
  navigation bar or an option to hide Brand Navigation on mobile.
- Per-link visibility for desktop/tablet, mobile or both, and for signed-in,
  signed-out or all visitors.
- Same-tab or new-tab destinations for the brand and individual links.
- Colors inherited from your theme's light and dark palettes, or custom colors
  for the bar, dropdowns and header links, including hover and keyboard focus.
  Enter colors directly or use the Appearance color pickers.
- Separate desktop and mobile sizes for Brand Navigation's header icons and
  link text, with the theme's sizes used by default.
- Keyboard-operated menus and accessible names for links and controls.
- Settings and menu editing in Discourse administration, with sample links,
  checks for invalid settings and Discourse's standard component enable control.
- Preparation on a non-default preview theme before making navigation visible
  to visitors. A shared component still shares code and settings across themes;
  use a separate component copy or staging site to isolate changes to a live setup.
- Settings backup, restore and transfer between sites using configuration
  bundles. Uploaded logos and theme attachments are handled separately.
- Customizable visitor and administrator interface wording through Theme
  translations. Configured link labels are separate from those translations.
- Navigation on forum pages without adding it to supported embedded Discourse
  discussions or changing their controls.

## Excluded

- Building general website pages or managing website content.
- Menus nested more than one submenu level deep.
- Replacing Discourse's sign-in system, topic controls or composer. Link visibility
  is not an access restriction; use Discourse permissions for protected content.
- Changing how Discourse embeds discussions on other websites.
- DiscussionBridge-specific compatibility features.
- Embedding workarounds based on site addresses, CSS hiding or page-element
  selectors.
- Requiring changes to Discourse core to install or use Brand Navigation.
