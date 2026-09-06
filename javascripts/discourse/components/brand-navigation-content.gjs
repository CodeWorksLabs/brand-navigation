import Component from "@glimmer/component";
import { registerDestructor } from "@ember/destroyable";
import { on } from "@ember/modifier";
import { action } from "@ember/object";
import { service } from "@ember/service";
import LightDarkImg from "discourse/components/light-dark-img";
import dIcon from "discourse/helpers/d-icon";
import { i18n } from "discourse-i18n";
import {
  arrangeNavigationItems,
  isVisibleOnDevice,
  isVisibleToUser,
  linkRel,
} from "../lib/brand-navigation";

export default class BrandNavigationContent extends Component {
  @service currentUser;
  @service site;
  @service siteSettings;

  openSubmenus = new Set();

  handleDocumentClick = (event) => {
    const clickedInsideOpenSubmenu = [...this.openSubmenus].some((submenu) =>
      submenu.contains(event.target)
    );

    if (!clickedInsideOpenSubmenu) {
      this.closeSubmenus();
    }
  };

  handleDocumentKeydown = (event) => {
    if (event.key !== "Escape" || this.openSubmenus.size === 0) {
      return;
    }

    const [submenu] = this.openSubmenus;
    this.closeSubmenus();
    submenu.querySelector("summary")?.focus();
    event.preventDefault();
  };

  constructor(owner, args) {
    super(owner, args);

    if (typeof document === "undefined") {
      return;
    }

    document.addEventListener("click", this.handleDocumentClick, true);
    document.addEventListener("keydown", this.handleDocumentKeydown);

    registerDestructor(this, () => {
      document.removeEventListener("click", this.handleDocumentClick, true);
      document.removeEventListener("keydown", this.handleDocumentKeydown);
      this.openSubmenus.clear();
    });
  }

  closeSubmenus(except) {
    for (const submenu of this.openSubmenus) {
      if (submenu !== except) {
        submenu.open = false;
        this.openSubmenus.delete(submenu);
      }
    }
  }

  @action
  submenuToggled(event) {
    const submenu = event.currentTarget;

    if (submenu.open) {
      this.closeSubmenus(submenu);
      this.openSubmenus.add(submenu);
    } else {
      this.openSubmenus.delete(submenu);
    }
  }

  @action
  submenuLinkSelected() {
    this.closeSubmenus();
  }

  get visibleItems() {
    return arrangeNavigationItems(
      (settings.navigation_items || [])
        .filter(
          (item) =>
            isVisibleToUser(item, this.currentUser) &&
            isVisibleOnDevice(item, this.site.mobileView)
        )
        .map((item) => ({
          ...item,
          children: (item.children || []).filter(
            (child) =>
              isVisibleToUser(child, this.currentUser) &&
              isVisibleOnDevice(child, this.site.mobileView)
          ),
        }))
    );
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
          aria-label={{i18n (themePrefix "brand_navigation.navigation_label")}}
        >
          <ul class="brand-navigation__items">
            {{#each this.visibleItems as |item|}}
              <li class={{item.itemClass}}>
                {{#if item.children.length}}
                  <div
                    class={{if
                      item.url
                      "brand-navigation__submenu-group brand-navigation__submenu-group--linked"
                      "brand-navigation__submenu-group"
                    }}
                  >
                    {{#if item.url}}
                      <a
                        class="brand-navigation__parent-link"
                        href={{item.url}}
                        target={{item.target}}
                        rel={{this.linkRel item.target}}
                        aria-label={{item.label}}
                        title={{item.title}}
                      >
                        {{#if item.showIcon}}{{dIcon item.icon}}{{/if}}
                        {{#if item.showLabel}}<span>{{item.label}}</span>{{/if}}
                      </a>
                    {{/if}}
                    <details
                      class="brand-navigation__submenu"
                      {{on "toggle" this.submenuToggled}}
                    >
                      <summary
                        class={{if item.url "brand-navigation__submenu-toggle"}}
                        aria-label={{if
                          item.url
                          (i18n
                            (themePrefix "brand_navigation.open_submenu")
                            label=item.label
                          )
                          item.label
                        }}
                        title={{item.title}}
                      >
                        {{#unless item.url}}
                          {{#if item.showIcon}}{{dIcon item.icon}}{{/if}}
                          {{#if item.showLabel}}<span
                            >{{item.label}}</span>{{/if}}
                        {{/unless}}
                        {{dIcon "caret-down"}}
                      </summary>
                      <ul
                        class={{if
                          item.hasVisibleDescriptions
                          "brand-navigation__submenu-list--described"
                        }}
                      >
                        {{#each item.children as |child|}}
                          <li>
                            {{! Native details allows links after its summary. }}
                            {{! template-lint-disable no-nested-interactive }}
                            <a
                              href={{child.url}}
                              target={{child.target}}
                              rel={{this.linkRel child.target}}
                              aria-label={{child.label}}
                              title={{child.title}}
                              {{on "click" this.submenuLinkSelected}}
                            >
                              {{#if child.showIcon}}{{dIcon child.icon}}{{/if}}
                              {{#if child.showLabel}}
                                <span class="brand-navigation__child-content">
                                  <span
                                    class="brand-navigation__child-label"
                                  >{{child.label}}</span>
                                  {{#if child.showDescription}}
                                    <span
                                      class="brand-navigation__child-description"
                                    >{{child.description}}</span>
                                  {{/if}}
                                </span>
                              {{/if}}
                            </a>
                            {{! template-lint-enable no-nested-interactive }}
                          </li>
                        {{/each}}
                      </ul>
                    </details>
                  </div>
                {{else if item.url}}
                  <a
                    href={{item.url}}
                    target={{item.target}}
                    rel={{this.linkRel item.target}}
                    aria-label={{item.label}}
                    title={{item.title}}
                  >
                    {{#if item.showIcon}}{{dIcon item.icon}}{{/if}}
                    {{#if item.showLabel}}<span>{{item.label}}</span>{{/if}}
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
