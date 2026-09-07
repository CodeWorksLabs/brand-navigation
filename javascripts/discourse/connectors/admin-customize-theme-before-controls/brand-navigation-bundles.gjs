import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { concat } from "@ember/helper";
import { on } from "@ember/modifier";
import { action } from "@ember/object";
import { ajax } from "discourse/lib/ajax";
import { not, or } from "discourse/truth-helpers";
import DButton from "discourse/ui-kit/d-button";
import { i18n } from "discourse-i18n";
import {
  createBundle,
  MAX_BUNDLE_BYTES,
  PORTABLE_SETTINGS,
  readBundleFile,
  serializeBundle,
  validateBundle,
} from "../../lib/configuration-bundle";
import {
  isBrandNavigationTheme,
  persistThemeSettings,
  prepareThemeSettingsImport,
  snapshotPlainData,
} from "../../lib/brand-navigation-admin";

const APPEARANCE_COLORS = [
  {
    setting: "bar_background_color",
    label: "bar_background",
    variable: "--tertiary",
    fallback: "#0088cc",
  },
  {
    setting: "bar_text_color",
    label: "bar_text",
    variable: "--secondary",
    fallback: "#ffffff",
  },
  {
    setting: "hover_background_color",
    label: "hover_background",
    variable: "--quaternary-low",
    fallback: "#e9e9e9",
  },
  {
    setting: "submenu_background_color",
    label: "submenu_background",
    variable: "--secondary",
    fallback: "#ffffff",
  },
  {
    setting: "submenu_text_color",
    label: "submenu_text",
    variable: "--primary",
    fallback: "#222222",
  },
];

function normalizedHexColor(value) {
  const hex = value?.trim();

  if (/^#[0-9a-f]{6}$/i.test(hex)) {
    return hex.toUpperCase();
  }

  if (/^[0-9a-f]{6}$/i.test(hex)) {
    return `#${hex.toUpperCase()}`;
  }

  if (/^#[0-9a-f]{3}$/i.test(hex)) {
    return `#${[...hex.slice(1)].map((character) => character.repeat(2)).join("")}`;
  }

  const rgb = hex?.match(
    /^rgba?\(\s*(\d+)\s*[, ]\s*(\d+)\s*[, ]\s*(\d+)(?:\s*[,/]\s*[\d.]+)?\s*\)$/i
  );

  if (!rgb) {
    return undefined;
  }

  const channels = rgb.slice(1, 4).map(Number);
  if (channels.some((channel) => channel > 255)) {
    return undefined;
  }

  return `#${channels
    .map((channel) => channel.toString(16).padStart(2, "0"))
    .join("")}`;
}

export default class BrandNavigationBundles extends Component {
  @tracked bundle;
  @tracked bundleText = "";
  @tracked errors = [];
  @tracked fileName;
  @tracked saving = false;
  @tracked success;
  @tracked appearanceValues = {};

  constructor() {
    super(...arguments);
    this.appearanceValues = Object.fromEntries(
      APPEARANCE_COLORS.map(({ setting }) => [
        setting,
        normalizedHexColor(
          this.theme.settings.find((candidate) => candidate.setting === setting)
            ?.value
        ) || "",
      ])
    );
  }

  get theme() {
    return this.args.outletArgs.theme;
  }

  get isBrandNavigation() {
    return isBrandNavigationTheme(this.theme);
  }

  get importDisabled() {
    return !this.bundle || this.errors.length > 0 || this.saving;
  }

  get appearanceColors() {
    return APPEARANCE_COLORS.map((color) => ({
      ...color,
      enabled: Boolean(this.appearanceValues[color.setting]),
      value:
        normalizedHexColor(this.appearanceValues[color.setting]) ||
        this.inheritedColor(color),
    }));
  }

  get appearanceDirty() {
    return APPEARANCE_COLORS.some(({ setting }) => {
      const persisted =
        normalizedHexColor(
          this.theme.settings.find((candidate) => candidate.setting === setting)
            ?.value
        ) || "";
      return persisted !== this.appearanceValues[setting];
    });
  }

