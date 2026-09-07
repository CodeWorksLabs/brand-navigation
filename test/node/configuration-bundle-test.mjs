import assert from "node:assert/strict";
import test from "node:test";

import {
  isBrandNavigationTheme,
  persistThemeSettings,
  prepareThemeSettingsImport,
  snapshotPlainData,
} from "../../javascripts/discourse/lib/brand-navigation-admin.js";
import {
  isSafeNavigationUrl,
  normalizeColorSetting,
  readBundleFile,
} from "../../javascripts/discourse/lib/configuration-bundle.js";

import {
  BUNDLE_FORMAT,
  BUNDLE_VERSION,
  createBundle,
  serializeBundle,
  themeSettingValue,
  validateBundle,
} from "../../scripts/brand-navigation-config.mjs";

test("validates a portable configuration bundle", () => {
  const bundle = createBundle({
    brand_name: "Example",
    bar_background_color: "#123ABC",
    bar_text_color: "",
    navigation_items: [{ label: "Home", url: "/" }],
    custom_font_awesome_icons: "house|comments",
  });

  assert.equal(bundle.format, BUNDLE_FORMAT);
  assert.equal(bundle.version, BUNDLE_VERSION);
  assert.deepEqual(bundle.settings.custom_font_awesome_icons, [
    "house",
    "comments",
  ]);
  assert.equal(bundle.settings.bar_background_color, "#123ABC");
  assert.equal(bundle.settings.bar_text_color, "");
  assert.deepEqual(validateBundle(bundle), []);
});

test("accepts inherited or six-digit hex appearance colors", () => {
  assert.deepEqual(
    validateBundle({
      format: BUNDLE_FORMAT,
      version: BUNDLE_VERSION,
      settings: {
        bar_background_color: "16324F",
        bar_text_color: "#fF00aA",
        hover_background_color: "#123456",
        submenu_background_color: "#ABCDEF",
        submenu_text_color: "#000000",
      },
    }),
    []
  );
});

test("normalizes color settings to canonical uppercase hex", () => {
  assert.equal(normalizeColorSetting("16324f"), "#16324F");
  assert.equal(normalizeColorSetting("#ffffff"), "#FFFFFF");
  assert.equal(themeSettingValue("bar_background_color", "16324f"), "#16324F");

  const bundle = createBundle({ bar_background_color: "16324f" });
  assert.equal(bundle.settings.bar_background_color, "#16324F");
});

test("rejects malformed appearance colors", () => {
  assert.deepEqual(
    validateBundle({
      format: BUNDLE_FORMAT,
      version: BUNDLE_VERSION,
      settings: {
        bar_background_color: "red",
        bar_text_color: "#fff",
      },
    }),
    [
      "bar_background_color must be blank or a six-digit hex color such as #1A2B3C.",
      "bar_text_color must be blank or a six-digit hex color such as #1A2B3C.",
    ]
  );
});

