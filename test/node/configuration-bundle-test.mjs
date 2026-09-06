import assert from "node:assert/strict";
import test from "node:test";

import {
  BUNDLE_FORMAT,
  BUNDLE_VERSION,
  createBundle,
  normalizeSettingValue,
  themeSettingValue,
  validateBundle,
} from "../../scripts/brand-navigation-config.mjs";

test("validates a portable configuration bundle", () => {
  const bundle = createBundle({
    brand_name: "Example",
    navigation_items: [{ label: "Home", url: "/" }],
    custom_font_awesome_icons: "house|comments",
  });

  assert.equal(bundle.format, BUNDLE_FORMAT);
  assert.equal(bundle.version, BUNDLE_VERSION);
  assert.deepEqual(bundle.settings.custom_font_awesome_icons, [
    "house",
    "comments",
  ]);
  assert.deepEqual(validateBundle(bundle), []);
});

test("rejects unsafe or unsupported settings", () => {
  const errors = validateBundle({
    format: BUNDLE_FORMAT,
    version: BUNDLE_VERSION,
    settings: { enabled: true, parent_theme_ids: [1] },
  });

  assert.deepEqual(errors, [
    "Unsupported setting: enabled.",
    "Unsupported setting: parent_theme_ids.",
  ]);
});

test("rejects placeholder submenu destinations", () => {
  const errors = validateBundle({
    format: BUNDLE_FORMAT,
    version: BUNDLE_VERSION,
    settings: {
      navigation_items: [
        {
          label: "People",
          children: [{ label: "Coming soon", url: "#" }],
        },
      ],
    },
  });

  assert.deepEqual(errors, [
    'Submenu item "Coming soon" uses a placeholder URL.',
  ]);
});

test("validates site-header items as direct icon links", () => {
  const bundle = createBundle({
    navigation_items: [
      { label: "No icon", url: "/about", surface: "site_header" },
      {
        label: "Has children",
        url: "/about",
        icon: "circle-info",
        surface: "site_header",
        children: [{ label: "Child", url: "/faq" }],
      },
    ],
  });

  assert.deepEqual(validateBundle(bundle), [
    'Site-header item "No icon" requires a URL and icon.',
    'Site-header item "Has children" cannot contain submenu items.',
  ]);
});

test("serializes object and icon-list values for the Discourse endpoint", () => {
  assert.equal(
    normalizeSettingValue("navigation_items", [{ label: "Home" }]),
    '[{"label":"Home"}]'
  );
  assert.equal(
    normalizeSettingValue("custom_font_awesome_icons", ["house", "comments"]),
    "house|comments"
  );
  assert.equal(
    themeSettingValue("custom_font_awesome_icons", ["house", "comments"]),
    "house|comments"
  );
  assert.deepEqual(themeSettingValue("navigation_items", [{ label: "Home" }]), [
    { label: "Home" },
  ]);
});

test("normalizes serialized settings returned by Discourse exports", () => {
  const bundle = createBundle({
    navigation_items: '[{"label":"Home","url":"/"}]',
    custom_font_awesome_icons: "house|comments",
  });

  assert.deepEqual(bundle.settings.navigation_items, [
    { label: "Home", url: "/" },
  ]);
  assert.deepEqual(bundle.settings.custom_font_awesome_icons, [
    "house",
    "comments",
  ]);
});
