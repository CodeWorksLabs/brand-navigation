import { module, test } from "qunit";
import {
  arrangeNavigationItems,
  isVisibleToUser,
  linkRel,
} from "brand-navigation/discourse/lib/brand-navigation";

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
});
