import EmbedMode from "discourse/lib/embed-mode";
import { withPluginApi } from "discourse/lib/plugin-api";
import BrandNavigationBar from "../components/brand-navigation-bar";
import BrandNavigationHeaderIcon from "../components/brand-navigation-header-icon";

const BEFORE_HEADER_ICONS = ["chat", "search", "hamburger", "user-menu"];

export default {
  name: "brand-navigation",

  initialize() {
    if (!settings.enabled || EmbedMode.enabled) {
      return;
    }

    withPluginApi((api) => {
      api.renderInOutlet(settings.outlet, BrandNavigationBar);

      (settings.navigation_items || []).forEach((item, index) => {
        if ((item.surface || "bar") !== "site_header") {
          return;
        }

        class ConfiguredBrandNavigationHeaderIcon extends BrandNavigationHeaderIcon {
          get item() {
            return item;
          }
        }

        api.headerIcons.add(
          `brand-navigation-${index}`,
          ConfiguredBrandNavigationHeaderIcon,
          { before: BEFORE_HEADER_ICONS }
        );
      });
    });
  },
};
