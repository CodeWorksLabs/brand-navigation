import Component from "@glimmer/component";
import { registerDestructor } from "@ember/destroyable";
import { scheduleOnce } from "@ember/runloop";
import { service } from "@ember/service";
import { tracked } from "@glimmer/tracking";
import dIcon from "discourse/helpers/d-icon";
import EmbedMode from "discourse/lib/embed-mode";
import {
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
      scheduleOnce("afterRender", this, () => {
        if (!this.destroyed) {
          this.iconRevision++;
        }
      });
    });
  }

  get shouldRender() {
    this.iconRevision;

    const item = this.args.item;
    const context = {
      item,
      enabled: settings.enabled,
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

    this.updatePrimarySpriteSubscription(isEligible);

    return isEligible && shouldRenderHeaderIcon(context);
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

export function headerIconFor(item) {
  return <template><BrandNavigationHeaderIcon @item={{item}} /></template>;
}
