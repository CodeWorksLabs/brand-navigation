import EmbedMode from "discourse/lib/embed-mode";
import { withPluginApi } from "discourse/lib/plugin-api";
import BrandNavigationBar from "../components/brand-navigation-bar";

export default {
  name: "brand-navigation",

  initialize() {
    if (!settings.enabled || EmbedMode.enabled) {
      return;
    }

    withPluginApi((api) => {
      api.renderInOutlet(settings.outlet, BrandNavigationBar);
    });
  },
};
