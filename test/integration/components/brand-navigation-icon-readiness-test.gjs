/* global settings */

import { tracked } from "@glimmer/tracking";
import Service from "@ember/service";
import { clearRender, render, settled } from "@ember/test-helpers";
import { module, test } from "qunit";
import { setupRenderingTest } from "discourse/tests/helpers/component-test";
import BrandNavigationContent from "../../../discourse/components/brand-navigation-content";
import BrandNavigationHeaderIcon from "../../../discourse/components/brand-navigation-header-icon";
import { primarySpriteWatcher } from "../../../discourse/lib/brand-navigation";

class TestState {
  @tracked showDisposable = true;
}

class TestSiteService extends Service {
  @tracked mobileView = true;
}

module(
  "Integration | Component | Brand Navigation icon readiness",
  function (hooks) {
    setupRenderingTest(hooks);

    test("recovers after delayed primary-sprite loading and unsubscribes destroyed consumers", async function (assert) {
      const spriteContainer = document.querySelector("#svg-sprites");
      const primarySprite = spriteContainer.querySelector(".fontawesome");
      const originalSprite = primarySprite.innerHTML;
      const originalItems = settings.navigation_items;
      const originalEnabled = settings.enabled;
      this.state = new TestState();
      this.headerItem = {
        label: "Header",
        url: "/header",
        icon: "d-tracking",
        visibility: "everyone",
      };
      this.missingHeaderItem = {
        label: "Missing header",
        url: "/missing-header",
        icon: "brand-navigation-missing",
        visibility: "everyone",
      };
      this.disposableItem = {
        label: "Disposable",
        url: "/disposable",
        icon: "d-tracking",
        visibility: "everyone",
      };

      primarySprite.innerHTML = "";
      settings.enabled = true;
      settings.navigation_items = [
        {
          label: "Replacement bar",
          url: "/replacement",
          icon: "d-tracking",
          presentation: "icon_only",
          visibility: "everyone",
        },
        {
          label: "Missing bar",
          url: "/missing",
          icon: "brand-navigation-missing",
          presentation: "icon_only",
          visibility: "everyone",
        },
        {
          label: "Resources",
          link_mode: "group",
          visibility: "everyone",
          children: [
            {
              label: "Replacement child",
              url: "/child",
              icon: "d-tracking",
              presentation: "icon_only",
              visibility: "everyone",
            },
          ],
        },
      ];

      try {
        await render(
          <template>
            <BrandNavigationContent />
            <BrandNavigationHeaderIcon @item={{this.headerItem}} />
            <BrandNavigationHeaderIcon @item={{this.missingHeaderItem}} />
            {{#if this.state.showDisposable}}
              <BrandNavigationHeaderIcon @item={{this.disposableItem}} />
            {{/if}}
          </template>
        );

        assert.dom('a[href="/replacement"] span').hasText("Replacement bar");
        assert.dom('a[href="/missing"] span').hasText("Missing bar");
        assert
          .dom('.brand-navigation-header-icon a[href="/header"]')
          .doesNotExist();
        assert.strictEqual(
          primarySpriteWatcher.callbacks.size,
          4,
          "one content and three header consumers share one observer"
        );
        assert.notStrictEqual(primarySpriteWatcher.observer, null);

        this.state.showDisposable = false;
        await settled();
        assert.strictEqual(
          primarySpriteWatcher.callbacks.size,
          3,
          "a destroyed consumer removes its subscription"
        );

        primarySprite.innerHTML = '<svg><symbol id="bell"></symbol></svg>';
        await settled();

        assert.dom('a[href="/replacement"] .d-icon-d-tracking').exists();
        assert.dom('a[href="/replacement"] span').doesNotExist();
        assert.dom('a[href="/missing"] span').hasText("Missing bar");
        assert.dom('a[href="/child"] .d-icon-d-tracking').exists();
        assert.dom('a[href="/child"] span').doesNotExist();
        assert.dom('.brand-navigation-header-icon a[href="/header"]').exists();
        assert
          .dom('.brand-navigation-header-icon a[href="/missing-header"]')
          .doesNotExist();
        assert.strictEqual(primarySpriteWatcher.callbacks.size, 0);
        assert.strictEqual(primarySpriteWatcher.observer, null);
      } finally {
        await clearRender();
        settings.navigation_items = originalItems;
        settings.enabled = originalEnabled;
        primarySprite.innerHTML = originalSprite;
      }
    });

    test("subscribes when a retained header icon becomes eligible before sprite readiness", async function (assert) {
      const spriteContainer = document.querySelector("#svg-sprites");
      const primarySprite = spriteContainer.querySelector(".fontawesome");
      const originalSprite = primarySprite.innerHTML;
      const originalEnabled = settings.enabled;
      const originalMobileMode = settings.mobile_mode;

      this.owner.register("service:site", TestSiteService);
      this.site = this.owner.lookup("service:site");
      this.headerItem = {
        label: "Transitioning header",
        url: "/transitioning-header",
        icon: "d-tracking",
        visibility: "everyone",
      };

      primarySprite.innerHTML = "";
      settings.enabled = true;
      settings.mobile_mode = "hidden";

      try {
        await render(
          <template>
            <BrandNavigationHeaderIcon @item={{this.headerItem}} />
          </template>
        );

        assert
          .dom('.brand-navigation-header-icon a[href="/transitioning-header"]')
          .doesNotExist();
        assert.strictEqual(
          primarySpriteWatcher.callbacks.size,
          0,
          "an initially ineligible retained component does not subscribe"
        );

        this.site.mobileView = false;
        await settled();

        assert.strictEqual(
          primarySpriteWatcher.callbacks.size,
          1,
          "the newly eligible retained component subscribes before readiness"
        );
        assert.notStrictEqual(primarySpriteWatcher.observer, null);

        primarySprite.innerHTML = '<svg><symbol id="bell"></symbol></svg>';
        await settled();

        assert
          .dom('.brand-navigation-header-icon a[href="/transitioning-header"]')
          .exists();
        assert.strictEqual(primarySpriteWatcher.callbacks.size, 0);
        assert.strictEqual(primarySpriteWatcher.observer, null);
      } finally {
        await clearRender();
        settings.enabled = originalEnabled;
        settings.mobile_mode = originalMobileMode;
        primarySprite.innerHTML = originalSprite;
      }
    });
  }
);
