export const BUNDLE_FORMAT = "brand-navigation-settings";
export const BUNDLE_VERSION = 1;

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

  return errors;
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
