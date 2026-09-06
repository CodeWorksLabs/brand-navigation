import Component from "@glimmer/component";
import { service } from "@ember/service";
import dIcon from "discourse/helpers/d-icon";
import EmbedMode from "discourse/lib/embed-mode";
import { isSafeNavigationUrl } from "../lib/configuration-bundle";
import {
  isVisibleOnDevice,
  isVisibleToUser,
  linkRel,
  linkTarget,
} from "../lib/brand-navigation";

export default class BrandNavigationHeaderIcon extends Component {
  @service capabilities;
  @service currentUser;
  @service site;

  get shouldRender() {
    const item = this.args.item;

    return (
      settings.enabled &&
      !EmbedMode.enabled &&
      !(this.site.mobileView && settings.mobile_mode === "hidden") &&
      Boolean(item.url) &&
      Boolean(item.icon) &&
      !(item.children || []).length &&
      isVisibleToUser(item, this.currentUser) &&
      isVisibleOnDevice(item, this.capabilities.isMobileDevice) &&
      isSafeNavigationUrl(item.url)
    );
  }

  get rel() {
    return linkRel(this.target);
  }

  get target() {
    return linkTarget(this.args.item.target);
  }

  get title() {
    return this.args.item.title || this.args.item.label;
  }

  <template>
    {{#if this.shouldRender}}
      <li class="brand-navigation-header-icon">
        <a
          class="btn no-text icon btn-flat"
          href={{@item.url}}
          target={{this.target}}
          rel={{this.rel}}
          title={{this.title}}
          aria-label={{@item.label}}
        >
          {{dIcon @item.icon}}
        </a>
      </li>
    {{/if}}
  </template>
}
