const CANONICAL_REMOTE_PATH = "/codeworkslabs/brand-navigation";
const UNIQUE_SCHEMA_NAME = "brand_navigation_item_v1";

export function isBrandNavigationTheme(theme) {
  const remoteUrl = theme?.remote_theme?.remote_url;

  if (theme?.component !== true || typeof remoteUrl !== "string") {
    return false;
  }

  if (
    /^git@github\.com:codeworkslabs\/brand-navigation(?:\.git)?$/i.test(
      remoteUrl
    )
  ) {
    return true;
  }

  try {
    const url = new URL(remoteUrl);
    const path = url.pathname.replace(/\.git\/?$/i, "").replace(/\/$/, "");

    return (
      url.protocol === "https:" &&
      url.hostname.toLowerCase() === "github.com" &&
      (url.port === "" || url.port === "443") &&
      path.toLowerCase() === CANONICAL_REMOTE_PATH &&
      !url.username &&
      !url.password &&
      !url.search &&
      !url.hash
    );
  } catch {
    return false;
  }
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

export function isBrandNavigationObjectsEditor(args) {
  return (
    args?.setting?.setting === "navigation_items" &&
    args?.schema?.name === UNIQUE_SCHEMA_NAME
  );
}
import { themeSettingValue } from "./configuration-bundle.js";
