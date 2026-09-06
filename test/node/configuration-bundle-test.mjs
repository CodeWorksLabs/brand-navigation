import assert from "node:assert/strict";
import { mkdtemp, readFile, rmdir, unlink, writeFile } from "node:fs/promises";
import { tmpdir } from "node:os";
import { join } from "node:path";
import test from "node:test";

import {
  isBrandNavigationTheme,
  prepareThemeSettingsImport,
} from "../../javascripts/discourse/lib/brand-navigation-admin.js";
import {
  isSafeNavigationUrl,
  readBundleFile,
} from "../../javascripts/discourse/lib/configuration-bundle.js";

import {
  BUNDLE_FORMAT,
  BUNDLE_VERSION,
  apiOptions,
  createBundle,
  fetchApi,
  normalizeSettingValue,
  parseArguments,
  readBoundedText,
  sanitizeRemoteText,
  themeSettingValue,
  validateBundle,
  writeExportFile,
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
    "navigation_items[0] requires a URL or at least one child.",
    "Unknown field: navigation_items[1].children[0].children.",
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

test("requires a canonical HTTPS API origin and positive theme id", () => {
  const environment = {
    DISCOURSE_API_KEY: "secret",
    DISCOURSE_API_USERNAME: "admin",
  };

  assert.throws(
    () =>
      apiOptions(
        { "--url": "http://forum.example.com", "--theme-id": "1" },
        environment
      ),
    /HTTPS origin/
  );
  assert.throws(
    () =>
      apiOptions(
        { "--url": "https://forum.example.com/path", "--theme-id": "1" },
        environment
      ),
    /HTTPS origin/
  );
  assert.throws(
    () =>
      apiOptions(
        { "--url": "https://forum.example.com", "--theme-id": "nope" },
        environment
      ),
    /positive integer/
  );

  assert.deepEqual(
    apiOptions(
      { "--url": "https://forum.example.com/", "--theme-id": "19" },
      environment
    ),
    {
      baseUrl: "https://forum.example.com",
      themeId: "19",
      apiKey: "secret",
      apiUsername: "admin",
    }
  );
});

test("URL and administrator component identities fail closed", () => {
  assert.equal(isSafeNavigationUrl("/latest"), true);
  assert.equal(isSafeNavigationUrl("/\\attacker.example/path"), false);
  assert.equal(isSafeNavigationUrl("//attacker.example/path"), false);
  assert.equal(isSafeNavigationUrl("http://example.com"), false);
  assert.equal(isSafeNavigationUrl("javascript:alert(1)"), false);

  assert.equal(
    isBrandNavigationTheme({
      component: true,
      remote_theme: {
        remote_url: "https://github.com/CodeWorksLabs/brand-navigation.git",
      },
    }),
    true
  );
  assert.equal(
    isBrandNavigationTheme({
      component: false,
      remote_theme: {
        remote_url: "https://github.com/CodeWorksLabs/brand-navigation.git",
      },
    }),
    false
  );
  assert.equal(isBrandNavigationTheme({ name: "Brand Navigation" }), false);
  assert.equal(
    isBrandNavigationTheme({
      component: true,
      remote_theme: {
        remote_url: "https://github.com:444/CodeWorksLabs/brand-navigation.git",
      },
    }),
    false
  );
});

test("bundle import preflights every target setting before mutation", () => {
  const theme = {
    settings: [
      { setting: "brand_name" },
      { setting: "custom_font_awesome_icons" },
    ],
  };

  assert.deepEqual(
    prepareThemeSettingsImport(theme, {
      settings: {
        brand_name: "Example",
        custom_font_awesome_icons: ["house", "comments"],
      },
    }),
    {
      brand_name: "Example",
      custom_font_awesome_icons: "house|comments",
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

test("API requests reject redirects and bound response work", async () => {
  const api = {
    baseUrl: "https://forum.example.com",
    themeId: "19",
    apiKey: "secret",
    apiUsername: "admin",
  };
  let request;

  await fetchApi(api, "/admin/themes/19.json", {
    fetchImpl: async (url, options) => {
      request = { url, options };
      return new Response("{}");
    },
  });

  assert.equal(request.url, "https://forum.example.com/admin/themes/19.json");
  assert.equal(request.options.redirect, "error");
  assert.equal(request.options.headers["Api-Key"], "secret");

  let redirectRequests = 0;
  await assert.rejects(
    fetchApi(api, "/admin/themes/19.json", {
      fetchImpl: async () => {
        redirectRequests += 1;
        return new Response("redirect", {
          status: 302,
          headers: { location: "https://attacker.example/" },
        });
      },
    }),
    /Discourse request failed: 302/
  );
  assert.equal(redirectRequests, 1);

  await assert.rejects(
    readBoundedText(new Response("12345"), 4),
    /exceeds 4 bytes/
  );
});

test("CLI parsing and remote errors are fail closed", () => {
  assert.deepEqual(
    parseArguments([
      "export",
      "settings.json",
      "--url",
      "https://forum.example.com",
      "--theme-id",
      "1",
      "--overwrite",
    ]).options,
    {
      "--url": "https://forum.example.com",
      "--theme-id": "1",
      "--overwrite": true,
    }
  );
  assert.equal(
    sanitizeRemoteText("bad\u001b[31m\nresponse"),
    "bad [31m response"
  );
});

test("CLI response timeout and explicit export overwrite are enforced", async () => {
  const api = {
    baseUrl: "https://forum.example.com",
    themeId: "19",
    apiKey: "secret",
    apiUsername: "admin",
  };

  await assert.rejects(
    fetchApi(api, "/admin/themes/19.json", {
      timeoutMs: 5,
      fetchImpl: async (_url, { signal }) =>
        await new Promise((_resolve, reject) => {
          if (signal.aborted) {
            reject(signal.reason);
            return;
          }

          const guard = setTimeout(
            () => reject(new Error("request did not abort")),
            100
          );
          signal.addEventListener(
            "abort",
            () => {
              clearTimeout(guard);
              reject(signal.reason);
            },
            { once: true }
          );
        }),
    }),
    /timed out|aborted/i
  );

  const directory = await mkdtemp(join(tmpdir(), "brand-navigation-test-"));
  const file = join(directory, "settings.json");

  try {
    await writeFile(file, "original", "utf8");
    await assert.rejects(writeExportFile(file, "replacement"), {
      code: "EEXIST",
    });
    assert.equal(await readFile(file, "utf8"), "original");
    await writeExportFile(file, "replacement", true);
    assert.equal(await readFile(file, "utf8"), "replacement");
  } finally {
    await unlink(file);
    await rmdir(directory);
  }
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
