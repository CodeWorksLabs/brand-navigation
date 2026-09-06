import Component from "@glimmer/component";
import { service } from "@ember/service";
import dIcon from "discourse/helpers/d-icon";
import EmbedMode from "discourse/lib/embed-mode";
import {
  isVisibleOnDevice,
  isVisibleToUser,
  linkRel,
} from "../lib/brand-navigation";

export default class BrandNavigationHeaderIcon extends Component {
  @service currentUser;
  @service site;

  get shouldRender() {
    const item = this.args.item;

    return (
      settings.enabled &&
      !EmbedMode.enabled &&
      Boolean(item.url) &&
      Boolean(item.icon) &&
      !(item.children || []).length &&
      isVisibleToUser(item, this.currentUser) &&
      isVisibleOnDevice(item, this.site.mobileView)
    );
  }

  get rel() {
    return linkRel(this.args.item.target);
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
          target={{@item.target}}
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
