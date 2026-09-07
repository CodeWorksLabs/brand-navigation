import { REPLACEMENTS } from "discourse/lib/icon-library";
import { isSafeNavigationUrl } from "./configuration-bundle";

const PRIMARY_SPRITE_SELECTOR = "#svg-sprites .fontawesome";

export function isVisibleToUser(item, currentUser) {
  switch (item.visibility) {
    case "anonymous":
      return !currentUser;
    case "authenticated":
      return Boolean(currentUser);
    default:
      return true;
  }
}

export function isVisibleOnDevice(item, mobileDevice) {
  switch (item.device_visibility) {
    case "desktop":
      return !mobileDevice;
    case "mobile":
      return Boolean(mobileDevice);
    default:
      return true;
  }
}

export function linkRel(target) {
  return target === "_blank" ? "noopener noreferrer" : null;
}

export function linkTarget(target) {
  return target === "_blank" ? "_blank" : "_self";
}

export function resolvedIconId(icon) {
  return REPLACEMENTS[icon] || icon;
}

export function hasSpriteSymbol(icon, documentObject = globalThis.document) {
  if (!icon || !documentObject) {
    return false;
  }

  return Boolean(
    documentObject
      .querySelector(PRIMARY_SPRITE_SELECTOR)
      ?.querySelector(`symbol[id="${CSS.escape(icon)}"]`)
  );
}

export function isPrimarySpriteReady(documentObject = globalThis.document) {
  return Boolean(
    documentObject
      ?.querySelector(PRIMARY_SPRITE_SELECTOR)
      ?.querySelector("symbol[id]")
  );
}

export class PrimarySpriteWatcher {
  callbacks = new Set();
  observer = null;

  constructor(
    documentObject = globalThis.document,
    Observer = globalThis.MutationObserver
  ) {
    this.document = documentObject;
    this.Observer = Observer;
  }

  subscribe(callback) {
    if (!this.document || isPrimarySpriteReady(this.document)) {
      callback();
      return () => {};
    }

    this.callbacks.add(callback);
    this.startObserving();

    return () => {
      this.callbacks.delete(callback);
      if (this.callbacks.size === 0) {
        this.stopObserving();
      }
    };
  }

  startObserving() {
    if (this.observer || !this.Observer) {
      return;
    }

    this.observer = new this.Observer(() => this.spriteChanged());
    this.observer.observe(this.document.documentElement, {
      childList: true,
      subtree: true,
    });
  }

  spriteChanged() {
    if (!isPrimarySpriteReady(this.document)) {
      return;
    }

    const callbacks = [...this.callbacks];
    this.callbacks.clear();
    this.stopObserving();
    callbacks.forEach((callback) => callback());
  }

  stopObserving() {
    this.observer?.disconnect();
    this.observer = null;
  }
}

export const primarySpriteWatcher = new PrimarySpriteWatcher();

export function isUsableIcon(icon, iconExists = hasSpriteSymbol) {
  if (!icon) {
    return false;
  }

  return Boolean(iconExists(resolvedIconId(icon)));
}

export function shouldRenderHeaderIcon({
  item,
  enabled,
  embedMode,
  mobileView,
  mobileMode,
  currentUser,
  mobileDevice,
  iconExists = hasSpriteSymbol,
}) {
  return (
    enabled &&
    !embedMode &&
    !(mobileView && mobileMode === "hidden") &&
    item.link_mode !== "group" &&
    Boolean(item.url) &&
    isUsableIcon(item.icon, iconExists) &&
    !(item.children || []).length &&
    isVisibleToUser(item, currentUser) &&
    isVisibleOnDevice(item, mobileDevice) &&
    isSafeNavigationUrl(item.url)
  );
}

export function arrangeNavigationItems(items, iconExists = hasSpriteSymbol) {
  const preparedItems = items
    .filter((item) => (item.surface || "bar") === "bar")
    .map((item, index) =>
      prepareNavigationItem(item, `item-${index}`, iconExists)
    )
    .filter((item) => item.url || item.children.length);
  const leftItems = preparedItems.filter((item) => item.section !== "right");
  const rightItems = preparedItems.filter((item) => item.section === "right");

  return [
    ...leftItems.map((item) => ({
      ...item,
      itemClass: "brand-navigation__item",
    })),
    ...rightItems.map((item, index) => ({
      ...item,
      itemClass: `brand-navigation__item brand-navigation__item--right${
        index === 0 ? " brand-navigation__item--right-start" : ""
      }`,
    })),
  ];
}

export function prepareNavigationItem(
  item,
  path = "item",
  iconExists = hasSpriteSymbol
) {
  const presentation = item.presentation || "icon_and_label";
  const showIcon =
    isUsableIcon(item.icon, iconExists) && presentation !== "label_only";
  const showLabel = presentation !== "icon_only" || !showIcon;
  const children = (item.children || [])
    .map((child, index) =>
      prepareNavigationItem(child, `${path}-child-${index}`, iconExists)
    )
    .filter((child) => child.url);
  const linkMode = item.link_mode || (item.url ? "link" : "group");

  return {
    ...item,
    linkMode,
    url:
      linkMode === "group"
        ? null
        : isSafeNavigationUrl(item.url)
          ? item.url
          : null,
    target: linkTarget(item.target),
    presentation,
    showIcon,
    showLabel,
    showDescription: showLabel && Boolean(item.description),
    descriptionId: `brand-navigation-description-${path}`,
    children,
    hasVisibleDescriptions: children.some((child) => child.showDescription),
  };
}
