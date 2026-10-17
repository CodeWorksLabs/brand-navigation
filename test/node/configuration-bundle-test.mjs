import assert from "node:assert/strict";
import { spawnSync } from "node:child_process";
import { mkdtemp, rm, writeFile } from "node:fs/promises";
import { tmpdir } from "node:os";
import { join } from "node:path";
import test from "node:test";
import { fileURLToPath } from "node:url";
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
  MAX_THEME_OBJECT_SETTING_BYTES,
  serializeBundle,
  themeSettingValue,
  validateBundle,
} from "../../scripts/brand-navigation-config.mjs";

const cliPath = fileURLToPath(
  new URL("../../scripts/brand-navigation-config.mjs", import.meta.url)
);

const ADDITIONAL_COLOR_SETTINGS = [
  "submenu_hover_text_color",
  "header_text_color",
  "header_text_hover_color",
  "header_hover_background_color",
];
const HEADER_SIZE_SETTINGS = [
  "header_icon_size_desktop",
  "header_icon_size_mobile",
  "header_text_size_desktop",
  "header_text_size_mobile",
];

function invokeCli(args) {
  const result = spawnSync(process.execPath, [cliPath, ...args], {
    encoding: "utf8",
    windowsHide: true,
  });
  assert.ifError(result.error);
  assert.equal(result.signal, null);
  assert.doesNotMatch(
    result.stderr,
    /[\u0000-\u0009\u000b-\u001f\u007f-\u009f]/
  );
  return result;
}

async function validateCliFixture(t, content) {
  const directory = await mkdtemp(join(tmpdir(), "brand-navigation-cli-"));
  t.after(() => rm(directory, { recursive: true, force: true }));
  const file = join(directory, "bundle.json");
  await writeFile(file, content, "utf8");
  return invokeCli(["validate", file]);
}

test("CLI parser diagnostics escape terminal controls from malformed JSON", async (t) => {
  // Keep the entire sequence inside V8's bounded diagnostic excerpt.
  const result = await validateCliFixture(t, "[\u001b]52;c;YQ==\u0007]");

  assert.equal(result.status, 1);
  assert.equal(result.stdout, "");
  assert.match(result.stderr, /\\u001B\]52;c;YQ==\\u0007/);
  assert.equal(result.stderr.split("\n").length, 2);
});

test("CLI malformed-input diagnostics cannot inject C0, DEL, C1 or new lines", async (t) => {
  for (const character of [
    "\u0000",
    "\u0007",
    "\u001b",
    "\u007f",
    "\u009b",
    "\r",
    "\n",
    "\t",
  ]) {
    const result = await validateCliFixture(t, `[${character}x]`);
    assert.equal(result.status, 1);
    assert.equal(result.stdout, "");
    assert.equal(result.stderr.split("\n").length, 2);
  }
});

test("CLI filesystem diagnostics escape controls in untrusted paths", async (t) => {
  const directory = await mkdtemp(join(tmpdir(), "brand-navigation-cli-"));
  t.after(() => rm(directory, { recursive: true, force: true }));
  const result = invokeCli([
    "validate",
    join(directory, "missing-\u001b]52;c;Y2FsYw==\u0007.json"),
  ]);

  assert.equal(result.status, 1);
  assert.equal(result.stdout, "");
  assert.match(result.stderr, /ENOENT|EINVAL/);
  assert.match(result.stderr, /\\u001B\]52;c;Y2FsYw==\\u0007/);
});

test("CLI preserves separate validation lines and inert unknown-field diagnostics", async (t) => {
  const result = await validateCliFixture(
    t,
    JSON.stringify({
      format: BUNDLE_FORMAT,
      version: BUNDLE_VERSION,
      settings: { ["unsafe\u001b[2J\u0007"]: true, enabled: true },
    })
  );

  assert.equal(result.status, 1);
  assert.equal(result.stdout, "");
  assert.equal(
    result.stderr,
    "Unsupported setting: unsafe\\u001B[2J\\u0007.\nUnsupported setting: enabled.\n"
  );
});

test("CLI ordinary parse failures remain readable and fail closed", async (t) => {
  const result = await validateCliFixture(t, "{");

  assert.equal(result.status, 1);
  assert.equal(result.stdout, "");
  assert.match(result.stderr, /JSON|property name/);
  assert.equal(result.stderr.split("\n").length, 2);
});

