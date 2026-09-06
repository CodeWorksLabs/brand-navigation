import { action } from "@ember/object";
import { popupAjaxError } from "discourse/lib/ajax-error";
import { withPluginApi } from "discourse/lib/plugin-api";
import { isBrandNavigationObjectsEditor } from "../lib/brand-navigation-admin";

export default {
  name: "brand-navigation-admin",

  initialize() {
    withPluginApi((api) => {
      api.modifyClass(
        "component:schema-setting/editor",
        (Superclass) =>
          class extends Superclass {
            @action
            async saveChanges() {
              if (!isBrandNavigationObjectsEditor(this.args)) {
                return super.saveChanges(...arguments);
              }

              this.saveButtonDisabled = true;
              this.validationErrorMessage = undefined;

              try {
                const result = await this.args.setting.updateSetting(
                  this.args.id,
                  this.data
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
