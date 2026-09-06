import { module, test } from "qunit";
import {
  arrangeNavigationItems,
  isVisibleToUser,
  linkRel,
} from "brand-navigation/discourse/lib/brand-navigation";
import { isBrandNavigationObjectsEditor } from "brand-navigation/discourse/lib/brand-navigation-admin";

module("Unit | Lib | brand-navigation", function () {
  test("audience visibility is explicit", function (assert) {
    const user = { id: 1 };

    assert.true(isVisibleToUser({ visibility: "everyone" }, null));
    assert.true(isVisibleToUser({ visibility: "anonymous" }, null));
    assert.false(isVisibleToUser({ visibility: "anonymous" }, user));
    assert.false(isVisibleToUser({ visibility: "authenticated" }, null));
    assert.true(isVisibleToUser({ visibility: "authenticated" }, user));
  });

  test("new browsing contexts receive a safe rel", function (assert) {
    assert.strictEqual(linkRel("_blank"), "noopener noreferrer");
    assert.strictEqual(linkRel("_self"), null);
  });

  test("navigation items are grouped into left and right sections", function (assert) {
    const items = arrangeNavigationItems([
      { label: "Account", section: "right" },
      { label: "Community", section: "left" },
      { label: "Help" },
      { label: "Sign Up", section: "right" },
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
      { label: "Community" },
      { label: "Bluesky", surface: "site_header" },
    ]);

    assert.deepEqual(
      items.map((item) => item.label),
      ["Community"]
    );
  });

  test("item presentation supports accessible icon-only links", function (assert) {
    const [iconOnly, missingIcon, labelOnly] = arrangeNavigationItems([
      { label: "Social", icon: "globe", presentation: "icon_only" },
      { label: "Fallback", presentation: "icon_only" },
      { label: "Text", icon: "comments", presentation: "label_only" },
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
          { label: "Docs", description: "Read the documentation" },
          {
            label: "Status",
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

  test("the stay-open save behavior is limited to Brand Navigation", function (assert) {
    assert.true(
      isBrandNavigationObjectsEditor({
        setting: { setting: "navigation_items" },
        schema: { name: "navigation_item" },
      })
    );
    assert.false(
      isBrandNavigationObjectsEditor({
        setting: { setting: "other_items" },
        schema: { name: "navigation_item" },
      })
    );
    assert.false(
      isBrandNavigationObjectsEditor({
        setting: { setting: "navigation_items" },
        schema: { name: "other_item" },
      })
    );
  });
});
