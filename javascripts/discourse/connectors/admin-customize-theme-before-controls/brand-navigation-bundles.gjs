import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { on } from "@ember/modifier";
import { action } from "@ember/object";
import { ajax } from "discourse/lib/ajax";
import DButton from "discourse/ui-kit/d-button";
import { i18n } from "discourse-i18n";
import {
  createBundle,
  MAX_BUNDLE_BYTES,
  PORTABLE_SETTINGS,
  readBundleFile,
  validateBundle,
} from "../../lib/configuration-bundle";
import {
  isBrandNavigationTheme,
  prepareThemeSettingsImport,
} from "../../lib/brand-navigation-admin";

export default class BrandNavigationBundles extends Component {
  @tracked bundle;
  @tracked bundleText = "";
  @tracked errors = [];
  @tracked fileName;
  @tracked saving = false;
  @tracked success;

  get theme() {
    return this.args.outletArgs.theme;
  }

  get isBrandNavigation() {
    return isBrandNavigationTheme(this.theme);
  }

  get importDisabled() {
    return !this.bundle || this.errors.length > 0 || this.saving;
  }

  currentSettings() {
    return Object.fromEntries(
      this.theme.settings.map((setting) => [setting.setting, setting.value])
    );
  }

  loadBundleText(text, fileName) {
    this.bundle = undefined;
    this.bundleText = text;
    this.errors = [];
    this.fileName = fileName;
    this.success = undefined;

    if (!text.trim()) {
      return;
    }

    if (new TextEncoder().encode(text).length > MAX_BUNDLE_BYTES) {
      this.errors = [
        `Bundle cannot exceed ${MAX_BUNDLE_BYTES.toLocaleString()} bytes.`,
      ];
      return;
    }

    try {
      const bundle = JSON.parse(text);
      this.errors = validateBundle(bundle);
      this.bundle = this.errors.length ? undefined : bundle;
    } catch (error) {
      this.errors = [error.message];
    }
  }

  @action
  async selectBundle(event) {
    const [file] = event.target.files;

    if (!file) {
      return;
    }

    try {
      this.loadBundleText(await readBundleFile(file), file.name);
    } catch (error) {
      this.errors = [error.message];
    }
  }

  @action
  updateBundleText(event) {
    this.loadBundleText(event.target.value);
  }

  @action
  async importBundle() {
    if (this.importDisabled) {
      return;
    }

    this.saving = true;
    this.errors = [];
    this.success = undefined;

    try {
      const persistedSettings = prepareThemeSettingsImport(
        this.theme,
        this.bundle
      );

      await ajax(`/admin/themes/${this.theme.id}.json`, {
        type: "PUT",
        data: { theme: { settings: persistedSettings } },
      });

      for (const [name, value] of Object.entries(persistedSettings)) {
        this.theme.settings
          .find((setting) => setting.setting === name)
          .set(
            "value",
            name === "navigation_items" ? this.bundle.settings[name] : value
          );
      }

      this.success = i18n(
        themePrefix("brand_navigation.bundles.import_success")
      );
    } catch (error) {
      const responseErrors = error.jqXHR?.responseJSON?.errors;

      this.errors = [
        (Array.isArray(responseErrors)
          ? responseErrors.join(" ")
          : responseErrors) ||
          error.message ||
          "Import failed. Reload the component settings before retrying.",
      ];
    } finally {
      this.saving = false;
    }
  }

  @action
  exportBundle() {
    let bundle;

    try {
      bundle = createBundle(this.currentSettings(), {
        exported_at: new Date().toISOString(),
        source_theme_id: this.theme.id,
        source_theme_name: this.theme.name,
      });
    } catch (error) {
      this.success = undefined;
      this.errors = [error.message];
      return;
    }

    this.errors = [];
    const blob = new Blob([`${JSON.stringify(bundle, null, 2)}\n`], {
      type: "application/json",
    });
    const url = URL.createObjectURL(blob);
    const anchor = document.createElement("a");

    anchor.href = url;
    anchor.download = "brand-navigation-settings.json";
    anchor.click();
    URL.revokeObjectURL(url);
  }

  <template>
    {{#if this.isBrandNavigation}}
      <section class="brand-navigation-bundles control-unit">
        <div class="mini-title">
          {{i18n (themePrefix "brand_navigation.bundles.title")}}
        </div>
        <p class="description">
          {{i18n (themePrefix "brand_navigation.bundles.description")}}
        </p>
        <div class="brand-navigation-bundles__controls">
          <label class="btn btn-default">
            {{i18n (themePrefix "brand_navigation.bundles.choose")}}
            <input
              type="file"
              accept="application/json,.json"
              {{on "change" this.selectBundle}}
            />
          </label>
          <DButton
            @action={{this.importBundle}}
            @disabled={{this.importDisabled}}
            @icon="upload"
            @translatedLabel={{i18n
              (themePrefix "brand_navigation.bundles.import")
            }}
            class="btn-primary"
          />
          <DButton
            @action={{this.exportBundle}}
            @icon="download"
            @translatedLabel={{i18n
              (themePrefix "brand_navigation.bundles.export")
            }}
            class="btn-default"
          />
        </div>

        <label class="brand-navigation-bundles__paste-label">
          {{i18n (themePrefix "brand_navigation.bundles.paste")}}
          <textarea
            value={{this.bundleText}}
            placeholder={{i18n
              (themePrefix "brand_navigation.bundles.paste_placeholder")
            }}
            {{on "input" this.updateBundleText}}
          ></textarea>
        </label>

        {{#if this.fileName}}
          <p>{{this.fileName}}</p>
        {{/if}}
        {{#each this.errors as |error|}}
          <div class="alert alert-error" role="alert">{{error}}</div>
        {{/each}}
        {{#if this.success}}
          <div class="alert alert-success" role="status" aria-live="polite">
            {{this.success}}
          </div>
        {{/if}}
      </section>
    {{/if}}
  </template>
}
