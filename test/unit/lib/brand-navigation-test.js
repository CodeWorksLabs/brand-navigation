import { module, test } from "qunit";
import BrandNavigationBundles from "../../../discourse/connectors/admin-customize-theme-before-controls/brand-navigation-bundles";
import {
  arrangeNavigationItems,
  isVisibleOnDevice,
  isVisibleToUser,
  linkRel,
  linkTarget,
} from "../../../discourse/lib/brand-navigation";
import { isBrandNavigationObjectsEditor } from "../../../discourse/lib/brand-navigation-admin";
import { isBrandNavigationTheme } from "../../../discourse/lib/brand-navigation-admin";
import { isSafeNavigationUrl } from "../../../discourse/lib/configuration-bundle";

function setting(name, value = "") {
  return {
    setting: name,
    value,
    set(property, nextValue) {
      this[property] = nextValue;
    },
  };
}

function adminTheme() {
  return {
    id: 42,
    component: true,
    settings: [
      setting("brand_presentation", "name"),
      setting("custom_font_awesome_icons", ""),
      setting("mobile_mode", "bar"),
      setting("navigation_items", "[]"),
      setting("bar_background_color"),
      setting("bar_text_color"),
      setting("hover_background_color"),
      setting("submenu_background_color"),
      setting("submenu_text_color"),
    ],
  };
}

function deferred() {
  let resolve;
  const promise = new Promise((resolver) => {
    resolve = resolver;
  });
  return { promise, resolve };
}