  inheritedColor(color) {
    const siteColor = getComputedStyle(document.documentElement)
      .getPropertyValue(color.variable)
      .trim();

    return normalizedHexColor(siteColor) || color.fallback;
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
        i18n(themePrefix("brand_navigation.bundles.file_too_large"), {
          count: MAX_BUNDLE_BYTES.toLocaleString(),
        }),
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
  updateAppearanceColor(event) {
    const { setting } = event.target.dataset;
    this.appearanceValues = {
      ...this.appearanceValues,
      [setting]: event.target.value.toUpperCase(),
    };
    this.success = undefined;
  }

  @action
  toggleAppearanceColor(event) {
    const { setting } = event.target.dataset;
    const color = APPEARANCE_COLORS.find(
      (candidate) => candidate.setting === setting
    );
    this.appearanceValues = {
      ...this.appearanceValues,
      [setting]: event.target.checked ? this.inheritedColor(color) : "",
    };
    this.success = undefined;
  }

  @action
  async saveAppearance() {
    if (!this.appearanceDirty || this.saving) {
      return;
    }

    const submittedAppearance = snapshotPlainData(this.appearanceValues);

    this.saving = true;
    this.errors = [];
    this.success = undefined;

    try {
      await persistThemeSettings(this.theme.id, submittedAppearance, ajax);

      for (const [name, value] of Object.entries(submittedAppearance)) {
        this.theme.settings
          .find((setting) => setting.setting === name)
          ?.set("value", value);
      }

      this.appearanceValues = submittedAppearance;

      this.success = i18n(
        themePrefix("brand_navigation.appearance.save_success")
      );
    } catch (error) {
      const responseErrors = error.jqXHR?.responseJSON?.errors;
      this.errors = [
        (Array.isArray(responseErrors)
          ? responseErrors.join(" ")
          : responseErrors) ||
          error.message ||
          i18n(themePrefix("brand_navigation.appearance.save_error")),
      ];
    } finally {
      this.saving = false;
    }
  }

  @action
  async resetAppearance() {
    this.appearanceValues = Object.fromEntries(
      APPEARANCE_COLORS.map(({ setting }) => [setting, ""])
    );
    await this.saveAppearance();
  }

  @action
  async importBundle() {
    if (this.importDisabled) {
      return;
    }

    const submittedBundle = snapshotPlainData(this.bundle);

    this.saving = true;
    this.errors = [];
    this.success = undefined;

    try {
      const persistedSettings = prepareThemeSettingsImport(
        this.theme,
        submittedBundle
      );

      const submittedSettings = await persistThemeSettings(
        this.theme.id,
        persistedSettings,
        ajax
      );

      for (const [name, value] of Object.entries(submittedSettings)) {
        this.theme.settings
          .find((setting) => setting.setting === name)
          .set(
            "value",
            name === "navigation_items" ? submittedBundle.settings[name] : value
          );
      }

      this.appearanceValues = Object.fromEntries(
        APPEARANCE_COLORS.map(({ setting }) => [
          setting,
          setting in submittedSettings
            ? normalizedHexColor(submittedSettings[setting]) || ""
            : this.appearanceValues[setting],
        ])
      );

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
          i18n(themePrefix("brand_navigation.bundles.import_error")),
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
    const blob = new Blob([serializeBundle(bundle)], {
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
      <section class="brand-navigation-admin-panel control-unit">
        <div class="mini-title">
          {{i18n (themePrefix "brand_navigation.appearance.title")}}
        </div>
        <p class="description">
          {{i18n (themePrefix "brand_navigation.appearance.description")}}
        </p>

        <div class="brand-navigation-admin-panel__color-grid">
          {{#each this.appearanceColors as |color|}}
            <div class="brand-navigation-admin-panel__color">
              <input
                type="color"
                value={{color.value}}
                disabled={{or this.saving (not color.enabled)}}
                data-setting={{color.setting}}
                aria-label={{i18n
                  (themePrefix
                    (concat "brand_navigation.appearance." color.label)
                  )
                }}
                {{on "input" this.updateAppearanceColor}}
              />
              <span class="brand-navigation-admin-panel__color-copy">
                <span class="brand-navigation-admin-panel__color-name">
                  {{i18n
                    (themePrefix
                      (concat "brand_navigation.appearance." color.label)
                    )
                  }}
                </span>
                <label>
                  <input
                    type="checkbox"
                    checked={{color.enabled}}
                    disabled={{this.saving}}
                    data-setting={{color.setting}}
                    {{on "change" this.toggleAppearanceColor}}
                  />
                  {{i18n (themePrefix "brand_navigation.appearance.custom")}}
                </label>
                {{#unless color.enabled}}
                  <span class="brand-navigation-admin-panel__inherit">
                    {{i18n
                      (themePrefix "brand_navigation.appearance.inherited")
                      variable=color.variable
                    }}
                  </span>
                {{/unless}}
              </span>
            </div>
          {{/each}}
        </div>

        <div class="brand-navigation-admin-panel__appearance-controls">
          <DButton
            @action={{this.saveAppearance}}
            @disabled={{not this.appearanceDirty}}
            @isLoading={{this.saving}}
            @icon="check"
            @translatedLabel={{i18n
              (themePrefix "brand_navigation.appearance.save")
            }}
            class="btn-primary"
          />
          <DButton
            @action={{this.resetAppearance}}
            @disabled={{this.saving}}
            @icon="arrow-rotate-left"
            @translatedLabel={{i18n
              (themePrefix "brand_navigation.appearance.reset")
            }}
            class="btn-default"
          />
        </div>
      </section>

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
              disabled={{this.saving}}
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
            @disabled={{this.saving}}
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
            disabled={{this.saving}}
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
