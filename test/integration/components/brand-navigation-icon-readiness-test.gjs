/* global settings */

import { tracked } from "@glimmer/tracking";
import { getOwner } from "@ember/owner";
import { clearRender, render, settled } from "@ember/test-helpers";
import { module, test } from "qunit";
import sinon from "sinon";
import { setupRenderingTest } from "discourse/tests/helpers/component-test";
import BrandNavigationContent from "../../../discourse/components/brand-navigation-content";
import BrandNavigationHeaderIcon from "../../../discourse/components/brand-navigation-header-icon";
import BrandNavigationHeaderLinks from "../../../discourse/components/brand-navigation-header-links";
import { primarySpriteWatcher } from "../../../discourse/lib/brand-navigation";

class TestState {
  @tracked showDisposable = true;
  @tracked headerItem;
}

module(
  "Integration | Component | Brand Navigation icon readiness",
  function (hooks) {
    setupRenderingTest(hooks);

    test("right header list includes legacy and explicit right items, not left items", async function (assert) {
      const originalItems = settings.navigation_items;
      settings.navigation_items = [
        {
          label: "Legacy",
          url: "/latest",
          surface: "site_header",
          header_presentation: "label_only",
        },
        {
          label: "Left",
          url: "/about",
          surface: "site_header",
          header_alignment: "left",
          header_presentation: "label_only",
        },
        {
          label: "Versions & Status",
          url: "/status",
          surface: "site_header",
          header_alignment: "right",
          header_presentation: "label_only",
        },
      ];
      try {
        await render(
          <template><BrandNavigationHeaderLinks @alignment="right" /></template>
        );
        assert
          .dom(".brand-navigation-header-links--right > li")
          .exists({ count: 2 });
        assert
          .dom(".brand-navigation-header-links--right > li:first-child a")
          .hasText("Legacy");
        assert
          .dom(".brand-navigation-header-links--right > li:last-child a")
          .hasText("Versions & Status");
        assert.dom('a[href="/about"]').doesNotExist();
        assert.dom(".brand-navigation-header-links--left").doesNotExist();
      } finally {
        await clearRender();
        settings.navigation_items = originalItems;
      }
    });

    test("left header links retain order, target, and eligibility without duplicating right or bar items", async function (assert) {
      const originalItems = settings.navigation_items;
      settings.navigation_items = [
        { label: "Bar", url: "/bar", header_alignment: "left" },
        {
          label: "Legacy right",
          url: "/right",
          surface: "site_header",
          header_presentation: "label_only",
        },
        {
          label: "Versions & Status",
          url: "/status",
          surface: "site_header",
          header_presentation: "label_only",
          header_alignment: "left",
          target: "_blank",
        },
        {
          label: "Help",
          url: "/faq",
          surface: "site_header",
          header_presentation: "label_only",
          header_alignment: "left",
          target: "_self",
        },
        {
          label: "Unsafe",
          // eslint-disable-next-line no-script-url -- negative URL-validation fixture
          url: "javascript:alert(1)",
          surface: "site_header",
          header_presentation: "label_only",
          header_alignment: "left",
        },
      ];
      try {
        await render(<template><BrandNavigationHeaderLinks /></template>);
        assert
          .dom(".brand-navigation-header-links--left > li")
          .exists({ count: 2 });
        assert
          .dom(".brand-navigation-header-links--left > li:first-child a")
          .hasText("Versions & Status")
          .hasAttribute("target", "_blank")
          .hasAttribute("rel", "noopener noreferrer");
        assert
          .dom('a[href="/faq"]')
          .hasAttribute("target", "_self")
          .doesNotHaveAttribute("rel");
        assert.dom('a[href="/bar"]').doesNotExist();
        assert.dom('a[href="/right"]').doesNotExist();
        assert.dom('a[href^="javascript:"]').doesNotExist();
      } finally {
        await clearRender();
        settings.navigation_items = originalItems;
      }
    });

    test("no left list is mounted for legacy right-only configurations", async function (assert) {
      const originalItems = settings.navigation_items;
      settings.navigation_items = [
        {
          label: "Versions & Status",
          url: "/status",
          surface: "site_header",
          header_presentation: "label_only",
        },
      ];
      try {
        await render(<template><BrandNavigationHeaderLinks /></template>);
        assert.dom(".brand-navigation-header-links--left").doesNotExist();
      } finally {
        await clearRender();
        settings.navigation_items = originalItems;
      }
    });

    test("text links render safely without sprite readiness and combined links acquire their icon", async function (assert) {
      const primarySprite = document.querySelector("#svg-sprites .fontawesome");
      const originalSprite = primarySprite.innerHTML;
      this.textItem = {
        label: "Versions & Status <script>",
        title: "Live status",
        url: "/status",
        target: "_blank",
        header_presentation: "label_only",
        icon: "d-tracking",
      };
      this.combinedItem = {
        label: "Help",
        url: "/faq",
        icon: "d-tracking",
        header_presentation: "icon_and_label",
      };
      primarySprite.innerHTML = "";
      try {
        await render(
          <template>
            <BrandNavigationHeaderIcon @item={{this.textItem}} />
            <BrandNavigationHeaderIcon @item={{this.combinedItem}} />
          </template>
        );
        assert
          .dom('a[href="/status"]')
          .hasText("Versions & Status <script>")
          .hasAttribute("aria-label", "Versions & Status <script>")
          .hasAttribute("title", "Live status")
          .hasAttribute("rel", "noopener noreferrer")
          .hasAttribute("target", "_blank")
          .doesNotHaveClass("no-text");
        assert.dom('a[href="/status"] script').doesNotExist();
        assert.dom('a[href="/status"] svg').doesNotExist();
        assert.dom('a[href="/faq"]').hasText("Help");
        assert.dom('a[href="/faq"] svg').doesNotExist();
        assert.strictEqual(
          primarySpriteWatcher.callbacks.size,
          1,
          "only the combined link waits for its optional icon"
        );
        primarySprite.innerHTML = '<svg><symbol id="bell"></symbol></svg>';
        await settled();
        assert.dom('a[href="/faq"] .d-icon-d-tracking').exists();
        assert.dom('a[href="/faq"] span').hasText("Help");
        assert.dom('a[href="/status"] svg').doesNotExist();
        assert.strictEqual(primarySpriteWatcher.callbacks.size, 0);
      } finally {
        await clearRender();
        primarySprite.innerHTML = originalSprite;
      }
    });

    test("recovers after delayed primary-sprite loading and unsubscribes destroyed consumers", async function (assert) {
      const spriteContainer = document.querySelector("#svg-sprites");
      const primarySprite = spriteContainer.querySelector(".fontawesome");
      const originalSprite = primarySprite.innerHTML;
      const originalItems = settings.navigation_items;
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
        primarySprite.innerHTML = originalSprite;
      }
    });

    test("subscribes when a retained header icon becomes eligible before sprite readiness", async function (assert) {
      const spriteContainer = document.querySelector("#svg-sprites");
      const primarySprite = spriteContainer.querySelector(".fontawesome");
      const originalSprite = primarySprite.innerHTML;
      const originalMobileMode = settings.mobile_mode;
      const mobileView = sinon.stub(
        getOwner(this).lookup("service:site"),
        "mobileView"
      );

      this.transitionState = new TestState();
      this.transitionState.headerItem = {
        label: "Transitioning header",
        url: "/transitioning-header",
        icon: "d-tracking",
        visibility: "everyone",
      };

      primarySprite.innerHTML = "";
      settings.mobile_mode = "hidden";
      mobileView.value(true);

      try {
        await render(
          <template>
            <BrandNavigationHeaderIcon
              @item={{this.transitionState.headerItem}}
            />
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

        mobileView.value(false);
        this.transitionState.headerItem = {
          ...this.transitionState.headerItem,
        };
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
        settings.mobile_mode = originalMobileMode;
        primarySprite.innerHTML = originalSprite;
      }
    });
  }
);