test("CLI valid bundles retain success output and exit status", async (t) => {
  const result = await validateCliFixture(
    t,
    serializeBundle(createBundle({ brand_name: "Example" }))
  );

  assert.equal(result.status, 0);
  assert.equal(result.stderr, "");
  assert.equal(
    result.stdout,
    `Valid ${BUNDLE_FORMAT} v${BUNDLE_VERSION} bundle\n`
  );
});

test("CLI usage retains trusted multiline formatting and failure status", () => {
  const result = invokeCli([]);

  assert.equal(result.status, 1);
  assert.equal(result.stdout, "");
  assert.equal(result.stderr, "Usage:\n  pnpm bundle validate <bundle.json>\n");
});

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

test("core-header icon colors round trip independently and normalize for import", () => {
  const bundle = createBundle({
    header_icon_color: "a1b2c3",
    header_icon_hover_color: "#d4e5f6",
  });
  const restored = JSON.parse(serializeBundle(bundle));
  assert.deepEqual(validateBundle(restored), []);
  assert.deepEqual(restored.settings, {
    header_icon_color: "#A1B2C3",
    header_icon_hover_color: "#D4E5F6",
  });
  assert.deepEqual(
    prepareThemeSettingsImport(
      {
        settings: [
          { setting: "header_icon_color" },
          { setting: "header_icon_hover_color" },
        ],
      },
      restored
    ),
    restored.settings
  );
  assert.equal(themeSettingValue("header_icon_color", "123abc"), "#123ABC");
  assert.equal(
    themeSettingValue("header_icon_hover_color", "#abcdef"),
    "#ABCDEF"
  );
});

test("core-header colors accept independent inheritance and preserve old bundles", () => {
  for (const settings of [
    { header_icon_color: "", header_icon_hover_color: "#123456" },
    { header_icon_color: "#123456", header_icon_hover_color: "" },
    { header_icon_color: "", header_icon_hover_color: "" },
    { brand_name: "Legacy" },
  ]) {
    const bundle = createBundle(settings);
    assert.deepEqual(validateBundle(bundle), []);
    assert.deepEqual(bundle.settings, settings);
  }
});

test("core-header color validation rejects CSS payloads and non-string values", () => {
  for (const key of ["header_icon_color", "header_icon_hover_color"]) {
    for (const value of [
      "red",
      "#fff",
      "#1234567",
      "#123456; background:url(https://example.com)",
      "var(--primary)",
      123456,
      null,
      true,
      [],
      {},
    ]) {
      assert.deepEqual(
        validateBundle({
          format: BUNDLE_FORMAT,
          version: BUNDLE_VERSION,
          settings: { [key]: value },
        }),
        [`${key} must be blank or a six-digit hex color such as #1A2B3C.`]
      );
    }
  }
});

test("additional appearance colors round trip and normalize independently", () => {
  for (const key of ADDITIONAL_COLOR_SETTINGS) {
    for (const [value, expected] of [
      ["", ""],
      ["a1B2c3", "#A1B2C3"],
      ["#d4E5f6", "#D4E5F6"],
    ]) {
      const bundle = createBundle({ [key]: value });
      const restored = JSON.parse(serializeBundle(bundle));
      assert.equal(restored.version, 1);
      assert.deepEqual(validateBundle(restored), []);
      assert.deepEqual(restored.settings, { [key]: expected });
      assert.equal(themeSettingValue(key, value), expected);
      assert.deepEqual(
        prepareThemeSettingsImport({ settings: [{ setting: key }] }, restored),
        { [key]: expected }
      );
    }
  }
});

test("additional appearance colors reject CSS payloads and non-strings", () => {
  for (const key of ADDITIONAL_COLOR_SETTINGS) {
    for (const value of [
      "red",
      "#fff",
      "#1234567",
      "#123456; background:url(https://example.com)",
      "var(--primary)",
      " #123456",
      "#123456 ",
      123456,
      null,
      undefined,
      true,
      [],
      {},
    ]) {
      const settings = { [key]: value };
      assert.deepEqual(
        validateBundle({
          format: BUNDLE_FORMAT,
          version: BUNDLE_VERSION,
          settings,
        }),
        [`${key} must be blank or a six-digit hex color such as #1A2B3C.`]
      );
      assert.throws(
        () => createBundle(settings),
        /Cannot export invalid settings/
      );
    }
  }
});