test("rejects non-string appearance colors without coercion", () => {
  for (const value of [123456, true, null, [123456], { color: "123456" }]) {
    const errors = validateBundle({
      format: BUNDLE_FORMAT,
      version: BUNDLE_VERSION,
      settings: { bar_background_color: value },
    });

    assert.deepEqual(errors, [
      "bar_background_color must be blank or a six-digit hex color such as #1A2B3C.",
    ]);
  }
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

test("rejects malformed settings and unknown nested fields", () => {
  assert.deepEqual(
    validateBundle({
      format: BUNDLE_FORMAT,
      version: BUNDLE_VERSION,
      settings: [],
    }),
    ["settings must be an object."]
  );

  assert.deepEqual(
    validateBundle({
      format: BUNDLE_FORMAT,
      version: BUNDLE_VERSION,
      settings: {},
    }),
    ["settings must contain at least one portable setting."]
  );

  const errors = validateBundle({
    format: BUNDLE_FORMAT,
    version: BUNDLE_VERSION,
    settings: {
      show_brand: "yes",
      mobile_mode: "tiny",
      navigation_items: [
        {
          label: "Home",
          url: "javascript:alert(1)",
          surprise: true,
        },
      ],
      custom_font_awesome_icons: ["house", 42],
    },
  });

  assert.deepEqual(errors, [
    "settings.show_brand must be a boolean.",
    'settings.mobile_mode must be one of "menu", "bar", "hidden".',
    "Unknown field: navigation_items[0].surprise.",
    "navigation_items[0].url must be a safe relative or HTTPS URL.",
    "custom_font_awesome_icons[1] must be a non-empty string of at most 100 characters.",
  ]);
});

test("requires actionable rows and rejects nested child structures", () => {
  const errors = validateBundle({
    format: BUNDLE_FORMAT,
    version: BUNDLE_VERSION,
    settings: {
      navigation_items: [
        { label: "Inert" },
        {
          label: "Parent",
          children: [
            {
              label: "Child",
              url: "/child",
              children: [{ label: "Too deep", url: "/deep" }],
            },
          ],
        },
      ],
    },
  });

  assert.deepEqual(errors, [
    "navigation_items[0] with group link mode requires at least one child.",
    "Unknown field: navigation_items[1].children[0].children.",
  ]);
});

test("supports explicit linked and submenu-group parents", () => {
  const bundle = createBundle({
    navigation_items: [
      {
        label: "Product",
        url: "https://example.com/",
        link_mode: "group",
        children: [{ label: "Docs", url: "/docs" }],
      },
      {
        label: "Community",
        url: "/categories",
        link_mode: "link",
        children: [{ label: "Latest", url: "/latest" }],
      },
    ],
  });

  assert.equal(bundle.settings.navigation_items[0].link_mode, "group");
  assert.equal(bundle.settings.navigation_items[1].link_mode, "link");
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
    "navigation_items[0].children[0].url must be a safe relative or HTTPS URL.",
  ]);
});

test("validates top-level and child device visibility", () => {
  const errors = validateBundle({
    format: BUNDLE_FORMAT,
    version: BUNDLE_VERSION,
    settings: {
      navigation_items: [
        {
          label: "Desktop",
          url: "/desktop",
          device_visibility: "wide-screen",
          children: [
            {
              label: "Mobile",
              url: "/mobile",
              device_visibility: "phone",
            },
          ],
        },
      ],
    },
  });

  assert.deepEqual(errors, [
    'navigation_items[0].device_visibility must be one of "both", "desktop", "mobile".',
    'navigation_items[0].children[0].device_visibility must be one of "both", "desktop", "mobile".',
  ]);
});

test("validates site-header items as direct icon links", () => {
  assert.throws(
    () =>
      createBundle({
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
      }),
    /requires a URL and icon.*cannot contain children/
  );
});

test("exports are validated and icon lists round trip losslessly", () => {
  assert.throws(
    () => createBundle({ brand_name: "x".repeat(101) }),
    /Cannot export invalid settings/
  );
  assert.throws(
    () => createBundle({ custom_font_awesome_icons: ["house|comments"] }),
    /pipe delimiter/
  );

  const bundle = createBundle({
    custom_font_awesome_icons: ["house", "comments"],
  });
  assert.deepEqual(bundle.settings.custom_font_awesome_icons, [
    "house",
    "comments",
  ]);
});

test("validation requires plain data objects", () => {
  class BundleLike {
    format = BUNDLE_FORMAT;
    version = BUNDLE_VERSION;
    settings = { brand_name: "Example" };
  }

  assert.deepEqual(validateBundle(new BundleLike()), [
    "Bundle must be a JSON object.",
  ]);
  assert.deepEqual(validateBundle(new Date()), [
    "Bundle must be a JSON object.",
  ]);
  assert.deepEqual(validateBundle(new Map()), [
    "Bundle must be a JSON object.",
  ]);
  assert.deepEqual(validateBundle([]), ["Bundle must be a JSON object."]);
  assert.deepEqual(validateBundle(null), ["Bundle must be a JSON object."]);
});

test("oversized browser files are rejected before reading", async () => {
  let read = false;
  const file = {
    size: 1_000_001,
    async text() {
      read = true;
      return "{}";
    },
  };

  await assert.rejects(readBundleFile(file), /cannot exceed 1,000,000 bytes/);
  assert.equal(read, false);
});

