import { trackedArray, trackedObject } from "@ember/reactive/collections";
import {
  clearRender,
  click,
  fillIn,
  find,
  render,
  settled,
  triggerEvent,
  waitUntil,
} from "@ember/test-helpers";
import { module, test } from "qunit";
import { setupRenderingTest } from "discourse/tests/helpers/component-test";
import BrandNavigationBundles from "../../discourse/connectors/admin-customize-theme-before-controls/brand-navigation-bundles";
import brandNavigationAdmin from "../../discourse/initializers/brand-navigation-admin";
import { snapshotPlainData } from "../../discourse/lib/brand-navigation-admin";
import { validateNavigationItems } from "../../discourse/lib/configuration-bundle";

function setting(name, value = "") {
  return {
    setting: name,
    value,
    set(property, nextValue) {
      this[property] = nextValue;
    },
  };
}

const ADDITIONAL_COLORS = [
  "submenu_hover_text_color",
  "header_text_color",
  "header_text_hover_color",
  "header_hover_background_color",
];
const HEADER_SIZES = [
  "header_icon_size_desktop",
  "header_icon_size_mobile",
  "header_text_size_desktop",
  "header_text_size_mobile",
];

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
      setting("header_icon_color"),
      setting("header_icon_hover_color"),
      ...ADDITIONAL_COLORS.map((name) => setting(name)),
      ...HEADER_SIZES.map((name) => setting(name, 0)),
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

async function nativeObjectsEditor(owner, data, updateSetting, options = {}) {
  if (options.nativeClass) {
    // Exercise the actual API/classPrepend registration and original native
    // class. A constructor in the modifyClass callback must not make this pass.
    brandNavigationAdmin.initialize(owner);
  }

  const navigationSetting = setting(
    options.settingName || "navigation_items",
    options.initialValue || []
  );
  navigationSetting.updateSetting = updateSetting;
  const Editor = owner.factoryFor("component:schema-setting/editor").class;
  const schema = options.schema || {
    name: "brand_navigation_item_v1",
    properties: {},
  };
  let editor;

  class CapturedEditor extends Editor {
    constructor() {
      super(...arguments);
      if (data !== undefined) {
        this.data = data;
      }
      editor = this;
    }
  }

  const RenderedEditor = options.nativeClass ? Editor : CapturedEditor;

  await render(
    <template>
      <RenderedEditor
        @id={{42}}
        @setting={{navigationSetting}}
        @schema={{schema}}
      />
    </template>
  );
  return { editor, navigationSetting };
}

function navigationEditorSchema() {
  return {
    name: "brand_navigation_item_v1",
    identifier: "label",
    properties: {
      label: { type: "string", required: true },
      url: { type: "string" },
      children: {
        type: "objects",
        schema: {
          name: "brand_navigation_child_v1",
          identifier: "label",
          properties: {
            label: { type: "string", required: true },
            url: { type: "string", required: true },
          },
        },
      },
    },
  };
}

function trackedNavigationItems(presentation) {
  return trackedArray([
    trackedObject({
      label: "Resources",
      children: trackedArray([
        trackedObject({ label: "Documentation", url: "/faq" }),
      ]),
    }),
    trackedObject({
      label: "Versions & Status",
      url: "/latest",
      surface: "site_header",
      header_presentation: presentation,
      icon: "circle-info",
    }),
  ]);
}

