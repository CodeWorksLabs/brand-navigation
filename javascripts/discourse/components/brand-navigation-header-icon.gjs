/* global settings */

import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { registerDestructor } from "@ember/destroyable";
import { scheduleOnce } from "@ember/runloop";
import { service } from "@ember/service";
import dIcon from "discourse/helpers/d-icon";
import EmbedMode from "discourse/lib/embed-mode";
import {
  headerLinkPresentation,
  linkRel,
  linkTarget,
  primarySpriteWatcher,
  shouldRenderHeaderIcon,
} from "../lib/brand-navigation";

export default class BrandNavigationHeaderIcon extends Component {
  @service capabilities;
  @service currentUser;
  @service site;

  @tracked iconRevision = 0;
  destroyed = false;
  unsubscribeFromPrimarySprite = null;

  constructor(owner, args) {
    super(owner, args);

    registerDestructor(this, () => {
      this.destroyed = true;
      this.unsubscribeFromPrimarySprite?.();
    });
  }

  updatePrimarySpriteSubscription(isEligible) {
    if (!isEligible) {
      this.unsubscribeFromPrimarySprite?.();
      this.unsubscribeFromPrimarySprite = null;
      return;
    }

    if (this.unsubscribeFromPrimarySprite) {
      return;
    }

    this.unsubscribeFromPrimarySprite = primarySpriteWatcher.subscribe(() => {
      scheduleOnce("afterRender", this, this.refreshIconRevision);
    });
  }

  refreshIconRevision() {
    if (!this.destroyed) {
      this.iconRevision++;
    }
  }

  get shouldRender() {
    this.iconRevision;

    const item = this.args.item;
    const context = {
      item,
      embedMode: EmbedMode.enabled,
      mobileView: this.site.mobileView,
      mobileMode: settings.mobile_mode,
      currentUser: this.currentUser,
      mobileDevice: this.capabilities.isMobileDevice,
    };
    const isEligible = shouldRenderHeaderIcon({
      ...context,
      iconExists: () => true,
    });

    this.updatePrimarySpriteSubscription(
      isEligible &&
        Boolean(item.icon) &&
        item.header_presentation !== "label_only"
    );

    return isEligible && shouldRenderHeaderIcon(context);
  }

  get presentation() {
    this.iconRevision;
    return headerLinkPresentation(this.args.item);
  }

  get linkClass() {
    return this.presentation.showLabel
      ? "btn icon btn-flat brand-navigation-header-link--with-text"
      : "btn no-text icon btn-flat";
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
      <li class="brand-navigation-header-icon brand-navigation-header-link">
        <a
          class={{this.linkClass}}
          href={{@item.url}}
          target={{this.target}}
          rel={{this.rel}}
          title={{this.title}}
          aria-label={{@item.label}}
        >
          {{#if this.presentation.showIcon}}
            {{dIcon @item.icon}}
          {{/if}}
          {{#if this.presentation.showLabel}}
            <span
              class="brand-navigation-header-link__label"
            >{{@item.label}}</span>
          {{/if}}
        </a>
      </li>
    {{/if}}
  </template>
}

export function headerIconFor(item) {
  return <template><BrandNavigationHeaderIcon @item={{item}} /></template>;
}