module("Unit | Lib | brand-navigation", function () {
  test("appearance completion reconciles the submitted snapshot", async function (assert) {
    const theme = adminTheme();
    const component = new BrandNavigationBundles(undefined, {
      outletArgs: { theme },
    });
    const request = deferred();

    component.persistSettings = async (submittedSettings) => {
      await request.promise;
      return structuredClone(submittedSettings);
    };
    component.appearanceValues = {
      ...component.appearanceValues,
      bar_background_color: "#111111",
    };

    const save = component.saveAppearance();
    assert.true(component.saving, "the component enters its in-flight state");

    component.appearanceValues = {
      ...component.appearanceValues,
      bar_background_color: "#222222",
    };
    request.resolve();
    await save;

    assert.false(component.saving);
    assert.strictEqual(
      component.appearanceValues.bar_background_color,
      "#111111"
    );
    assert.strictEqual(
      theme.settings.find((item) => item.setting === "bar_background_color")
        .value,
      "#111111"
    );
    assert.false(component.appearanceDirty);
    assert.ok(component.success);
  });

  test("bundle completion uses its submitted snapshot and preserves unrelated color drafts", async function (assert) {
    const theme = adminTheme();
    const component = new BrandNavigationBundles(undefined, {
      outletArgs: { theme },
    });
    const request = deferred();
    const submittedText = JSON.stringify({
      format: "brand-navigation-settings",
      version: 1,
      settings: {
        bar_background_color: "#123456",
        navigation_items: [{ label: "Submitted", url: "/submitted" }],
      },
    });

    component.persistSettings = async (submittedSettings) => {
      await request.promise;
      return structuredClone(submittedSettings);
    };
    component.appearanceValues = {
      ...component.appearanceValues,
      bar_text_color: "#ABCDEF",
    };
    component.loadBundleText(submittedText, "submitted.json");

    const importOperation = component.importBundle();
    assert.true(component.saving, "the component enters its in-flight state");
    assert.true(component.importDisabled);

    component.loadBundleText(
      JSON.stringify({
        format: "brand-navigation-settings",
        version: 1,
        settings: {
          bar_background_color: "#654321",
          navigation_items: [{ label: "Later", url: "/later" }],
        },
      })
    );
    request.resolve();
    await importOperation;

    assert.false(component.saving);
    assert.strictEqual(
      component.appearanceValues.bar_background_color,
      "#123456"
    );
    assert.strictEqual(
      component.appearanceValues.bar_text_color,
      "#ABCDEF",
      "a color not present in the bundle keeps its existing draft"
    );
    assert.deepEqual(
      theme.settings.find((item) => item.setting === "navigation_items").value,
      [{ label: "Submitted", url: "/submitted" }]
    );
    assert.deepEqual(component.currentSettings().navigation_items, [
      { label: "Submitted", url: "/submitted" },
    ]);
    assert.ok(component.success);
  });

  test("audience visibility is explicit", function (assert) {
    const user = { id: 1 };

    assert.true(isVisibleToUser({ visibility: "everyone" }, null));
    assert.true(isVisibleToUser({ visibility: "anonymous" }, null));
    assert.false(isVisibleToUser({ visibility: "anonymous" }, user));
    assert.false(isVisibleToUser({ visibility: "authenticated" }, null));
    assert.true(isVisibleToUser({ visibility: "authenticated" }, user));
  });

  test("device visibility is explicit and backward compatible", function (assert) {
    assert.true(isVisibleOnDevice({}, false));
    assert.true(isVisibleOnDevice({}, true));
    assert.true(isVisibleOnDevice({ device_visibility: "both" }, false));
    assert.true(isVisibleOnDevice({ device_visibility: "both" }, true));
    assert.true(isVisibleOnDevice({ device_visibility: "desktop" }, false));
    assert.false(isVisibleOnDevice({ device_visibility: "desktop" }, true));
    assert.false(isVisibleOnDevice({ device_visibility: "mobile" }, false));
    assert.true(isVisibleOnDevice({ device_visibility: "mobile" }, true));
  });

  test("new browsing contexts receive a safe rel", function (assert) {
    assert.strictEqual(linkRel("_blank"), "noopener noreferrer");
    assert.strictEqual(linkRel("_self"), null);
    assert.strictEqual(linkTarget("_blank"), "_blank");
    assert.strictEqual(linkTarget("unexpected"), "_self");
  });

  test("navigation URLs fail closed", function (assert) {
    assert.true(isSafeNavigationUrl("/latest"));
    assert.true(isSafeNavigationUrl("https://example.com/path"));
    assert.false(isSafeNavigationUrl("//example.com/path"));
    assert.false(isSafeNavigationUrl("http://example.com/path"));
    assert.false(isSafeNavigationUrl("javascript:alert(1)"));
  });

  test("navigation items are grouped into left and right sections", function (assert) {
    const items = arrangeNavigationItems([
      { label: "Account", url: "/u/me", section: "right" },
      { label: "Community", url: "/categories", section: "left" },
      { label: "Help", url: "/faq" },
      { label: "Sign Up", url: "/signup", section: "right" },
    ]);

    assert.deepEqual(
      items.map((item) => item.label),
      ["Community", "Help", "Account", "Sign Up"]
    );
    assert.true(
      items[2].itemClass.includes("brand-navigation__item--right-start")
    );
    assert.false(
      items[3].itemClass.includes("brand-navigation__item--right-start")
    );
  });

  test("site-header items are excluded from the brand bar", function (assert) {
    const items = arrangeNavigationItems([
      { label: "Community", url: "/categories" },
      {
        label: "Bluesky",
        url: "https://bsky.app/",
        icon: "bluesky",
        surface: "site_header",
      },
    ]);

    assert.deepEqual(
      items.map((item) => item.label),
      ["Community"]
    );
  });

  test("item presentation supports accessible icon-only links", function (assert) {
    const [iconOnly, missingIcon, labelOnly] = arrangeNavigationItems([
      {
        label: "Social",
        url: "/social",
        icon: "globe",
        presentation: "icon_only",
      },
      { label: "Fallback", url: "/fallback", presentation: "icon_only" },
      {
        label: "Text",
        url: "/text",
        icon: "comments",
        presentation: "label_only",
      },
    ]);

    assert.true(iconOnly.showIcon);
    assert.false(iconOnly.showLabel);
    assert.false(missingIcon.showIcon);
    assert.true(
      missingIcon.showLabel,
      "a missing icon safely falls back to its label"
    );
    assert.false(labelOnly.showIcon);
    assert.true(labelOnly.showLabel);
  });

  test("visible submenu descriptions follow label presentation", function (assert) {
    const [item] = arrangeNavigationItems([
      {
        label: "Resources",
        children: [
          {
            label: "Docs",
            url: "/docs",
            description: "Read the documentation",
          },
          {
            label: "Status",
            url: "/status",
            icon: "signal",
            presentation: "icon_only",
            description: "Service status",
          },
        ],
      },
    ]);

    assert.true(item.children[0].showDescription);
    assert.false(item.children[1].showDescription);
    assert.true(item.hasVisibleDescriptions);
  });

  test("submenu parents can render as groups without losing their saved URL", function (assert) {
    const [group, linked] = arrangeNavigationItems([
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
    ]);

    assert.strictEqual(group.url, null);
    assert.strictEqual(group.linkMode, "group");
    assert.strictEqual(linked.url, "/categories");
    assert.strictEqual(linked.linkMode, "link");
  });

  test("inert and unsafe navigation rows are removed", function (assert) {
    const items = arrangeNavigationItems([
      { label: "Inert" },
      { label: "Unsafe", url: "javascript:alert(1)" },
      { label: "Safe", url: "/safe" },
    ]);

    assert.deepEqual(
      items.map((item) => item.label),
      ["Safe"]
    );
  });

  test("the stay-open save behavior is limited to Brand Navigation", function (assert) {
    assert.true(
      isBrandNavigationObjectsEditor({
        setting: { setting: "navigation_items" },
        schema: { name: "brand_navigation_item_v1" },
      })
    );
    assert.false(
      isBrandNavigationObjectsEditor({
        setting: { setting: "other_items" },
        schema: { name: "brand_navigation_item_v1" },
      })
    );
    assert.false(
      isBrandNavigationObjectsEditor({
        setting: { setting: "navigation_items" },
        schema: { name: "other_item" },
      })
    );
  });

  test("administrator controls follow the component across supported repository locations", function (assert) {
    const settings = [
      "brand_presentation",
      "custom_font_awesome_icons",
      "mobile_mode",
      "navigation_items",
      "submenu_text_color",
    ].map((setting) => ({ setting }));

    assert.true(
      isBrandNavigationTheme({
        component: true,
        settings,
        remote_theme: {
          remote_url: "https://github.com/CodeWorksLabs/brand-navigation.git",
        },
      })
    );

    assert.true(
      isBrandNavigationTheme({
        component: true,
        settings,
      })
    );

    assert.false(
      isBrandNavigationTheme({
        component: true,
        settings: settings.slice(0, -1),
      })
    );
    assert.false(isBrandNavigationTheme({ name: "Brand Navigation" }));
  });
});
