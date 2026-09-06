export const BUNDLE_FORMAT = "brand-navigation-settings";
export const BUNDLE_VERSION = 1;
export const MAX_BUNDLE_BYTES = 1_000_000;

const MAX_NAVIGATION_ITEMS = 100;
const MAX_CHILDREN_PER_ITEM = 50;
const MAX_ICONS = 200;

const OUTLET_VALUES = new Set(["above-site-header", "below-site-header"]);
const BRAND_PRESENTATION_VALUES = new Set([
  "logo_and_name",
  "logo_only",
  "name_only",
]);
const ITEM_PRESENTATION_VALUES = new Set([
  "icon_and_label",
  "label_only",
  "icon_only",
]);
const SECTION_VALUES = new Set(["left", "right"]);
const LINK_MODE_VALUES = new Set(["link", "group"]);
const SURFACE_VALUES = new Set(["bar", "site_header"]);
const TARGET_VALUES = new Set(["_self", "_blank"]);
const VISIBILITY_VALUES = new Set(["everyone", "anonymous", "authenticated"]);
const DEVICE_VISIBILITY_VALUES = new Set(["both", "desktop", "mobile"]);
const MOBILE_MODE_VALUES = new Set(["menu", "bar", "hidden"]);
const COLOR_SETTINGS = [
  "bar_background_color",
  "bar_text_color",
  "hover_background_color",
  "submenu_background_color",
  "submenu_text_color",
];

const TOP_LEVEL_KEYS = new Set(["format", "version", "metadata", "settings"]);
const NAVIGATION_ITEM_KEYS = new Set([
  "label",
  "url",
  "link_mode",
  "title",
  "icon",
  "presentation",
  "section",
  "surface",
  "device_visibility",
  "target",
  "visibility",
  "children",
]);
const NAVIGATION_CHILD_KEYS = new Set([
  "label",
  "url",
  "title",
  "description",
  "icon",
  "presentation",
  "device_visibility",
  "target",
  "visibility",
]);

export const PORTABLE_SETTINGS = [
  "outlet",
  "show_brand",
  "brand_name",
  "brand_url",
  "brand_presentation",
  "brand_target",
  "mobile_mode",
  ...COLOR_SETTINGS,
  "navigation_items",
  "custom_font_awesome_icons",
];

export function validateBundle(bundle) {
  const errors = [];

  if (!isPlainObject(bundle)) {
    return ["Bundle must be a JSON object."];
  }

  validateUnknownKeys(bundle, TOP_LEVEL_KEYS, "Bundle", errors);

  if (bundle.format !== BUNDLE_FORMAT) {
    errors.push(`format must be ${JSON.stringify(BUNDLE_FORMAT)}.`);
  }

  if (bundle.version !== BUNDLE_VERSION) {
    errors.push(`version must be ${BUNDLE_VERSION}.`);
  }

  if ("metadata" in bundle && !isPlainObject(bundle.metadata)) {
    errors.push("metadata must be an object.");
  }

  if (!isPlainObject(bundle.settings)) {
    errors.push("settings must be an object.");
    return errors;
  }

  validateUnknownKeys(
    bundle.settings,
    new Set(PORTABLE_SETTINGS),
    "Settings",
    errors,
    "Unsupported setting"
  );

  if (Object.keys(bundle.settings).length === 0) {
    errors.push("settings must contain at least one portable setting.");
  }

  validateSettings(bundle.settings, errors);

  return errors;
}

export async function readBundleFile(file) {
  if (file.size > MAX_BUNDLE_BYTES) {
    throw new Error(
      `Bundle cannot exceed ${MAX_BUNDLE_BYTES.toLocaleString()} bytes.`
    );
  }

  return await file.text();
}

export function validateNavigationItems(items) {
  const errors = [];

  if (!Array.isArray(items)) {
    return ["navigation_items must be an array."];
  }

  if (items.length > MAX_NAVIGATION_ITEMS) {
    errors.push(
      `navigation_items cannot contain more than ${MAX_NAVIGATION_ITEMS} items.`
    );
  }

  items.forEach((item, index) => validateNavigationItem(item, index, errors));
  return errors;
}

