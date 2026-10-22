/* global settings, themePrefix */

import Component from "@glimmer/component";
import { service } from "@ember/service";
import DMenu from "discourse/float-kit/components/d-menu";
import EmbedMode from "discourse/lib/embed-mode";
import { i18n } from "discourse-i18n";
import BrandNavigationContent from "../../components/brand-navigation-content";
import {
  arrangeNavigationItems,
  isVisibleOnDevice,
  isVisibleToUser,
} from "../../lib/brand-navigation";
import { isSafeNavigationUrl } from "../../lib/configuration-bundle";

export default class BrandNavigationMenu extends Component {
  @service capabilities;
  @service currentUser;
  @service site;

  get hasContent() {
    const hasBrand =
      settings.show_brand &&
      isSafeNavigationUrl(settings.brand_url) &&
      ((settings.brand_logo && settings.brand_presentation !== "name_only") ||
        (settings.brand_name && settings.brand_presentation !== "logo_only"));

    if (hasBrand) {
      return true;
    }

    return (
      arrangeNavigationItems(
        (settings.navigation_items || [])
          .filter(
            (item) =>
              isVisibleToUser(item, this.currentUser) &&
              isVisibleOnDevice(item, this.capabilities.isMobileDevice)
          )
          .map((item) => ({
            ...item,
            children: (item.children || []).filter(
              (child) =>
                isVisibleToUser(child, this.currentUser) &&
                isVisibleOnDevice(child, this.capabilities.isMobileDevice)
            ),
          }))
      ).length > 0
    );
  }

  get shouldRender() {
    return (
      !EmbedMode.enabled &&
      this.site.mobileView &&
      settings.mobile_mode === "menu" &&
      this.hasContent
    );
  }

  <template>
    {{#if this.shouldRender}}
      <DMenu
        @icon="bars"
        @title={{i18n (themePrefix "brand_navigation.open_menu")}}
        id="brand-navigation-menu"
        class="brand-navigation-menu btn-flat"
      >
        <:content>
          <div class="brand-navigation brand-navigation--menu">
            <BrandNavigationContent />
          </div>
        </:content>
      </DMenu>
    {{/if}}
  </template>
}
