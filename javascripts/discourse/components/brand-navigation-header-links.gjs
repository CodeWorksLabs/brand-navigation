/* global settings */

import Component from "@glimmer/component";
import { service } from "@ember/service";
import EmbedMode from "discourse/lib/embed-mode";
import {
  headerItemsForAlignment,
  shouldRenderHeaderIcon,
} from "../lib/brand-navigation";
import BrandNavigationHeaderIcon from "./brand-navigation-header-icon";

export default class BrandNavigationHeaderLinks extends Component {
  @service capabilities;
  @service currentUser;
  @service site;

  get alignment() {
    return this.args.alignment === "right" ? "right" : "left";
  }

  get listClass() {
    return `brand-navigation-header-links brand-navigation-header-links--${this.alignment}`;
  }

  get items() {
    return headerItemsForAlignment(
      settings.navigation_items || [],
      this.alignment
    ).filter((item) =>
      shouldRenderHeaderIcon({
        item,
        embedMode: EmbedMode.enabled,
        mobileView: this.site.mobileView,
        mobileMode: settings.mobile_mode,
        currentUser: this.currentUser,
        mobileDevice: this.capabilities.isMobileDevice,
        // The shared link component handles sprite readiness and cleanup.
        iconExists: () => true,
      })
    );
  }

  <template>
    {{#if this.items.length}}
      <ul class={{this.listClass}}>
        {{#each this.items as |item|}}
          <BrandNavigationHeaderIcon @item={{item}} />
        {{/each}}
      </ul>
    {{/if}}
  </template>
}

export function headerLinksFor(alignment) {
  return <template>
    <BrandNavigationHeaderLinks @alignment={{alignment}} />
  </template>;
}