test("exports cannot create bundles larger than the importer accepts", () => {
  const longUrl = `https://example.com/${"x".repeat(2028)}`;
  const children = Array.from({ length: 50 }, (_, index) => ({
    label: `Child ${index}`,
    url: longUrl,
    title: "t".repeat(200),
    description: "d".repeat(300),
    icon: "i".repeat(100),
  }));
  const navigationItems = Array.from({ length: 100 }, (_, index) => ({
    label: `Parent ${index}`,
    url: longUrl,
    title: "t".repeat(200),
    icon: "i".repeat(100),
    children,
  }));

  assert.throws(
    () => createBundle({ navigation_items: navigationItems }),
    /cannot exceed 1,000,000 bytes.*Reduce the number or length/i
  );

  const bundle = createBundle({
    navigation_items: [{ label: "Home", url: "/" }],
  });
  assert.ok(
    new TextEncoder().encode(serializeBundle(bundle)).length <= 1_000_000
  );
});

test("unknown fields are escaped for inert terminal diagnostics", () => {
  const [error] = validateBundle({
    format: BUNDLE_FORMAT,
    version: BUNDLE_VERSION,
    settings: { ["unsafe\u001b[2J\u0007"]: true },
  });

  assert.equal(error, "Unsupported setting: unsafe\\u001B[2J\\u0007.");
  assert.equal(/[\u0000-\u001f\u007f]/.test(error), false);
});

test("serializes object and icon-list values for browser imports", () => {
  assert.equal(
    themeSettingValue("custom_font_awesome_icons", ["house", "comments"]),
    "house|comments"
  );
  assert.equal(
    themeSettingValue("navigation_items", [{ label: "Home" }]),
    '[{"label":"Home"}]'
  );
});

test("URL and administrator component identities fail closed", () => {
  assert.equal(isSafeNavigationUrl("/latest"), true);
  assert.equal(isSafeNavigationUrl("/\\attacker.example/path"), false);
  assert.equal(isSafeNavigationUrl("//attacker.example/path"), false);
  assert.equal(isSafeNavigationUrl("http://example.com"), false);
  assert.equal(isSafeNavigationUrl("javascript:alert(1)"), false);

  const settings = [
    "brand_presentation",
    "custom_font_awesome_icons",
    "mobile_mode",
    "navigation_items",
    "submenu_text_color",
  ].map((setting) => ({ setting }));

  assert.equal(
    isBrandNavigationTheme({
      component: true,
      settings,
      remote_theme: {
        remote_url: "https://github.com/CodeWorksLabs/brand-navigation.git",
      },
    }),
    true
  );
  assert.equal(
    isBrandNavigationTheme({
      component: true,
      settings,
    }),
    true
  );
  assert.equal(
    isBrandNavigationTheme({ component: true, settings: settings.slice(1) }),
    false
  );
  assert.equal(isBrandNavigationTheme({ name: "Brand Navigation" }), false);
});

test("bundle import preflights every target setting before mutation", () => {
  const theme = {
    settings: [
      { setting: "brand_name" },
      { setting: "custom_font_awesome_icons" },
      { setting: "navigation_items" },
    ],
  };

  assert.deepEqual(
    prepareThemeSettingsImport(theme, {
      settings: {
        brand_name: "Example",
        custom_font_awesome_icons: ["house", "comments"],
        navigation_items: [{ label: "Home", url: "/" }],
      },
    }),
    {
      brand_name: "Example",
      custom_font_awesome_icons: "house|comments",
      navigation_items: '[{"label":"Home","url":"/"}]',
    }
  );
  assert.throws(
    () =>
      prepareThemeSettingsImport(theme, {
        settings: { brand_name: "Example", mobile_mode: "menu" },
      }),
    /does not define setting mobile_mode/
  );
});

test("administrator persistence uses an immutable request snapshot", async () => {
  let releaseRequest;
  let requestSettings;
  const settings = { bar_background_color: "#111111" };
  const request = (_url, options) => {
    requestSettings = options.data.theme.settings;
    return new Promise((resolve) => {
      releaseRequest = resolve;
    });
  };

  const persistence = persistThemeSettings(42, settings, request);
  settings.bar_background_color = "#222222";

  assert.deepEqual(requestSettings, { bar_background_color: "#111111" });
  releaseRequest();
  assert.deepEqual(await persistence, { bar_background_color: "#111111" });
});

test("bundle snapshots are not replaced by later editor input", () => {
  const bundle = {
    settings: {
      navigation_items: [{ label: "First", url: "/first" }],
    },
  };
  const submittedBundle = snapshotPlainData(bundle);

  bundle.settings.navigation_items[0] = { label: "Second", url: "/second" };

  assert.deepEqual(submittedBundle.settings.navigation_items, [
    { label: "First", url: "/first" },
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
