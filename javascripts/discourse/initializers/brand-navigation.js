import curryComponent from "ember-curry-component";
import EmbedMode from "discourse/lib/embed-mode";
import { getOwnerWithFallback } from "discourse/lib/get-owner";
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

        api.headerIcons.add(
          `brand-navigation-${index}`,
          curryComponent(
            BrandNavigationHeaderIcon,
            { item },
            getOwnerWithFallback()
          ),
          { before: BEFORE_HEADER_ICONS }
        );
      });
    });
  },
};
