import Component from "@glimmer/component";
import { service } from "@ember/service";
import DMenu from "discourse/float-kit/components/d-menu";
import { i18n } from "discourse-i18n";
import BrandNavigationContent from "../../components/brand-navigation-content";
import { isSiteHeaderVisible } from "../../lib/brand-navigation";

export default class BrandNavigationMenu extends Component {
  @service site;

  get shouldRender() {
    return (
      settings.enabled &&
      isSiteHeaderVisible(this) &&
      this.site.mobileView &&
      settings.mobile_mode === "menu"
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