function validateSettings(settings, errors) {
  validateOptionalEnum(settings, "outlet", OUTLET_VALUES, errors);
  validateOptionalBoolean(settings, "show_brand", errors);
  validateOptionalString(settings, "brand_name", 100, errors);
  validateOptionalUrl(settings, "brand_url", errors);
  validateOptionalEnum(
    settings,
    "brand_presentation",
    BRAND_PRESENTATION_VALUES,
    errors
  );
  validateOptionalEnum(settings, "brand_target", TARGET_VALUES, errors);
  validateOptionalEnum(settings, "mobile_mode", MOBILE_MODE_VALUES, errors);
  COLOR_SETTINGS.forEach((key) => validateOptionalColor(settings, key, errors));

  if ("navigation_items" in settings) {
    errors.push(...validateNavigationItems(settings.navigation_items));
  }

  if ("custom_font_awesome_icons" in settings) {
    const icons = settings.custom_font_awesome_icons;

    if (!Array.isArray(icons)) {
      errors.push("custom_font_awesome_icons must be an array.");
    } else {
      if (icons.length > MAX_ICONS) {
        errors.push(
          `custom_font_awesome_icons cannot contain more than ${MAX_ICONS} items.`
        );
      }

      icons.forEach((icon, index) => {
        if (!isBoundedString(icon, 1, 100)) {
          errors.push(
            `custom_font_awesome_icons[${index}] must be a non-empty string of at most 100 characters.`
          );
        } else if (icon.includes("|")) {
          errors.push(
            `custom_font_awesome_icons[${index}] cannot contain the pipe delimiter.`
          );
        }
      });
    }
  }
}

function validateOptionalColor(value, key, errors) {
  if (
    key in value &&
    !/^#?[0-9a-f]{6}$/i.test(value[key]) &&
    value[key] !== ""
  ) {
    errors.push(
      `${key} must be blank or a six-digit hex color such as #1A2B3C.`
    );
  }
}

function validateNavigationItem(item, index, errors) {
  const path = `navigation_items[${index}]`;

  if (!isPlainObject(item)) {
    errors.push(`${path} must be an object.`);
    return;
  }

  validateUnknownKeys(item, NAVIGATION_ITEM_KEYS, path, errors);
  validateRequiredString(item, "label", 100, path, errors);
  validateOptionalString(item, "title", 200, errors, path);
  validateOptionalString(item, "description", 300, errors, path);
  validateOptionalString(item, "icon", 100, errors, path);
  validateOptionalUrl(item, "url", errors, path);
  validateOptionalEnum(item, "link_mode", LINK_MODE_VALUES, errors, path);
  validateOptionalEnum(
    item,
    "presentation",
    ITEM_PRESENTATION_VALUES,
    errors,
    path
  );
  validateOptionalEnum(item, "section", SECTION_VALUES, errors, path);
  validateOptionalEnum(item, "surface", SURFACE_VALUES, errors, path);
  validateOptionalEnum(
    item,
    "device_visibility",
    DEVICE_VISIBILITY_VALUES,
    errors,
    path
  );
  validateOptionalEnum(item, "target", TARGET_VALUES, errors, path);
  validateOptionalEnum(item, "visibility", VISIBILITY_VALUES, errors, path);

  const children = item.children;
  if (children !== undefined && !Array.isArray(children)) {
    errors.push(`${path}.children must be an array.`);
    return;
  }

  if ((children || []).length > MAX_CHILDREN_PER_ITEM) {
    errors.push(
      `${path}.children cannot contain more than ${MAX_CHILDREN_PER_ITEM} items.`
    );
  }

  (children || []).forEach((child, childIndex) =>
    validateNavigationChild(child, `${path}.children[${childIndex}]`, errors)
  );

  const surface = item.surface || "bar";
  const linkMode =
    item.link_mode || (isNonEmptyString(item.url) ? "link" : "group");
  if (surface === "site_header") {
    if (!isNonEmptyString(item.url) || !isNonEmptyString(item.icon)) {
      errors.push(`${path} with site_header surface requires a URL and icon.`);
    }

    if ((children || []).length) {
      errors.push(`${path} with site_header surface cannot contain children.`);
    }
    if (linkMode === "group") {
      errors.push(
        `${path} with site_header surface cannot use group link mode.`
      );
    }
  } else if (linkMode === "group" && !(children || []).length) {
    errors.push(`${path} with group link mode requires at least one child.`);
  } else if (linkMode === "link" && !isNonEmptyString(item.url)) {
    errors.push(`${path} with link mode requires a URL.`);
  } else if (!isNonEmptyString(item.url) && !(children || []).length) {
    errors.push(`${path} requires a URL or at least one child.`);
  }
}

function validateNavigationChild(child, path, errors) {
  if (!isPlainObject(child)) {
    errors.push(`${path} must be an object.`);
    return;
  }

  validateUnknownKeys(child, NAVIGATION_CHILD_KEYS, path, errors);
  validateRequiredString(child, "label", 100, path, errors);
  validateRequiredUrl(child, "url", path, errors);
  validateOptionalString(child, "title", 200, errors, path);
  validateOptionalString(child, "description", 300, errors, path);
  validateOptionalString(child, "icon", 100, errors, path);
  validateOptionalEnum(
    child,
    "presentation",
    ITEM_PRESENTATION_VALUES,
    errors,
    path
  );
  validateOptionalEnum(
    child,
    "device_visibility",
    DEVICE_VISIBILITY_VALUES,
    errors,
    path
  );
  validateOptionalEnum(child, "target", TARGET_VALUES, errors, path);
  validateOptionalEnum(child, "visibility", VISIBILITY_VALUES, errors, path);
}

