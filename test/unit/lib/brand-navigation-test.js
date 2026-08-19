import { module, test } from "qunit";
import {
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
});
