/* global settings */

import EmbedMode from "discourse/lib/embed-mode";
import { withPluginApi } from "discourse/lib/plugin-api";
import BrandNavigationBar from "../components/brand-navigation-bar";
import { headerLinksFor } from "../components/brand-navigation-header-links";

export default {
  name: "brand-navigation",

  initialize() {
    if (EmbedMode.enabled) {
      return;
    }

    withPluginApi((api) => {
      api.renderInOutlet(settings.outlet, BrandNavigationBar);
      api.renderAfterWrapperOutlet("home-logo", headerLinksFor("left"));
      // Core's panel places authentication buttons before its icon list.
      // A separate native outlet keeps our links before those buttons too.
      api.renderInOutlet("before-header-panel", headerLinksFor("right"));
    });
  },
};