function validateUnknownKeys(
  value,
  allowed,
  path,
  errors,
  prefix = "Unknown field"
) {
  for (const key of Object.keys(value)) {
    if (!allowed.has(key)) {
      errors.push(
        `${prefix}: ${path === "Settings" ? key : `${path}.${key}`}.`
      );
    }
  }
}

function validateOptionalBoolean(value, key, errors, path = "settings") {
  if (key in value && typeof value[key] !== "boolean") {
    errors.push(`${path}.${key} must be a boolean.`);
  }
}

function validateOptionalString(
  value,
  key,
  maxLength,
  errors,
  path = "settings"
) {
  if (key in value && typeof value[key] !== "string") {
    errors.push(`${path}.${key} must be a string.`);
  } else if (typeof value[key] === "string" && value[key].length > maxLength) {
    errors.push(`${path}.${key} cannot exceed ${maxLength} characters.`);
  }
}

function validateRequiredString(value, key, maxLength, path, errors) {
  if (!isBoundedString(value[key], 1, maxLength)) {
    errors.push(
      `${path}.${key} must be a non-empty string of at most ${maxLength} characters.`
    );
  }
}

function validateOptionalEnum(value, key, choices, errors, path = "settings") {
  if (key in value && !choices.has(value[key])) {
    errors.push(
      `${path}.${key} must be one of ${[...choices]
        .map((choice) => JSON.stringify(choice))
        .join(", ")}.`
    );
  }
}

function validateOptionalUrl(value, key, errors, path = "settings") {
  if (key in value && value[key] !== "" && !isSafeNavigationUrl(value[key])) {
    errors.push(`${path}.${key} must be a safe relative or HTTPS URL.`);
  }
}

function validateRequiredUrl(value, key, path, errors) {
  if (!isSafeNavigationUrl(value[key])) {
    errors.push(`${path}.${key} must be a safe relative or HTTPS URL.`);
  }
}

export function isSafeNavigationUrl(value) {
  if (
    !isNonEmptyString(value) ||
    value.length > 2048 ||
    value.trim() !== value ||
    /[\u0000-\u001f\u007f]/.test(value)
  ) {
    return false;
  }

  if (value.startsWith("/") && !value.startsWith("//")) {
    try {
      return (
        new URL(value, "https://brand-navigation.invalid").origin ===
        "https://brand-navigation.invalid"
      );
    } catch {
      return false;
    }
  }

  try {
    const url = new URL(value);
    return url.protocol === "https:" && !url.username && !url.password;
  } catch {
    return false;
  }
}

function isPlainObject(value) {
  if (!value || typeof value !== "object" || Array.isArray(value)) {
    return false;
  }

  const prototype = Object.getPrototypeOf(value);
  return prototype === Object.prototype || prototype === null;
}

function isNonEmptyString(value) {
  return typeof value === "string" && value.trim().length > 0;
}

function isBoundedString(value, minLength, maxLength) {
  return (
    typeof value === "string" &&
    value.trim().length >= minLength &&
    value.length <= maxLength
  );
}

export function themeSettingValue(name, value) {
  if (name === "navigation_items" && Array.isArray(value)) {
    return JSON.stringify(value);
  }

  if (name === "custom_font_awesome_icons" && Array.isArray(value)) {
    return value.join("|");
  }

  if (COLOR_SETTINGS.includes(name)) {
    return normalizeColorSetting(value);
  }

  return value;
}

export function normalizeColorSetting(value) {
  if (typeof value === "string" && /^[0-9a-f]{6}$/i.test(value)) {
    return `#${value.toUpperCase()}`;
  }

  if (typeof value === "string" && /^#[0-9a-f]{6}$/i.test(value)) {
    return value.toUpperCase();
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

  for (const key of COLOR_SETTINGS) {
    if (key in portable) {
      portable[key] = normalizeColorSetting(portable[key]);
    }
  }

  const bundle = {
    format: BUNDLE_FORMAT,
    version: BUNDLE_VERSION,
    metadata,
    settings: portable,
  };

  const errors = validateBundle(bundle);
  if (errors.length) {
    throw new Error(`Cannot export invalid settings: ${errors.join(" ")}`);
  }

  return bundle;
}
