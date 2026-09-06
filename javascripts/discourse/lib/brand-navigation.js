import { isSafeNavigationUrl } from "./configuration-bundle";

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

export function arrangeNavigationItems(items) {
  const preparedItems = items
    .filter((item) => (item.surface || "bar") === "bar")
    .map((item, index) => prepareNavigationItem(item, `item-${index}`))
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

export function prepareNavigationItem(item, path = "item") {
  const presentation = item.presentation || "icon_and_label";
  const showIcon = Boolean(item.icon) && presentation !== "label_only";
  const showLabel = presentation !== "icon_only" || !showIcon;
  const children = (item.children || [])
    .map((child, index) =>
      prepareNavigationItem(child, `${path}-child-${index}`)
    )
    .filter((child) => child.url);

  return {
    ...item,
    url: isSafeNavigationUrl(item.url) ? item.url : null,
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
