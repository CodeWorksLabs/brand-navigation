import Component from "@glimmer/component";
import { service } from "@ember/service";
import dIcon from "discourse/helpers/d-icon";
import { isSafeNavigationUrl } from "../lib/configuration-bundle";
import {
  isSiteHeaderVisible,
  isVisibleOnDevice,
  isVisibleToUser,
  linkRel,
  linkTarget,
} from "../lib/brand-navigation";

export default class BrandNavigationHeaderIcon extends Component {
  @service capabilities;
  @service currentUser;
  @service site;

  get item() {
    return this.args.item;
  }

  get shouldRender() {
    const item = this.item;

    return (
      settings.enabled &&
      isSiteHeaderVisible(this) &&
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
    return linkTarget(this.item.target);
  }

  get title() {
    return this.item.title || this.item.label;
  }

  <template>
    {{#if this.shouldRender}}
      <li class="brand-navigation-header-icon">
        <a
          class="btn no-text icon btn-flat"
          href={{this.item.url}}
          target={{this.target}}
          rel={{this.rel}}
          title={{this.title}}
          aria-label={{this.item.label}}
        >
          {{dIcon this.item.icon}}
        </a>
      </li>
    {{/if}}
  </template>
}
