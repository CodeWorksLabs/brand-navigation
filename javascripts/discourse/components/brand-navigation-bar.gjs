import Component from "@glimmer/component";
import { service } from "@ember/service";
import EmbedMode from "discourse/lib/embed-mode";
import BrandNavigationContent from "./brand-navigation-content";

export default class BrandNavigationBar extends Component {
  @service site;

  get shouldRender() {
    if (!settings.enabled || EmbedMode.enabled) {
      return false;
    }

    return this.site.desktopView || settings.mobile_mode === "bar";
  }

  <template>
    {{#if this.shouldRender}}
      <header class="brand-navigation" data-brand-navigation>
        <div class="wrap">
          <BrandNavigationContent />
        </div>
      </header>
    {{/if}}
  </template>
}
