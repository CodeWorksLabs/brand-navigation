import { click, fillIn, render, waitUntil } from "@ember/test-helpers";
import { module, test } from "qunit";
import { setupRenderingTest } from "discourse/tests/helpers/component-test";
import BrandNavigationBundles from "../../discourse/connectors/admin-customize-theme-before-controls/brand-navigation-bundles";

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

function deferredPersistence() {
  let component;
  let release;
  const pending = new Promise((resolve) => {
    release = resolve;
  });

  BrandNavigationBundles.prototype.persistSettings = async function (settings) {
    component = this;
    await pending;
    return structuredClone(settings);
  };

  return {
    component: () => component,
    release,
  };
}

module(
  "Integration | Brand Navigation | administrator bundles",
  function (hooks) {
    setupRenderingTest(hooks);

    const originalPersistSettings =
      BrandNavigationBundles.prototype.persistSettings;

    hooks.afterEach(function () {
      BrandNavigationBundles.prototype.persistSettings =
        originalPersistSettings;
    });

    test("appearance completion reconciles the submitted snapshot", async function (assert) {
      const theme = adminTheme();
      const persistence = deferredPersistence();
      this.outletArgs = { theme };

      await render(
        <template>
          <BrandNavigationBundles @outletArgs={{this.outletArgs}} />
        </template>
      );

      await click(
        'input[type="checkbox"][data-setting="bar_background_color"]'
      );
      await fillIn(
        'input[type="color"][data-setting="bar_background_color"]',
        "#111111"
      );

      const save = click(
        ".brand-navigation-admin-panel__appearance-controls .btn-primary"
      );
      await waitUntil(() => persistence.component()?.saving);

      assert
        .dom('input[type="color"][data-setting="bar_background_color"]')
        .isDisabled("appearance input is disabled while saving");
      persistence.component().appearanceValues = {
        ...persistence.component().appearanceValues,
        bar_background_color: "#222222",
      };
      persistence.release();
      await save;

      assert
        .dom('input[type="color"][data-setting="bar_background_color"]')
        .hasValue("#111111");
      assert
        .dom(".brand-navigation-admin-panel__appearance-controls .btn-primary")
        .isDisabled("the submitted value is clean after completion");
      assert.strictEqual(
        theme.settings.find((item) => item.setting === "bar_background_color")
          .value,
        "#111111"
      );
      assert.dom(".alert-success").exists();
    });

    test("bundle completion uses its submitted snapshot and preserves unrelated color drafts", async function (assert) {
      const theme = adminTheme();
      const persistence = deferredPersistence();
      this.outletArgs = { theme };
      const submittedText = JSON.stringify({
        format: "brand-navigation-settings",
        version: 1,
        settings: {
          bar_background_color: "#123456",
          navigation_items: [{ label: "Submitted", url: "/submitted" }],
        },
      });

      await render(
        <template>
          <BrandNavigationBundles @outletArgs={{this.outletArgs}} />
        </template>
      );

      await click('input[type="checkbox"][data-setting="bar_text_color"]');
      await fillIn(
        'input[type="color"][data-setting="bar_text_color"]',
        "#abcdef"
      );
      await fillIn(".brand-navigation-bundles textarea", submittedText);

      const importOperation = click(
        ".brand-navigation-bundles__controls .btn-primary"
      );
      await waitUntil(() => persistence.component()?.saving);

      assert.dom(".brand-navigation-bundles textarea").isDisabled();
      assert
        .dom(".brand-navigation-bundles__controls button.btn-default")
        .isDisabled();
      persistence.component().loadBundleText(
        JSON.stringify({
          format: "brand-navigation-settings",
          version: 1,
          settings: {
            bar_background_color: "#654321",
            navigation_items: [{ label: "Later", url: "/later" }],
          },
        })
      );
      persistence.release();
      await importOperation;

      assert
        .dom('input[type="color"][data-setting="bar_background_color"]')
        .hasValue("#123456");
      assert
        .dom('input[type="color"][data-setting="bar_text_color"]')
        .hasValue("#abcdef", "an unrelated color draft is preserved");
      assert
        .dom(".brand-navigation-admin-panel__appearance-controls .btn-primary")
        .isNotDisabled("the unrelated draft remains dirty");
      assert.deepEqual(
        theme.settings.find((item) => item.setting === "navigation_items")
          .value,
        [{ label: "Submitted", url: "/submitted" }]
      );
      assert.deepEqual(
        persistence.component().currentSettings().navigation_items,
        [{ label: "Submitted", url: "/submitted" }]
      );
      assert.dom(".alert-success").exists();
    });
  }
);
