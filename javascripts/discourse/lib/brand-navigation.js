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
