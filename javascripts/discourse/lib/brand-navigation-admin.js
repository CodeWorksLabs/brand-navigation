export function isBrandNavigationObjectsEditor(args) {
  return (
    args?.setting?.setting === "navigation_items" &&
    args?.schema?.name === "navigation_item"
  );
}
