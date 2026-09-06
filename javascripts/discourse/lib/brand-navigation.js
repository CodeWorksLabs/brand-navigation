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

export function isVisibleOnDevice(item, mobileView) {
  switch (item.device_visibility) {
    case "desktop":
      return !mobileView;
    case "mobile":
      return Boolean(mobileView);
    default:
      return true;
  }
}

export function linkRel(target) {
  return target === "_blank" ? "noopener noreferrer" : null;
}

export function arrangeNavigationItems(items) {
  const preparedItems = items
    .filter((item) => (item.surface || "bar") === "bar")
    .map(prepareNavigationItem);
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

export function prepareNavigationItem(item) {
  const presentation = item.presentation || "icon_and_label";
  const showIcon = Boolean(item.icon) && presentation !== "label_only";
  const showLabel = presentation !== "icon_only" || !showIcon;
  const children = (item.children || []).map(prepareNavigationItem);

  return {
    ...item,
    presentation,
    showIcon,
    showLabel,
    showDescription: showLabel && Boolean(item.description),
    children,
    hasVisibleDescriptions: children.some((child) => child.showDescription),
  };
}
