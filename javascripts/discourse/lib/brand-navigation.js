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

export function linkRel(target) {
  return target === "_blank" ? "noopener noreferrer" : null;
}

export function arrangeNavigationItems(items) {
  const preparedItems = items.map(prepareNavigationItem);
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

function prepareNavigationItem(item) {
  const presentation = item.presentation || "icon_and_label";
  const showIcon = Boolean(item.icon) && presentation !== "label_only";

  return {
    ...item,
    presentation,
    showIcon,
    showLabel: presentation !== "icon_only" || !showIcon,
    children: (item.children || []).map(prepareNavigationItem),
  };
}
