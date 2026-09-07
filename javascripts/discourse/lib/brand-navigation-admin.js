const UNIQUE_SCHEMA_NAME = "brand_navigation_item_v1";
const COMPONENT_SETTING_SIGNATURE = [
  "brand_presentation",
  "custom_font_awesome_icons",
  "mobile_mode",
  "navigation_items",
  "submenu_text_color",
];

export function isBrandNavigationTheme(theme) {
  if (theme?.component !== true || !Array.isArray(theme.settings)) {
    return false;
  }

  const settingNames = new Set(
    theme.settings.map((setting) => setting?.setting).filter(Boolean)
  );

  return COMPONENT_SETTING_SIGNATURE.every((name) => settingNames.has(name));
}

export function prepareThemeSettingsImport(theme, bundle) {
  const values = {};

  for (const [name, value] of Object.entries(bundle.settings)) {
    const setting = theme.settings.find(
      (candidate) => candidate.setting === name
    );

    if (!setting) {
      throw new Error(`This component does not define setting ${name}.`);
    }

    values[name] = themeSettingValue(name, value);
  }

  return values;
}

export function snapshotPlainData(value) {
  return JSON.parse(JSON.stringify(value));
}

export async function persistThemeSettings(themeId, settings, request) {
  const submittedSettings = snapshotPlainData(settings);

  await request(`/admin/themes/${themeId}.json`, {
    type: "PUT",
    data: { theme: { settings: submittedSettings } },
  });

  return submittedSettings;
}

export function isBrandNavigationObjectsEditor(args) {
  return (
    args?.setting?.setting === "navigation_items" &&
    args?.schema?.name === UNIQUE_SCHEMA_NAME
  );
}
import { themeSettingValue } from "./configuration-bundle.js";
