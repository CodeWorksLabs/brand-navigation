import Component from "@glimmer/component";
import { service } from "@ember/service";
import LightDarkImg from "discourse/components/light-dark-img";
import dIcon from "discourse/helpers/d-icon";
import { isVisibleToUser, linkRel } from "../lib/brand-navigation";

export default class BrandNavigationContent extends Component {
  @service currentUser;
  @service siteSettings;

  get visibleItems() {
    return (settings.navigation_items || [])
      .filter((item) => isVisibleToUser(item, this.currentUser))
      .map((item) => ({
        ...item,
        children: (item.children || []).filter((child) =>
          isVisibleToUser(child, this.currentUser)
        ),
      }));
  }

  get hasBrandLogo() {
    return Boolean(settings.brand_logo);
  }

  get showBrandLogo() {
    return this.hasBrandLogo && settings.brand_presentation !== "name_only";
  }

  get showBrandName() {
    return (
      Boolean(settings.brand_name) &&
      settings.brand_presentation !== "logo_only"
    );
  }

  get shouldShowBrand() {
    return settings.show_brand && (this.showBrandLogo || this.showBrandName);
  }

  get brandLabel() {
    return settings.brand_name || this.siteSettings.title;
  }

  get lightLogo() {
    return { url: settings.brand_logo || "" };
  }

  get darkLogo() {
    return { url: settings.brand_logo_dark || settings.brand_logo || "" };
  }

  linkRel(target) {
    return linkRel(target);
  }

  <template>
    <div class="brand-navigation__content">
      {{#if this.shouldShowBrand}}
        <a
          class="brand-navigation__brand"
          href={{settings.brand_url}}
          target={{settings.brand_target}}
          rel={{this.linkRel settings.brand_target}}
          aria-label={{this.brandLabel}}
        >
          {{#if this.showBrandLogo}}
            <LightDarkImg
              class="brand-navigation__logo"
              @lightImg={{this.lightLogo}}
              @darkImg={{this.darkLogo}}
              alt=""
            />
          {{/if}}
          {{#if this.showBrandName}}
            <span class="brand-navigation__name">{{settings.brand_name}}</span>
          {{/if}}
        </a>
      {{/if}}

      {{#if this.visibleItems.length}}
        <nav
          class="brand-navigation__nav"
          aria-label={{i18n "brand_navigation.navigation_label"}}
        >
          <ul class="brand-navigation__items">
            {{#each this.visibleItems as |item|}}
              <li class="brand-navigation__item">
                {{#if item.children.length}}
                  <details class="brand-navigation__submenu">
                    <summary title={{item.title}}>
                      {{#if item.icon}}{{dIcon item.icon}}{{/if}}
                      <span>{{item.label}}</span>
                      {{dIcon "caret-down"}}
                    </summary>
                    <ul>
                      {{#each item.children as |child|}}
                        <li>
                          {{! Native details allows links after its summary. }}
                          {{! template-lint-disable no-nested-interactive }}
                          <a
                            href={{child.url}}
                            target={{child.target}}
                            rel={{this.linkRel child.target}}
                            title={{child.title}}
                          >
                            {{#if child.icon}}{{dIcon child.icon}}{{/if}}
                            <span>{{child.label}}</span>
                          </a>
                          {{! template-lint-enable no-nested-interactive }}
                        </li>
                      {{/each}}
                    </ul>
                  </details>
                {{else if item.url}}
                  <a
                    href={{item.url}}
                    target={{item.target}}
                    rel={{this.linkRel item.target}}
                    title={{item.title}}
                  >
                    {{#if item.icon}}{{dIcon item.icon}}{{/if}}
                    <span>{{item.label}}</span>
                  </a>
                {{/if}}
              </li>
            {{/each}}
          </ul>
        </nav>
      {{/if}}
    </div>
  </template>
}
