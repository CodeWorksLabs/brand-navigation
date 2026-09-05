import Component from "@glimmer/component";
import { service } from "@ember/service";
import DMenu from "discourse/float-kit/components/d-menu";
import EmbedMode from "discourse/lib/embed-mode";
import { i18n } from "discourse-i18n";
import BrandNavigationContent from "../../components/brand-navigation-content";

export default class BrandNavigationMenu extends Component {
  @service site;

  get shouldRender() {
    return (
      settings.enabled &&
      !EmbedMode.enabled &&
      this.site.mobileView &&
      settings.mobile_mode === "menu"
    );
  }

  <template>
    {{#if this.shouldRender}}
      <DMenu
        @icon="bars"
        @title={{i18n "brand_navigation.open_menu"}}
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
