import { module, test } from "qunit";
import {
  arrangeNavigationItems,
  hasSpriteSymbol,
  isUsableIcon,
  isPrimarySpriteReady,
  isVisibleOnDevice,
  isVisibleToUser,
  linkRel,
  linkTarget,
  PrimarySpriteWatcher,
  shouldRenderHeaderIcon,
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
    const existingIcons = new Set(["globe", "comments"]);
    const iconExists = (icon) => existingIcons.has(icon);
    const [iconOnly, missingIcon, unavailableIcon, labelOnly] =
      arrangeNavigationItems(
        [
          {
            label: "Social",
            url: "/social",
            icon: "globe",
            presentation: "icon_only",
          },
          { label: "Fallback", url: "/fallback", presentation: "icon_only" },
          {
            label: "Unavailable",
            url: "/unavailable",
            icon: "not-in-the-sprite",
            presentation: "icon_only",
          },
          {
            label: "Text",
            url: "/text",
            icon: "comments",
            presentation: "label_only",
          },
        ],
        iconExists
      );

    assert.true(iconOnly.showIcon);
    assert.false(iconOnly.showLabel);
    assert.false(missingIcon.showIcon);
    assert.true(
      missingIcon.showLabel,
      "a missing icon safely falls back to its label"
    );
    assert.false(unavailableIcon.showIcon);
    assert.true(
      unavailableIcon.showLabel,
      "an unavailable icon safely falls back to its label"
    );
    assert.false(labelOnly.showIcon);
    assert.true(labelOnly.showLabel);
  });

  test("icon availability follows Discourse replacements", function (assert) {
    assert.true(isUsableIcon("d-tracking", (icon) => icon === "bell"));
    assert.false(isUsableIcon("not-in-the-sprite", () => false));
    assert.false(isUsableIcon("", () => true));
  });

  test("primary sprite readiness notifies once after delayed symbol loading", async function (assert) {
    const documentObject = document.implementation.createHTMLDocument();
    const watcher = new PrimarySpriteWatcher(documentObject, MutationObserver);
    let notifications = 0;

    watcher.subscribe(() => notifications++);
    watcher.subscribe(() => notifications++);
    assert.strictEqual(notifications, 0, "an empty sprite remains unresolved");

    const container = documentObject.createElement("div");
    container.id = "svg-sprites";
    const sprites = documentObject.createElement("div");
    sprites.className = "fontawesome";
    container.appendChild(sprites);
    documentObject.body.appendChild(container);

    await new Promise((resolve) => setTimeout(resolve));
    assert.strictEqual(
      notifications,
      0,
      "an empty primary sprite remains unresolved"
    );

    sprites.innerHTML = '<svg><symbol id="globe"></symbol></svg>';
    await new Promise((resolve) => setTimeout(resolve));

    assert.strictEqual(notifications, 2);
    assert.strictEqual(watcher.callbacks.size, 0);
    assert.strictEqual(watcher.observer, null);
    assert.true(isPrimarySpriteReady(documentObject));
    assert.true(hasSpriteSymbol("globe", documentObject));
    assert.false(hasSpriteSymbol("missing", documentObject));
  });

  test("primary sprite subscriptions are canceled before completion", function (assert) {
    const documentObject = document.implementation.createHTMLDocument();
    const watcher = new PrimarySpriteWatcher(documentObject, MutationObserver);
    let notifications = 0;

    const unsubscribe = watcher.subscribe(() => notifications++);
    assert.strictEqual(watcher.callbacks.size, 1);
    assert.ok(watcher.observer, "one shared observer services subscribers");

    unsubscribe();

    assert.strictEqual(notifications, 0);
    assert.strictEqual(watcher.callbacks.size, 0);
    assert.strictEqual(watcher.observer, null);
  });

  test("the default icon path inspects the loaded primary SVG sprite", function (assert) {
    const existingContainer = document.getElementById("svg-sprites");
    const container = existingContainer || document.createElement("div");
    const existingPrimarySprite = container.querySelector(".fontawesome");
    const primarySprite =
      existingPrimarySprite || document.createElement("div");
    const symbols = document.createElementNS(
      "http://www.w3.org/2000/svg",
      "svg"
    );

    if (!existingContainer) {
      container.id = "svg-sprites";
      document.body.appendChild(container);
    }
    if (!existingPrimarySprite) {
      primarySprite.className = "fontawesome";
      container.appendChild(primarySprite);
    }

    symbols.innerHTML = `
      <symbol id="brand-navigation-test-icon"></symbol>
      <symbol id="bell"></symbol>
    `;
    primarySprite.appendChild(symbols);

    try {
      assert.true(isUsableIcon("brand-navigation-test-icon"));
      assert.true(isUsableIcon("d-tracking"), "replacement symbols resolve");
      assert.false(isUsableIcon("brand-navigation-test-missing"));

      const [topLevel, parent] = arrangeNavigationItems([
        {
          label: "Top",
          url: "/top",
          icon: "brand-navigation-test-icon",
          presentation: "icon_only",
        },
        {
          label: "Parent",
          children: [
            {
              label: "Child",
              url: "/child",
              icon: "d-tracking",
              presentation: "icon_only",
            },
          ],
        },
      ]);

      assert.true(topLevel.showIcon);
      assert.false(topLevel.showLabel);
      assert.true(parent.children[0].showIcon);
      assert.false(parent.children[0].showLabel);
      assert.true(
        shouldRenderHeaderIcon({
          item: {
            label: "Header",
            url: "/header",
            icon: "brand-navigation-test-icon",
            visibility: "everyone",
          },
          embedMode: false,
          mobileView: false,
          mobileMode: "bar",
          currentUser: null,
          mobileDevice: false,
        })
      );
      assert.false(
        shouldRenderHeaderIcon({
          item: {
            label: "Missing header",
            url: "/missing",
            icon: "brand-navigation-test-missing",
            visibility: "everyone",
          },
          embedMode: false,
          mobileView: false,
          mobileMode: "bar",
          currentUser: null,
          mobileDevice: false,
        }),
        "a symbol absent from the production sprite omits the header target"
      );
    } finally {
      symbols.remove();
      if (!existingPrimarySprite) {
        primarySprite.remove();
      }
      if (!existingContainer) {
        container.remove();
      }
    }
  });

  test("site-header icon policy fails closed in unsupported contexts", function (assert) {
    const item = {
      label: "Social",
      url: "https://example.com/social",
      icon: "user",
      visibility: "everyone",
    };
    const base = {
      item,
      embedMode: false,
      mobileView: false,
      mobileMode: "bar",
      currentUser: null,
      mobileDevice: false,
      iconExists: (icon) => icon === "user",
    };

    assert.true(shouldRenderHeaderIcon(base), "an available icon renders");
    assert.false(
      shouldRenderHeaderIcon({ ...base, iconExists: () => false }),
      "an unavailable icon is omitted"
    );
    assert.false(
      shouldRenderHeaderIcon({
        ...base,
        mobileView: true,
        mobileMode: "hidden",
        mobileDevice: true,
      }),
      "hidden mobile mode omits the icon"
    );
    assert.false(
      shouldRenderHeaderIcon({ ...base, embedMode: true }),
      "embed mode omits the icon"
    );
  });

  test("unavailable submenu icons fall back to child labels", function (assert) {
    const [item] = arrangeNavigationItems(
      [
        {
          label: "Resources",
          children: [
            {
              label: "Docs",
              url: "/docs",
              icon: "not-in-the-sprite",
              presentation: "icon_only",
            },
          ],
        },
      ],
      () => false
    );

    assert.false(item.children[0].showIcon);
    assert.true(item.children[0].showLabel);
  });

  test("visible submenu descriptions follow label presentation", function (assert) {
    const [item] = arrangeNavigationItems(
      [
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
      ],
      (icon) => icon === "signal"
    );

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
