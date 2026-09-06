export const BUNDLE_FORMAT = "brand-navigation-settings";
export const BUNDLE_VERSION = 1;

const DEVICE_VISIBILITY_VALUES = new Set(["both", "desktop", "mobile"]);

export const PORTABLE_SETTINGS = [
  "outlet",
  "show_brand",
  "brand_name",
  "brand_url",
  "brand_presentation",
  "brand_target",
  "mobile_mode",
  "navigation_items",
  "custom_font_awesome_icons",
];

export function validateBundle(bundle) {
  const errors = [];

  if (!bundle || typeof bundle !== "object" || Array.isArray(bundle)) {
    return ["Bundle must be a JSON object."];
  }

  if (bundle.format !== BUNDLE_FORMAT) {
    errors.push(`format must be ${JSON.stringify(BUNDLE_FORMAT)}.`);
  }

  if (bundle.version !== BUNDLE_VERSION) {
    errors.push(`version must be ${BUNDLE_VERSION}.`);
  }

  if (!bundle.settings || typeof bundle.settings !== "object") {
    errors.push("settings must be an object.");
    return errors;
  }

  for (const key of Object.keys(bundle.settings)) {
    if (!PORTABLE_SETTINGS.includes(key)) {
      errors.push(`Unsupported setting: ${key}.`);
    }
  }

  if (
    "navigation_items" in bundle.settings &&
    !Array.isArray(bundle.settings.navigation_items)
  ) {
    errors.push("navigation_items must be an array.");
  }

  if (
    "custom_font_awesome_icons" in bundle.settings &&
    !Array.isArray(bundle.settings.custom_font_awesome_icons)
  ) {
    errors.push("custom_font_awesome_icons must be an array.");
  }

  for (const item of bundle.settings.navigation_items || []) {
    validateDeviceVisibility(item, "Top-level item", errors);

    if ((item.surface || "bar") === "site_header") {
      if (!item.url || !item.icon) {
        errors.push(
          `Site-header item ${JSON.stringify(item.label)} requires a URL and icon.`
        );
      }

      if ((item.children || []).length) {
        errors.push(
          `Site-header item ${JSON.stringify(item.label)} cannot contain submenu items.`
        );
      }
    }

    for (const child of item.children || []) {
      validateDeviceVisibility(child, "Submenu item", errors);

      if (child.url === "#") {
        errors.push(
          `Submenu item ${JSON.stringify(child.label)} uses a placeholder URL.`
        );
      }
    }
  }

  return errors;
}

function validateDeviceVisibility(item, kind, errors) {
  if (
    item.device_visibility &&
    !DEVICE_VISIBILITY_VALUES.has(item.device_visibility)
  ) {
    errors.push(
      `${kind} ${JSON.stringify(item.label)} has invalid device_visibility.`
    );
  }
}

export function themeSettingValue(name, value) {
  if (name === "custom_font_awesome_icons" && Array.isArray(value)) {
    return value.join("|");
  }

  return value;
}

export function createBundle(settings, metadata = {}) {
  const portable = {};

  for (const key of PORTABLE_SETTINGS) {
    if (key in settings) {
      portable[key] = settings[key];
    }
  }

  if (typeof portable.custom_font_awesome_icons === "string") {
    portable.custom_font_awesome_icons = portable.custom_font_awesome_icons
      .split("|")
      .filter(Boolean);
  }

  if (typeof portable.navigation_items === "string") {
    portable.navigation_items = JSON.parse(portable.navigation_items);
  }

  return {
    format: BUNDLE_FORMAT,
    version: BUNDLE_VERSION,
    metadata,
    settings: portable,
  };
}
