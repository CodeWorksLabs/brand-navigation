import Component from "@glimmer/component";
import { service } from "@ember/service";
import { isSiteHeaderVisible } from "../lib/brand-navigation";
import BrandNavigationContent from "./brand-navigation-content";

export default class BrandNavigationBar extends Component {
  @service site;

  get shouldRender() {
    if (!settings.enabled || !isSiteHeaderVisible(this)) {
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
