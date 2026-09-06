import { module, test } from "qunit";
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

module("Unit | Lib | brand-navigation", function () {
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

  test("administrator controls require the exact canonical repository", function (assert) {
    assert.true(
      isBrandNavigationTheme({
        component: true,
        remote_theme: {
          remote_url: "https://github.com/CodeWorksLabs/brand-navigation.git",
        },
      })
    );
    assert.false(isBrandNavigationTheme({ name: "Brand Navigation" }));
    assert.false(
      isBrandNavigationTheme({
        component: true,
        remote_theme: {
          remote_url:
            "https://github.com/example/CodeWorksLabs/brand-navigation-lookalike",
        },
      })
    );
    assert.false(
      isBrandNavigationTheme({
        component: true,
        remote_theme: {
          remote_url:
            "https://github.com:444/CodeWorksLabs/brand-navigation.git",
        },
      })
    );
  });
});