module(
  "Integration | Brand Navigation | administrator bundles",
  function (hooks) {
    setupRenderingTest(hooks);

    const originalPersistSettings =
      BrandNavigationBundles.prototype.persistSettings;
    const originalReadBundle = BrandNavigationBundles.prototype.readBundle;

    hooks.afterEach(function () {
      BrandNavigationBundles.prototype.persistSettings =
        originalPersistSettings;
      BrandNavigationBundles.prototype.readBundle = originalReadBundle;
    });

    test("native editor adds valid menu and submenu items with friendly view-only names", async function (assert) {
      const schema = navigationEditorSchema();
      const originalSchema = snapshotPlainData(schema);
      const initialValue = [
        {
          label: "Resources",
          children: [{ label: "Documentation", url: "/faq" }],
        },
      ];
      const originalValue = snapshotPlainData(initialValue);
      let submitted;
      const { navigationSetting } = await nativeObjectsEditor(
        this.owner,
        undefined,
        async (_id, value) => {
          submitted = value;
          return { navigation_items: value };
        },
        { schema, initialValue, nativeClass: true }
      );

      assert
        .dom(".schema-setting-editor__tree-add-button.--root")
        .hasText("Menu item");
      assert
        .dom(".schema-setting-editor__tree-add-button.--child")
        .hasText("Submenu item");
      assert.deepEqual(schema, originalSchema);
      assert.deepEqual(navigationSetting.value, originalValue);
      assert
        .dom(".brand-navigation-ordering-hint")
        .hasText(
          "Use ↑ and ↓ to change the display order. Items in the same area appear in the order listed."
        );
      assert
        .dom(".schema-setting-editor__move-up-btn")
        .hasAttribute("title", "Move up")
        .hasAttribute("aria-label", "Move up");
      assert
        .dom(".schema-setting-editor__move-down-btn")
        .hasAttribute("title", "Move down")
        .hasAttribute("aria-label", "Move down");

      await click(".schema-setting-editor__tree-add-button.--root");
      assert
        .dom(".schema-setting-editor__tree-node.--parent.--active")
        .includesText("Menu item 2", "unnamed root titles are friendly");
      await click(
        '.schema-setting-editor__tree-add-button.--child[data-test-parent-index="1"]'
      );
      assert
        .dom(".schema-setting-editor__tree-node.--back-btn")
        .includesText(
          "Menu item 2",
          "back navigation uses a friendly root title"
        );
      assert
        .dom(".schema-setting-editor__tree-add-button.--root")
        .hasText("Submenu item", "the resolved child schema is projected");
      assert.dom(".brand-navigation-ordering-hint").exists({ count: 1 });
      assert
        .dom(".schema-setting-editor__move-up-btn")
        .hasAttribute("title", "Move up");
      assert
        .dom(".schema-setting-editor__move-down-btn")
        .hasAttribute("title", "Move down");
      assert
        .dom(".schema-setting-editor__tree-node.--parent.--active")
        .includesText("Submenu item 1", "unnamed child titles are friendly");
      await fillIn('.schema-field[data-name="label"] input', "Help");
      await fillIn('.schema-field[data-name="url"] input', "/about");
      await click(".schema-setting-editor__tree-node.--back-btn");
      assert
        .dom(".schema-setting-editor__tree-add-button.--root")
        .hasText("Menu item", "back navigation restores the root schema");
      await fillIn('.schema-field[data-name="label"] input', "Community");
      await fillIn('.schema-field[data-name="url"] input', "/latest");
      assert.deepEqual(
        navigationSetting.value,
        originalValue,
        "adding draft items does not mutate the saved setting"
      );
      await click(".schema-setting-editor__footer .btn-primary");
      assert.deepEqual(
        validateNavigationItems(submitted),
        [],
        "the new root and nested items satisfy the unchanged validator"
      );
      assert.deepEqual(submitted, [
        originalValue[0],
        {
          label: "Community",
          url: "/latest",
          children: [{ label: "Help", url: "/about" }],
        },
      ]);
      assert.deepEqual(navigationSetting.value, submitted);
      assert.deepEqual(initialValue, originalValue);
      assert.deepEqual(schema, originalSchema);
      assert.dom(".schema-setting-editor__errors").doesNotExist();
    });

    test("native ordering arrows keep their draft and save behavior with ordering help", async function (assert) {
      const initialValue = [
        { label: "Versions & Status", url: "/latest" },
        { label: "GitHub", url: "https://github.com/CodeWorksLabs" },
      ];
      let submitted;
      const { navigationSetting } = await nativeObjectsEditor(
        this.owner,
        undefined,
        async (_id, value) => {
          submitted = value;
          return { navigation_items: value };
        },
        { schema: navigationEditorSchema(), initialValue, nativeClass: true }
      );

      assert.dom(".schema-setting-editor__move-up-btn").isDisabled();
      assert.dom(".schema-setting-editor__move-down-btn").isNotDisabled();
      await click(".schema-setting-editor__move-down-btn");
      assert.dom(".brand-navigation-ordering-hint").exists({ count: 1 });
      assert
        .dom(".schema-setting-editor__move-up-btn")
        .hasAttribute("title", "Move up")
        .isNotDisabled();
      assert.dom(".schema-setting-editor__move-down-btn").isDisabled();
      assert.deepEqual(navigationSetting.value, initialValue, "draft only");
      await click(".schema-setting-editor__footer .btn-primary");
      assert.deepEqual(submitted, [initialValue[1], initialValue[0]]);
      await click(".schema-setting-editor__move-up-btn");
      await click(".schema-setting-editor__footer .btn-primary");
      assert.deepEqual(submitted, initialValue, "moving back restores order");
      await clearRender();
      assert.dom(".brand-navigation-ordering-hint").doesNotExist();
    });

    for (const unrelated of ["setting", "schema"]) {
      test(`native editor leaves an unrelated ${unrelated} unchanged`, async function (assert) {
        const schema = navigationEditorSchema();
        if (unrelated === "schema") {
          schema.name = "unrelated_item_v1";
        }
        const originalSchema = snapshotPlainData(schema);
        const initialValue = [{ label: "Existing", url: "/latest" }];
        const originalValue = snapshotPlainData(initialValue);
        const { navigationSetting } = await nativeObjectsEditor(
          this.owner,
          undefined,
          async () => assert.step("unexpected save"),
          {
            schema,
            initialValue,
            nativeClass: true,
            settingName:
              unrelated === "setting" ? "unrelated_items" : "navigation_items",
          }
        );

        assert
          .dom(".schema-setting-editor__tree-add-button.--root")
          .hasText(originalSchema.name);
        assert
          .dom(".schema-setting-editor__tree-add-button.--child")
          .hasText("brand_navigation_child_v1");
        assert.deepEqual(schema, originalSchema);
        assert.deepEqual(navigationSetting.value, originalValue);
        assert.deepEqual(initialValue, originalValue);
        assert.dom(".brand-navigation-ordering-hint").doesNotExist();
        assert
          .dom(".schema-setting-editor__move-up-btn")
          .doesNotHaveAttribute("title");
        assert
          .dom(".schema-setting-editor__move-down-btn")
          .doesNotHaveAttribute("title");
        assert.verifySteps([]);
      });
    }

    for (const presentation of ["label_only", "icon_and_label"]) {
      test(`native editor saves a plain immutable ${presentation} snapshot from tracked rows`, async function (assert) {
        const data = trackedNavigationItems(presentation);
        const expected = JSON.parse(JSON.stringify(data));
        let submitted;
        let release;
        const pending = new Promise((resolve) => {
          release = resolve;
        });
        const { editor, navigationSetting } = await nativeObjectsEditor(
          this.owner,
          data,
          async (id, value) => {
            assert.strictEqual(id, 42);
            submitted = value;
            assert.deepEqual(
              validateNavigationItems(value),
              [],
              "the submitted snapshot satisfies the unchanged strict validator"
            );
            await pending;
            return { navigation_items: value };
          }
        );

        const save = editor.saveChanges();
        assert.true(editor.saveButtonDisabled, "save is disabled in flight");
        assert.deepEqual(submitted, expected);
        assert.notStrictEqual(submitted, data);
        assert.notStrictEqual(submitted[0], data[0]);
        assert.notStrictEqual(submitted[0].children, data[0].children);
        assert.notStrictEqual(submitted[0].children[0], data[0].children[0]);
        assert.strictEqual(
          Object.getPrototypeOf(submitted[0]),
          Object.prototype
        );
        assert.strictEqual(
          Object.getPrototypeOf(submitted[0].children[0]),
          Object.prototype,
          "nested tracked objects are deeply converted"
        );

        data[0].children[0].url = "http://example.com/unsafe";
        data[1].label = "Later draft";
        assert.deepEqual(
          submitted,
          expected,
          "later edits do not change the request"
        );
        release();
        await save;

        assert.strictEqual(navigationSetting.value, submitted);
        assert.deepEqual(navigationSetting.value, expected);
        assert.strictEqual(editor.validationErrorMessage, undefined);
        assert.false(
          editor.saveButtonDisabled,
          "save is restored after completion"
        );
        await clearRender();
      });
    }

    test("native editor rejects invalid nested tracked data without persistence", async function (assert) {
      const data = trackedNavigationItems("label_only");
      data[0].children[0].url = "http://example.com/unsafe";
      let updates = 0;
      const { editor, navigationSetting } = await nativeObjectsEditor(
        this.owner,
        data,
        async () => updates++
      );

      await editor.saveChanges();

      assert.strictEqual(
        updates,
        0,
        "invalid data never reaches updateSetting"
      );
      assert.true(
        editor.validationErrorMessage.includes(
          "navigation_items[0].children[0].url"
        ),
        "the invalid nested URL is reported, not a tracked-object shape error"
      );
      assert.deepEqual(navigationSetting.value, []);
      assert.false(
        editor.saveButtonDisabled,
        "save is restored after rejection"
      );
      await clearRender();
    });

    test("only the latest file or pasted bundle can replace pending import state", async function (assert) {
      const theme = adminTheme();
      const pendingReads = new Map();
      this.outletArgs = { theme };

      BrandNavigationBundles.prototype.readBundle = function (file) {
        return new Promise((resolve, reject) => {
          pendingReads.set(file.name, { resolve, reject });
        });
      };

      await render(
        <template>
          <BrandNavigationBundles @outletArgs={{this.outletArgs}} />
        </template>
      );

      const fileInput = find('.brand-navigation-bundles input[type="file"]');
      const firstFile = { name: "first.json" };
      const secondFile = { name: "second.json" };
      const thirdFile = { name: "third.json" };
      const bundleText = (label) =>
        JSON.stringify({
          format: "brand-navigation-settings",
          version: 1,
          settings: { navigation_items: [{ label, url: `/${label}` }] },
        });

      Object.defineProperty(fileInput, "files", {
        configurable: true,
        value: [firstFile],
      });
      const firstSelection = triggerEvent(fileInput, "change");
      await waitUntil(() => pendingReads.has(firstFile.name));

      assert
        .dom(".brand-navigation-bundles__controls .btn-primary")
        .isDisabled("import is unavailable while a file is being read");

      Object.defineProperty(fileInput, "files", {
        configurable: true,
        value: [secondFile],
      });
      const secondSelection = triggerEvent(fileInput, "change");
      await waitUntil(() => pendingReads.has(secondFile.name));

      pendingReads.get(secondFile.name).resolve(bundleText("second"));
      await secondSelection;
      assert
        .dom(".brand-navigation-bundles textarea")
        .hasValue(bundleText("second"));
      assert.dom(".brand-navigation-bundles").includesText("second.json");

      pendingReads.get(firstFile.name).resolve(bundleText("first"));
      await firstSelection;
      assert
        .dom(".brand-navigation-bundles textarea")
        .hasValue(bundleText("second"), "an older completion is ignored");
      assert.dom(".brand-navigation-bundles").includesText("second.json");

      Object.defineProperty(fileInput, "files", {
        configurable: true,
        value: [thirdFile],
      });
      const thirdSelection = triggerEvent(fileInput, "change");
      await waitUntil(() => pendingReads.has(thirdFile.name));
      await fillIn(".brand-navigation-bundles textarea", bundleText("pasted"));
      pendingReads.get(thirdFile.name).resolve(bundleText("third"));
      await thirdSelection;

      assert
        .dom(".brand-navigation-bundles textarea")
        .hasValue(
          bundleText("pasted"),
          "pasted input cancels an older file read"
        );
    });

    test("Appearance exposes every color setting with clear destination labels", async function (assert) {
      const theme = adminTheme();
      this.outletArgs = { theme };
      await render(
        <template>
          <BrandNavigationBundles @outletArgs={{this.outletArgs}} />
        </template>
      );

      const pickers = Array.from(
        document.querySelectorAll(
          '.brand-navigation-admin-panel input[type="color"]'
        )
      );
      assert.deepEqual(
        pickers.map((picker) => picker.dataset.setting).sort(),
        theme.settings
          .map((item) => item.setting)
          .filter((name) => name.endsWith("_color"))
          .sort(),
        "every Brand Navigation color has a picker in Appearance"
      );
      assert
        .dom(".brand-navigation-admin-panel__scope")
        .includesText("Brand Navigation only");
      for (const [name, label] of [
        [
          "submenu_hover_text_color",
          "Dropdown menus — text and icons on hover/focus",
        ],
        ["header_text_color", "Discourse header — link text"],
        [
          "header_text_hover_color",
          "Discourse header — link text on hover/focus",
        ],
        [
          "header_hover_background_color",
          "Discourse header — link and icon background on hover/focus",
        ],
      ]) {
        assert
          .dom(`input[type="color"][data-setting="${name}"]`)
          .hasAttribute("aria-label", label);
      }
      assert
        .dom('.brand-navigation-admin-panel input[type="number"]')
        .doesNotExist("size controls have not been moved into the color panel");
    });

    test("core-header color pickers save independently and reset to theme inheritance", async function (assert) {
      const theme = adminTheme();
      const submitted = [];
      this.outletArgs = { theme };
      BrandNavigationBundles.prototype.persistSettings = async function (
        values
      ) {
        submitted.push(structuredClone(values));
        return structuredClone(values);
      };

      await render(
        <template>
          <BrandNavigationBundles @outletArgs={{this.outletArgs}} />
        </template>
      );

      for (const name of ["header_icon_color", "header_icon_hover_color"]) {
        assert
          .dom(`input[type="checkbox"][data-setting="${name}"]`)
          .isNotChecked();
        assert.dom(`input[type="color"][data-setting="${name}"]`).isDisabled();
      }
      await click('input[type="checkbox"][data-setting="header_icon_color"]');
      await fillIn(
        'input[type="color"][data-setting="header_icon_color"]',
        "#123456"
      );
      await click(
        ".brand-navigation-admin-panel__appearance-controls .btn-primary"
      );
      assert.strictEqual(submitted[0].header_icon_color, "#123456");
      assert.strictEqual(submitted[0].header_icon_hover_color, "");

      await click(
        'input[type="checkbox"][data-setting="header_icon_hover_color"]'
      );
      await fillIn(
        'input[type="color"][data-setting="header_icon_hover_color"]',
        "#abcdef"
      );
      await click(
        ".brand-navigation-admin-panel__appearance-controls .btn-primary"
      );
      assert.strictEqual(submitted[1].header_icon_color, "#123456");
      assert.strictEqual(submitted[1].header_icon_hover_color, "#ABCDEF");

      await click(
        ".brand-navigation-admin-panel__appearance-controls .btn-default"
      );
      for (const name of ["header_icon_color", "header_icon_hover_color"]) {
        assert.strictEqual(submitted[2][name], "");
        assert.strictEqual(
          theme.settings.find((item) => item.setting === name).value,
          ""
        );
        assert
          .dom(`input[type="checkbox"][data-setting="${name}"]`)
          .isNotChecked();
        assert.dom(`input[type="color"][data-setting="${name}"]`).isDisabled();
      }
    });

    test("older component copies expose and save only settings they define", async function (assert) {
      const theme = adminTheme();
      theme.settings = theme.settings.filter(
        (item) =>
          ![
            "header_icon_color",
            "header_icon_hover_color",
            ...ADDITIONAL_COLORS,
          ].includes(item.setting)
      );
      let submitted;
      this.outletArgs = { theme };
      BrandNavigationBundles.prototype.persistSettings = async (values) => {
        submitted = structuredClone(values);
        return structuredClone(values);
      };
      await render(
        <template>
          <BrandNavigationBundles @outletArgs={{this.outletArgs}} />
        </template>
      );
      assert.dom('input[data-setting="header_icon_color"]').doesNotExist();
      assert
        .dom('input[data-setting="header_icon_hover_color"]')
        .doesNotExist();
      await click(
        'input[type="checkbox"][data-setting="bar_background_color"]'
      );
      await fillIn(
        'input[type="color"][data-setting="bar_background_color"]',
        "#123456"
      );
      await click(
        ".brand-navigation-admin-panel__appearance-controls .btn-primary"
      );
      assert.strictEqual(submitted.bar_background_color, "#123456");
      assert.false(Object.hasOwn(submitted, "header_icon_color"));
      assert.false(Object.hasOwn(submitted, "header_icon_hover_color"));
      assert.strictEqual(Object.keys(submitted).length, 5);
      await click(
        ".brand-navigation-admin-panel__appearance-controls .btn-default"
      );
      assert.strictEqual(Object.keys(submitted).length, 5);
      assert.true(Object.values(submitted).every((value) => value === ""));
    });

    test("imported core-header colors reconcile with their pickers", async function (assert) {
      const theme = adminTheme();
      this.outletArgs = { theme };
      BrandNavigationBundles.prototype.persistSettings = async (values) =>
        structuredClone(values);
      await render(
        <template>
          <BrandNavigationBundles @outletArgs={{this.outletArgs}} />
        </template>
      );
      await fillIn(
        ".brand-navigation-bundles textarea",
        JSON.stringify({
          format: "brand-navigation-settings",
          version: 1,
          settings: {
            header_icon_color: "123abc",
            header_icon_hover_color: "#abcdef",
          },
        })
      );
      await click(".brand-navigation-bundles__controls .btn-primary");
      assert
        .dom('input[type="color"][data-setting="header_icon_color"]')
        .hasValue("#123abc");
      assert
        .dom('input[type="color"][data-setting="header_icon_hover_color"]')
        .hasValue("#abcdef");
      assert
        .dom('input[type="checkbox"][data-setting="header_icon_color"]')
        .isChecked();
      assert
        .dom('input[type="checkbox"][data-setting="header_icon_hover_color"]')
        .isChecked();
      assert
        .dom(".brand-navigation-admin-panel__appearance-controls .btn-primary")
        .isDisabled();
    });

    test("additional color controls save and reset without changing header sizes", async function (assert) {
      const theme = adminTheme();
      theme.settings.find(
        (item) => item.setting === "submenu_text_color"
      ).value = "#002147";
      theme.settings.find(
        (item) => item.setting === "header_icon_size_desktop"
      ).value = 24;
      const submitted = [];
      this.outletArgs = { theme };
      BrandNavigationBundles.prototype.persistSettings = async (values) => {
        submitted.push(structuredClone(values));
        return structuredClone(values);
      };
      await render(
        <template>
          <BrandNavigationBundles @outletArgs={{this.outletArgs}} />
        </template>
      );
      assert
        .dom('input[type="color"][data-setting="submenu_hover_text_color"]')
        .hasValue(
          "#002147",
          "inherited hover swatch follows the configured normal submenu color"
        );
      for (const name of ADDITIONAL_COLORS) {
        assert.dom(`input[type="color"][data-setting="${name}"]`).isDisabled();
        await click(`input[type="checkbox"][data-setting="${name}"]`);
        await fillIn(`input[type="color"][data-setting="${name}"]`, "#abcdef");
      }
      await click(
        ".brand-navigation-admin-panel__appearance-controls .btn-primary"
      );
      for (const name of ADDITIONAL_COLORS) {
        assert.strictEqual(submitted[0][name], "#ABCDEF");
        assert.strictEqual(
          theme.settings.find((item) => item.setting === name).value,
          "#ABCDEF"
        );
      }
      assert.strictEqual(Object.keys(submitted[0]).length, 11);
      for (const name of HEADER_SIZES) {
        assert.false(
          Object.hasOwn(submitted[0], name),
          "saving colors leaves sizes untouched"
        );
      }
      await click(
        ".brand-navigation-admin-panel__appearance-controls .btn-default"
      );
      assert.true(Object.values(submitted[1]).every((value) => value === ""));
      assert.strictEqual(Object.keys(submitted[1]).length, 11);
      assert.strictEqual(
        theme.settings.find(
          (item) => item.setting === "header_icon_size_desktop"
        ).value,
        24
      );
    });

    test("imported sizes and additional colors persist and reconcile", async function (assert) {
      const theme = adminTheme();
      this.outletArgs = { theme };
      BrandNavigationBundles.prototype.persistSettings = async (values) =>
        structuredClone(values);
      await render(
        <template>
          <BrandNavigationBundles @outletArgs={{this.outletArgs}} />
        </template>
      );
      const settings = Object.fromEntries([
        ...ADDITIONAL_COLORS.map((name) => [name, "123abc"]),
        ...HEADER_SIZES.map((name, index) => [
          name,
          index === 0 ? 0 : 24 + index,
        ]),
      ]);
      await fillIn(
        ".brand-navigation-bundles textarea",
        JSON.stringify({
          format: "brand-navigation-settings",
          version: 1,
          settings,
        })
      );
      await click(".brand-navigation-bundles__controls .btn-primary");
      for (const name of ADDITIONAL_COLORS) {
        assert
          .dom(`input[type="color"][data-setting="${name}"]`)
          .hasValue("#123abc");
        assert
          .dom(`input[type="checkbox"][data-setting="${name}"]`)
          .isChecked();
        assert.strictEqual(
          theme.settings.find((item) => item.setting === name).value,
          "#123ABC"
        );
      }
      for (const name of HEADER_SIZES) {
        assert.strictEqual(
          theme.settings.find((item) => item.setting === name).value,
          settings[name]
        );
      }
      assert
        .dom(".brand-navigation-admin-panel__appearance-controls .btn-primary")
        .isDisabled();
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
      await settled();

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
      await settled();

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

    test("oversized navigation data is rejected before persistence", async function (assert) {
      const theme = adminTheme();
      let persistenceCalls = 0;
      this.outletArgs = { theme };
      const url = `/${"x".repeat(1_750)}`;
      const navigationItems = Array.from({ length: 100 }, (_, index) => ({
        label: `Parent ${index}`,
        url,
        children: [
          { label: "First", url },
          { label: "Second", url },
        ],
      }));

      BrandNavigationBundles.prototype.persistSettings = async function () {
        persistenceCalls += 1;
      };

      await render(
        <template>
          <BrandNavigationBundles @outletArgs={{this.outletArgs}} />
        </template>
      );

      await fillIn(
        ".brand-navigation-bundles textarea",
        JSON.stringify({
          format: "brand-navigation-settings",
          version: 1,
          settings: { navigation_items: navigationItems },
        })
      );

      assert
        .dom(".brand-navigation-bundles__controls .btn-primary")
        .isDisabled("import remains unavailable");
      assert
        .dom(".brand-navigation-bundles .alert-error")
        .includesText(
          "navigation_items cannot exceed 524,288 serialized bytes"
        );

      find(".brand-navigation-bundles__controls .btn-primary").click();
      await settled();

      assert.strictEqual(persistenceCalls, 0, "no settings request is sent");
      assert.strictEqual(
        theme.settings.find((item) => item.setting === "navigation_items")
          .value,
        "[]",
        "the navigation setting remains unchanged"
      );
    });
  }
);