test("header sizes round trip every integer from inheritance zero through 48", () => {
  for (let value = 0; value <= 48; value++) {
    const settings = Object.fromEntries(
      HEADER_SIZE_SETTINGS.map((key) => [key, value])
    );
    const bundle = createBundle(settings);
    const restored = JSON.parse(serializeBundle(bundle));
    assert.equal(restored.version, 1);
    assert.deepEqual(validateBundle(restored), []);
    assert.deepEqual(restored.settings, settings);
    assert.deepEqual(
      prepareThemeSettingsImport(
        { settings: HEADER_SIZE_SETTINGS.map((setting) => ({ setting })) },
        restored
      ),
      settings
    );
    for (const key of HEADER_SIZE_SETTINGS) {
      assert.equal(themeSettingValue(key, value), value);
    }
  }
});

test("header size validation rejects out-of-range or non-integer values without coercion", () => {
  for (const key of HEADER_SIZE_SETTINGS) {
    for (const value of [
      -1,
      49,
      0.5,
      47.9,
      NaN,
      Infinity,
      -Infinity,
      "0",
      "48",
      "1.5",
      "",
      null,
      undefined,
      true,
      false,
      [],
      {},
      Object(12),
    ]) {
      const settings = { [key]: value };
      assert.deepEqual(
        validateBundle({
          format: BUNDLE_FORMAT,
          version: BUNDLE_VERSION,
          settings,
        }),
        [`${key} must be an integer from 0 to 48 (0 inherits the theme).`]
      );
      assert.throws(
        () => createBundle(settings),
        /Cannot export invalid settings/
      );
    }
  }
});

test("new appearance fields stay optional and independently preserve defaults", () => {
  const legacy = createBundle({ brand_name: "Legacy" });
  assert.deepEqual(legacy.settings, { brand_name: "Legacy" });
  assert.deepEqual(validateBundle(legacy), []);

  const settings = {
    submenu_hover_text_color: "",
    header_text_color: "#112233",
    header_text_hover_color: "",
    header_hover_background_color: "#445566",
    header_icon_size_desktop: 48,
    header_icon_size_mobile: 0,
    header_text_size_desktop: 0,
    header_text_size_mobile: 16,
  };
  assert.deepEqual(
    JSON.parse(serializeBundle(createBundle(settings))).settings,
    settings
  );
});

test("older components reject unavailable optional appearance fields before import", () => {
  const theme = { settings: [{ setting: "brand_name", value: "Original" }] };
  for (const key of [...ADDITIONAL_COLOR_SETTINGS, ...HEADER_SIZE_SETTINGS]) {
    const bundle = createBundle({
      brand_name: "Changed",
      [key]: HEADER_SIZE_SETTINGS.includes(key) ? 0 : "",
    });
    assert.throws(
      () => prepareThemeSettingsImport(theme, bundle),
      new RegExp(`does not define setting ${key}`)
    );
    assert.deepEqual(theme, {
      settings: [{ setting: "brand_name", value: "Original" }],
    });
  }
  assert.deepEqual(
    prepareThemeSettingsImport(theme, createBundle({ brand_name: "Legacy" })),
    { brand_name: "Legacy" }
  );
});

