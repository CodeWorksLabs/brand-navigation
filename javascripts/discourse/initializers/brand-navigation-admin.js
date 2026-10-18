/* global themePrefix */

import { action } from "@ember/object";
import { scheduleOnce } from "@ember/runloop";
import { popupAjaxError } from "discourse/lib/ajax-error";
import { withPluginApi } from "discourse/lib/plugin-api";
import { i18n } from "discourse-i18n";
import {
  brandNavigationEditorSchema,
  isBrandNavigationObjectsEditor,
  snapshotPlainData,
} from "../lib/brand-navigation-admin";
import { validateNavigationItems } from "../lib/configuration-bundle";

export default {
  name: "brand-navigation-admin",

  initialize() {
    withPluginApi((api) => {
      api.modifyClass(
        "component:schema-setting/editor",
        (Superclass) =>
          class extends Superclass {
            get fields() {
              const fields = super.fields;
              if (isBrandNavigationObjectsEditor(this.args)) {
                scheduleOnce("afterRender", this, this.showOrderingHelp);
              }
              return fields;
            }

            @action
            showOrderingHelp() {
              if (this.isDestroying || this.isDestroyed) {
                return;
              }

              const editors = document.querySelectorAll(
                ".schema-setting-editor"
              );
              if (editors.length !== 1) {
                return;
              }
              const editor = editors[0];
              const actions = editor.querySelector(
                ".schema-setting-editor__field-actions"
              );
              if (!actions) {
                return;
              }

              let hint = editor.querySelector(
                ".brand-navigation-ordering-hint"
              );
              if (!hint) {
                hint = document.createElement("p");
                hint.className = "description brand-navigation-ordering-hint";
                actions.before(hint);
              }
              hint.textContent = i18n(
                themePrefix("brand_navigation.editor.ordering_hint")
              );

              for (const direction of ["up", "down"]) {
                const button = actions.querySelector(
                  `.schema-setting-editor__move-${direction}-btn`
                );
                const label = i18n(
                  themePrefix(`brand_navigation.editor.move_${direction}`)
                );
                button?.setAttribute("title", label);
                button?.setAttribute("aria-label", label);
              }
            }

            brandNavigationViewSchema(schema) {
              if (!isBrandNavigationObjectsEditor(this.args)) {
                return schema;
              }

              return brandNavigationEditorSchema(
                this.args,
                {
                  menuItem: i18n(
                    themePrefix("brand_navigation.editor.menu_item")
                  ),
                  submenuItem: i18n(
                    themePrefix("brand_navigation.editor.submenu_item")
                  ),
                },
                schema
              );
            }

            get activeSchema() {
              return this.brandNavigationViewSchema(super.activeSchema);
            }

            @action
            generateSchemaTitle(object, schema, index) {
              return super.generateSchemaTitle(
                object,
                this.brandNavigationViewSchema(schema),
                index
              );
            }

            @action
            async saveChanges() {
              if (!isBrandNavigationObjectsEditor(this.args)) {
                return super.saveChanges(...arguments);
              }

              this.saveButtonDisabled = true;
              this.validationErrorMessage = undefined;

              try {
                const submittedData = snapshotPlainData(this.data);
                const errors = validateNavigationItems(submittedData);

                if (errors.length) {
                  this.validationErrorMessage = errors.join(" ");
                  return;
                }

                const result = await this.args.setting.updateSetting(
                  this.args.id,
                  submittedData
                );

                if (result) {
                  this.args.setting.set(
                    "value",
                    result[this.args.setting.setting]
                  );
                }
              } catch (error) {
                if (error.jqXHR?.responseJSON?.errors) {
                  [this.validationErrorMessage] =
                    error.jqXHR.responseJSON.errors;
                } else {
                  popupAjaxError(error);
                }
              } finally {
                this.saveButtonDisabled = false;
              }
            }
          },
        { ignoreMissing: true }
      );
    });
  },
};