test("CLI validates additive version-one appearance controls with inheritance zero", async (t) => {
  const settings = Object.fromEntries([
    ...ADDITIONAL_COLOR_SETTINGS.map((key) => [key, "a1b2c3"]),
    ...HEADER_SIZE_SETTINGS.map((key) => [key, 0]),
  ]);
  const result = await validateCliFixture(
    t,
    serializeBundle(createBundle(settings))
  );
  assert.equal(result.status, 0);
  assert.equal(result.stderr, "");
  assert.equal(result.stdout, `Valid ${BUNDLE_FORMAT} v1 bundle\n`);
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
          // eslint-disable-next-line no-script-url -- deliberate unsafe-URL rejection fixture
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

test("validates site-header links and requires icons only for icon-only presentation", () => {
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
    /icon_only site_header presentation requires an icon.*cannot contain children/
  );
});

test("round trips text and combined site-header links without changing legacy icon settings", () => {
  const items = [
    { label: "Legacy", url: "/latest", icon: "house", surface: "site_header" },
    {
      label: "Versions & Status",
      url: "/status",
      surface: "site_header",
      header_presentation: "label_only",
      device_visibility: "desktop",
      visibility: "everyone",
      target: "_blank",
    },
    {
      label: "Help",
      url: "/faq",
      surface: "site_header",
      header_presentation: "icon_and_label",
      icon: "circle-info",
    },
    {
      label: "Text fallback",
      url: "/about",
      surface: "site_header",
      header_presentation: "icon_and_label",
    },
  ];
  const bundle = createBundle({ navigation_items: items });
  assert.deepEqual(validateBundle(bundle), []);
  assert.deepEqual(
    JSON.parse(serializeBundle(bundle)).settings.navigation_items,
    items
  );
});

test("text header links still reject unsafe, missing, grouped, nested, and unknown settings", () => {
  const base = {
    label: "Status",
    url: "/status",
    surface: "site_header",
    header_presentation: "label_only",
  };
  for (const invalid of [
    // eslint-disable-next-line no-script-url -- deliberate unsafe-URL rejection fixture
    { ...base, url: "javascript:alert(1)" },
    { ...base, url: "" },
    { ...base, label: " " },
    { ...base, link_mode: "group" },
    { ...base, children: [{ label: "Child", url: "/faq" }] },
    { ...base, header_presentation: "unknown" },
    {
      label: "Parent",
      children: [
        { label: "Child", url: "/faq", header_presentation: "label_only" },
      ],
    },
  ]) {
    assert.throws(() => createBundle({ navigation_items: [invalid] }));
  }
});

test("header alignment round trips without relocating legacy header links", () => {
  const items = [
    { label: "Legacy", url: "/latest", icon: "house", surface: "site_header" },
    ...["left", "right"].map((header_alignment) => ({
      label: "Versions & Status",
      url: "/status",
      surface: "site_header",
      header_presentation: "label_only",
      header_alignment,
      target: "_blank",
    })),
  ];
  const bundle = createBundle({ navigation_items: items });
  assert.deepEqual(validateBundle(bundle), []);
  assert.deepEqual(
    JSON.parse(serializeBundle(bundle)).settings.navigation_items,
    items
  );
  for (const header_alignment of ["center", false, 1]) {
    assert.throws(
      () =>
        createBundle({ navigation_items: [{ ...items[1], header_alignment }] }),
      /header_alignment/
    );
  }
  assert.throws(
    () =>
      createBundle({
        navigation_items: [{ label: "Parent", children: [items[1]] }],
      }),
    /header_alignment/
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

test("exports cannot create navigation settings larger than Discourse accepts", () => {
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
    /navigation_items cannot exceed 524,288 serialized bytes/i
  );

  const bundle = createBundle({
    navigation_items: [{ label: "Home", url: "/" }],
  });
  assert.ok(
    new TextEncoder().encode(serializeBundle(bundle)).length <= 1_000_000
  );
});

test("preflights Discourse's object-setting byte limit before import", () => {
  const navigationItems = (urlLength) => {
    const url = `/${"x".repeat(urlLength)}`;

    return Array.from({ length: 100 }, (_, index) => ({
      label: `Parent ${index}`,
      url,
      children: [
        { label: "First", url },
        { label: "Second", url },
      ],
    }));
  };

  const belowLimit = navigationItems(1_700);
  const aboveLimit = navigationItems(1_750);

  assert.ok(
    new TextEncoder().encode(JSON.stringify(belowLimit)).length <=
      MAX_THEME_OBJECT_SETTING_BYTES
  );
  assert.deepEqual(
    validateBundle({
      format: BUNDLE_FORMAT,
      version: BUNDLE_VERSION,
      settings: { navigation_items: belowLimit },
    }),
    []
  );
  assert.ok(
    new TextEncoder().encode(JSON.stringify(aboveLimit)).length >
      MAX_THEME_OBJECT_SETTING_BYTES
  );
  assert.deepEqual(
    validateBundle({
      format: BUNDLE_FORMAT,
      version: BUNDLE_VERSION,
      settings: { navigation_items: aboveLimit },
    }),
    ["navigation_items cannot exceed 524,288 serialized bytes."]
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
  // eslint-disable-next-line no-script-url -- deliberate unsafe-URL rejection fixture
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
