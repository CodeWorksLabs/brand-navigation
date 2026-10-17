# frozen_string_literal: true

RSpec.describe "Brand Navigation" do
  let(:theme) { upload_theme_component }

  before do
    theme.enabled = true
    theme.update_setting(:brand_name, "Example")
    theme.update_setting(:brand_url, "/latest")
    theme.update_setting(
      :navigation_items,
      [
        { label: "Latest", url: "/latest", target: "_self", visibility: "everyone" },
        {
          label: "Explore",
          url: "/categories",
          visibility: "everyone",
          children: [
            { label: "Categories", url: "/categories", target: "_self", visibility: "everyone" },
          ],
        },
      ],
    )
    theme.save!
  end

  it "renders brand, direct links, and a native submenu on normal pages" do
    visit("/")

    expect(page).to have_css("[data-brand-navigation]")
    expect(page).to have_link("Example", href: "/latest")
    expect(page).to have_link("Latest", href: "/latest")
    expect(page).to have_link("Explore", href: "/categories")
    expect(page).to have_css('details summary[aria-label="Open Explore submenu"]')
    expect(page).to have_link("Categories", href: "/categories", visible: :all)
  end

  it "does not mount the application component in embed mode" do
    theme.update_setting(
      :navigation_items,
      [
        {
          label: "Versions & Status",
          url: "/latest",
          surface: "site_header",
          header_presentation: "label_only",
        },
      ],
    )
    theme.save!
    visit("/")
    expect(page).to have_css("[data-brand-navigation]")

    expect(page).to have_css(".brand-navigation-header-link", text: "Versions & Status")

    visit("/?embed_mode=true")

    expect(page).not_to have_css("[data-brand-navigation]")
    expect(page).not_to have_css("#brand-navigation-menu")
    expect(page).not_to have_css(".brand-navigation-header-link")
  end

  shared_examples "a core-header text link" do
    it "renders a bounded keyboard-focusable text link beside the core controls" do
      theme.update_setting(
        :navigation_items,
        [
          {
            label: "Versions & Status",
            url: "/latest",
            surface: "site_header",
            header_presentation: "label_only",
            target: "_blank",
          },
        ],
      )
      theme.save!
      visit("/")

      link = find(".brand-navigation-header-links--right .brand-navigation-header-link a", text: "Versions & Status")
      expect(link["rel"]).to eq("noopener noreferrer")
      expect(link["target"]).to eq("_blank")
      expect(link["aria-label"]).to eq("Versions & Status")
      expect(link).not_to have_css("svg")
      expect(page).not_to have_css(".brand-navigation__items", text: "Versions & Status")
      expect(page).to have_css(".d-header .login-button", visible: true)
      expect(
        page.evaluate_script(
          "(() => { const controls = document.querySelectorAll('.d-header .login-button, .d-header .sign-up-button'); return controls.length > 0 && [...controls].every(control => Boolean(arguments[0].compareDocumentPosition(control) & Node.DOCUMENT_POSITION_FOLLOWING)); })()",
          link,
        ),
      ).to eq(true)
      expect(
        page.evaluate_script(
          "arguments[0].getBoundingClientRect().width <= Math.min(224, innerWidth * 0.3) + 1",
          link,
        ),
      ).to eq(true)
      expect(
        page.evaluate_script("document.documentElement.scrollWidth <= innerWidth"),
      ).to eq(true)

      link.send_keys(:tab)
      find(":focus").send_keys([:shift, :tab])
      expect(
        page.evaluate_script("document.activeElement === arguments[0]", link),
      ).to eq(true)
    end
  end

  include_examples "a core-header text link"

  context "with a mobile device", mobile: true do
    include_examples "a core-header text link"

    [320, 390].each do |width|
      it "aligns the compact menu and logo beside header controls at #{width}px" do
        theme.update_setting(:mobile_mode, "menu")
        theme.update_setting(
          :navigation_items,
          [
            { label: "Home", url: "/latest", surface: "bar" },
            {
              label: "Versions & Status",
              url: "/about",
              surface: "site_header",
              header_presentation: "label_only",
            },
          ],
        )
        theme.save!

        resize_window(width: width, height: 900) do
          visit("/")
          selectors = [
            "#brand-navigation-menu",
            ".d-header .home-logo-wrapper-outlet .title a",
            ".brand-navigation-header-links--right .brand-navigation-header-link a",
            ".d-header button.login-button",
          ]
          selectors.each { |selector| expect(page).to have_css(selector, count: 1) }

          try_until_success do
            geometry = page.evaluate_script(<<~JS, selectors)
              (() => {
                const header = document.querySelector(".d-header").getBoundingClientRect();
                return {
                  header: { top: header.top, bottom: header.bottom },
                  logoContainer: (() => {
                    const r = document.querySelector(".home-logo-wrapper-outlet").getBoundingClientRect();
                    return { left: r.left, right: r.right, top: r.top, bottom: r.bottom };
                  })(),
                  headerItem: (() => {
                    const r = document.querySelector(".brand-navigation-header-link").getBoundingClientRect();
                    return { left: r.left, right: r.right };
                  })(),
                  labelWidth: document.querySelector(".brand-navigation-header-link__label").getBoundingClientRect().width,
                  viewportWidth: innerWidth, viewportHeight: innerHeight,
                  documentWidth: document.documentElement.scrollWidth,
                  targets: arguments[0].map((selector) => {
                    const node = document.querySelector(selector);
                    const r = node.getBoundingClientRect();
                    return {
                      selector,
                      left: r.left, right: r.right, top: r.top, bottom: r.bottom,
                      width: r.width, height: r.height,
                      hits: [[.5,.5],[.25,.5],[.75,.5],[.5,.25],[.5,.75]].map(([x,y]) => {
                        const hit = document.elementFromPoint(r.left+r.width*x, r.top+r.height*y);
                        return !!hit && (hit === node || node.contains(hit));
                      })
                    };
                  })
                };
              })()
            JS

            header_top = [0, geometry.fetch("header").fetch("top")].max
            header_bottom = [
              geometry.fetch("viewportHeight"),
              geometry.fetch("header").fetch("bottom"),
            ].min
            expect(geometry.fetch("documentWidth")).to be <= width + 1
            expect(geometry.fetch("labelWidth")).to be > 0
            geometry.fetch("targets").each do |target|
              expect(target.fetch("width")).to be > 0
              expect(target.fetch("height")).to be > 0
              expect(target.fetch("left")).to be >= 0
              expect(target.fetch("right")).to be <= geometry.fetch("viewportWidth")
              expect(target.fetch("top")).to be >= header_top
              expect(target.fetch("bottom")).to be <= header_bottom
              expect(target.fetch("hits")).to all(eq(true)),
                "#{target.fetch('selector')} was clipped or covered: #{target.inspect}"
            end
            menu, logo = geometry.fetch("targets")
            header_link = geometry.fetch("targets")[2]
            header_item = geometry.fetch("headerItem")
            expect(header_link.fetch("left")).to be >= header_item.fetch("left")
            expect(header_link.fetch("right")).to be <= header_item.fetch("right")
            [menu, logo].each do |target|
              container = geometry.fetch("logoContainer")
              expect(target.fetch("left")).to be >= container.fetch("left")
              expect(target.fetch("right")).to be <= container.fetch("right")
              expect(target.fetch("top")).to be >= container.fetch("top")
              expect(target.fetch("bottom")).to be <= container.fetch("bottom")
            end
            menu_center = (menu.fetch("top") + menu.fetch("bottom")) / 2
            logo_center = (logo.fetch("top") + logo.fetch("bottom")) / 2
            expect((menu_center - logo_center).abs).to be <= 1
            separate_targets =
              menu.fetch("right") <= logo.fetch("left") ||
                logo.fetch("right") <= menu.fetch("left")
            expect(separate_targets).to eq(true)
          end

          find("#brand-navigation-menu").click
          expect(page).to have_css(".brand-navigation--menu")
          expect(page).to have_link("Home", href: "/latest", visible: true)
        end
      end
    end
  end

  [320, 390].each do |width|
    %w[en ar].each do |locale|
      it "keeps mixed compact header links clear of native controls at #{width}px in #{locale}", mobile: true do
        SiteSetting.default_locale = locale
        SiteSetting.title = "CWL"
        theme.update_setting(:mobile_mode, "menu")
        theme.update_setting(
          :navigation_items,
          [
            { label: "Home", url: "/latest", surface: "bar" },
            {
              label: "Home",
              url: "/about",
              surface: "site_header",
              header_alignment: "left",
              header_presentation: "label_only",
              target: "_blank",
            },
            {
              label: "Versions & Status",
              url: "/latest",
              surface: "site_header",
              header_alignment: "right",
              header_presentation: "icon_and_label",
              icon: "circle-info",
              target: "_self",
            },
          ],
        )
        theme.save!

        resize_window(width: width, height: 900) do
          visit("/")
          selectors = [
            "#brand-navigation-menu",
            ".d-header .home-logo-wrapper-outlet .title a",
            ".brand-navigation-header-links--left a",
            ".brand-navigation-header-links--right a",
          ]
          selectors.each { |selector| expect(page).to have_css(selector, count: 1) }
          expect(page).to have_css(".d-header button.login-button", count: 1)
          expect(page).to have_css(".brand-navigation-header-links--right a svg", count: 1)
          expect(page.evaluate_script("getComputedStyle(document.documentElement).direction")).to eq(locale == "ar" ? "rtl" : "ltr")

          try_until_success do
            geometry = page.evaluate_script(<<~JS, selectors)
              (() => {
                const rect = (node) => {
                  const r = node.getBoundingClientRect();
                  return {left:r.left,right:r.right,top:r.top,bottom:r.bottom,width:r.width,height:r.height};
                };
                const visible = (node) => {
                  const r = node.getBoundingClientRect();
                  return r.width > 0 && r.height > 0 && getComputedStyle(node).visibility !== "hidden";
                };
                const right = document.querySelector(".brand-navigation-header-links--right a");
                const controls = [...document.querySelectorAll(".d-header .panel button")].filter(visible);
                const targets = [...arguments[0].map(s => document.querySelector(s)), ...controls];
                return {
                  viewport:innerWidth, documentWidth:document.documentElement.scrollWidth,
                  header:rect(document.querySelector(".d-header")),
                  logoContainer:rect(document.querySelector(".home-logo-wrapper-outlet")),
                  rightContainer:rect(document.querySelector(".before-header-panel-outlet")),
                  labelWidth:document.querySelector(".brand-navigation-header-links--right .brand-navigation-header-link__label").getBoundingClientRect().width,
                  auth:[...document.querySelectorAll(".d-header .auth-buttons button")].filter(visible).map(rect),
                  beforeAuth:[...document.querySelectorAll(".d-header .auth-buttons button")].every(n => Boolean(right.compareDocumentPosition(n) & Node.DOCUMENT_POSITION_FOLLOWING)),
                  targets:targets.map(node => ({...rect(node), hits:[[.5,.5],[.25,.5],[.75,.5],[.5,.25],[.5,.75]].map(([x,y]) => {
                    const r = node.getBoundingClientRect();
                    const hit = document.elementFromPoint(r.left+r.width*x,r.top+r.height*y);
                    return !!hit && (hit === node || node.contains(hit));
                  })}))
                };
              })()
            JS

            expect(geometry.fetch("documentWidth")).to be <= width + 1
            expect(geometry.fetch("beforeAuth")).to eq(true)
            expect(geometry.fetch("labelWidth")).to be > 0
            geometry.fetch("targets").each do |target|
              expect(target.fetch("width")).to be > 0
              expect(target.fetch("height")).to be > 0
              expect(target.fetch("left")).to be >= 0
              expect(target.fetch("right")).to be <= geometry.fetch("viewport")
              expect(target.fetch("top")).to be >= [0, geometry.fetch("header").fetch("top")].max
              expect(target.fetch("bottom")).to be <= geometry.fetch("header").fetch("bottom")
              expect(target.fetch("hits")).to all(eq(true)), "Mixed header target clipped or covered: #{target.inspect}"
            end
            menu, logo, left, right = geometry.fetch("targets")
            # The native fixture logo must remain meaningful, not a tiny hit target.
            expect(logo.fetch("width")).to be >= logo.fetch("height")
            [menu, logo, left].each do |target|
              container = geometry.fetch("logoContainer")
              expect(target.fetch("left")).to be >= container.fetch("left")
              expect(target.fetch("right")).to be <= container.fetch("right")
            end
            expect(right.fetch("left")).to be >= geometry.fetch("rightContainer").fetch("left")
            expect(right.fetch("right")).to be <= geometry.fetch("rightContainer").fetch("right")
            expect(geometry.fetch("auth")).not_to be_empty
            geometry.fetch("auth").each do |auth|
              if locale == "ar"
                expect(right.fetch("left")).to be >= auth.fetch("right")
              else
                expect(right.fetch("right")).to be <= auth.fetch("left")
              end
            end
          end

          find("#brand-navigation-menu").click
          expect(page).to have_css(".brand-navigation--menu")
          expect(page).to have_link("Home", href: "/latest", visible: true)
          find("#brand-navigation-menu").click
          find(".brand-navigation-header-links--right a").click
          expect(page).to have_current_path("/latest", ignore_query: true)
        end
      end
    end
  end

  %w[en ar].each do |locale|
    it "keeps the native minimized topic title operable beside mixed links in #{locale}", mobile: true do
      SiteSetting.default_locale = locale
      SiteSetting.title = "CWL"
      theme.update_setting(:mobile_mode, "menu")
      theme.update_setting(
        :navigation_items,
        [
          { label: "Home", url: "/latest", surface: "bar" },
          {
            label: "Home",
            url: "/about",
            surface: "site_header",
            header_alignment: "left",
            header_presentation: "label_only",
          },
          {
            label: "Versions & Status",
            url: "/latest",
            surface: "site_header",
            header_alignment: "right",
            header_presentation: "icon_and_label",
            icon: "circle-info",
          },
        ],
      )
      theme.save!
      topic = Fabricate(:topic)
      Fabricate.times(21, :post, topic: topic)

      resize_window(width: 320, height: 900) do
        visit("/t/#{topic.slug}/#{topic.id}")
        expect(page).to have_css("#topic-title")
        expect(page).to have_css(".d-header button.login-button")
        expect(page).to have_css(".brand-navigation-header-links--left a", text: "Home")
        expect(page).to have_css(".brand-navigation-header-links--right a", text: "Versions & Status")
        expect(page.evaluate_script("getComputedStyle(document.documentElement).direction")).to eq(locale == "ar" ? "rtl" : "ltr")
        page.execute_script("document.querySelector('#post_4').scrollIntoView()")
        expect(page).to have_css(".d-header .extra-info-wrapper .topic-link", text: topic.title)
        # Preserve Core's own mobile minimized visibility, rather than forcing
        # authentication or icons into the native topic-title state.
        expect(page).not_to have_css(".d-header .panel .auth-buttons button")
        expect(page).not_to have_css(".d-header .panel .d-header-icons")

        try_until_success do
          geometry = page.evaluate_script(<<~JS)
            (() => {
              const rect = (node) => {
                const r = node.getBoundingClientRect();
                return {left:r.left,right:r.right,top:r.top,bottom:r.bottom,width:r.width,height:r.height};
              };
              const selectors = [
                "#brand-navigation-menu",
                ".home-logo-wrapper-outlet .title a",
                ".brand-navigation-header-links--left a",
                ".brand-navigation-header-links--right a",
                ".extra-info-wrapper .topic-link"
              ];
              return {
                documentWidth:document.documentElement.scrollWidth, viewport:innerWidth,
                header:rect(document.querySelector(".d-header")),
                offset:parseFloat(getComputedStyle(document.documentElement).getPropertyValue("--header-offset")),
                targets:selectors.map((selector,index) => {
                  const node = document.querySelector(selector);
                  const r = node.getBoundingClientRect();
                  const parents = index < 3 ? [".home-logo-wrapper-outlet"] : index === 3 ? [".before-header-panel-outlet"] : [".extra-info-wrapper", ".extra-info"];
                  return {...rect(node), selector, parents:parents.map(s => rect(node.closest(s))),
                    hits:[[.5,.5],[.25,.5],[.75,.5],[.5,.25],[.5,.75]].map(([x,y]) => {
                      const hit = document.elementFromPoint(r.left+r.width*x,r.top+r.height*y);
                      return !!hit && (hit === node || node.contains(hit));
                    })};
                })
              };
            })()
          JS

          expect(geometry.fetch("documentWidth")).to be <= geometry.fetch("viewport") + 1
          expect((geometry.fetch("offset") - geometry.fetch("header").fetch("bottom")).abs).to be <= 1
          geometry.fetch("targets").each do |target|
            expect(target.fetch("width")).to be > 0
            expect(target.fetch("height")).to be > 0
            expect(target.fetch("left")).to be >= 0
            expect(target.fetch("right")).to be <= geometry.fetch("viewport")
            expect(target.fetch("top")).to be >= [0, geometry.fetch("header").fetch("top")].max
            expect(target.fetch("bottom")).to be <= geometry.fetch("header").fetch("bottom")
            expect(target.fetch("hits")).to all(eq(true)), "Minimized header target clipped or covered: #{target.inspect}"
            target.fetch("parents").each do |parent|
              expect(target.fetch("left")).to be >= parent.fetch("left")
              expect(target.fetch("right")).to be <= parent.fetch("right")
              expect(target.fetch("top")).to be >= parent.fetch("top")
              expect(target.fetch("bottom")).to be <= parent.fetch("bottom")
            end
          end
          logo = geometry.fetch("targets")[1]
          expect(logo.fetch("width")).to be >= logo.fetch("height")
        end

        find("#brand-navigation-menu").click
        expect(page).to have_css(".brand-navigation--menu")
        page.driver.with_playwright_page { |p| p.keyboard.press("Escape") }
        expect(page).not_to have_css(".brand-navigation--menu")
        expect(page.evaluate_script("document.activeElement.id")).to eq("brand-navigation-menu")
        # Exercise Core's real jump-to-top action; do not restore with injected
        # scrolling or force its title/control visibility in either state.
        find(".extra-info-wrapper .topic-link").click
        expect(page).to have_css("#topic-title")
        expect(page).not_to have_css(".d-header .extra-info-wrapper")
        expect(page).to have_css(".d-header button.login-button")
        expect(page).to have_css(".d-header .panel .d-header-icons")
        find(".d-header button.login-button").click
        expect(page).to have_css(".login-fullpage")
      end
    end
  end

  it "uses the intentional compact menu on mobile", mobile: true do
    theme.update_setting(:mobile_mode, "menu")
    theme.save!

    visit("/")

    expect(page).not_to have_css("[data-brand-navigation]")
    expect(page).to have_css("#brand-navigation-menu")
  end

  it "keeps linked submenu children in mobile menu flow", mobile: true do
    theme.update_setting(:mobile_mode, "menu")
    theme.update_setting(
      :navigation_items,
      [
        {
          label: "Explore",
          url: "/categories",
          visibility: "everyone",
          children: [
            { label: "Categories", url: "/categories", visibility: "everyone" },
            { label: "Latest", url: "/latest", visibility: "everyone" },
          ],
        },
        { label: "About", url: "/about", visibility: "everyone" },
      ],
    )
    theme.save!

    visit("/")
    find("#brand-navigation-menu").click
    find('summary[aria-label="Open Explore submenu"]').click

    linked_item = find(".brand-navigation__item", text: "Explore")
    submenu_list = find(".brand-navigation__submenu > ul")
    following_item = all(".brand-navigation__item")[1]
    linked_top = page.evaluate_script(
      "arguments[0].getBoundingClientRect().top",
      linked_item,
    )
    linked_bottom = page.evaluate_script(
      "arguments[0].getBoundingClientRect().bottom",
      linked_item,
    )
    submenu_top = page.evaluate_script(
      "arguments[0].getBoundingClientRect().top",
      submenu_list,
    )
    submenu_bottom = page.evaluate_script(
      "arguments[0].getBoundingClientRect().bottom",
      submenu_list,
    )
    following_top = page.evaluate_script(
      "arguments[0].getBoundingClientRect().top",
      following_item,
    )

    expect(page).to have_link("Latest", href: "/latest", visible: true)
    expect(submenu_top).to be >= linked_top
    expect(submenu_bottom).to be <= linked_bottom
    expect(submenu_bottom).to be <= following_top
    expect(linked_bottom).to be <= following_top
  end

  it "hides the bar and compact menu in hidden mobile mode", mobile: true do
    theme.update_setting(:mobile_mode, "hidden")
    theme.save!

    visit("/")

    expect(page).not_to have_css("[data-brand-navigation]")
    expect(page).not_to have_css("#brand-navigation-menu")
  end

  it "falls back from unavailable bar icons" do
    theme.update_setting(
      :navigation_items,
      [
        {
          label: "Fallback",
          url: "/latest",
          icon: "brand-navigation-missing-icon",
          presentation: "icon_only",
          visibility: "everyone",
        },
      ],
    )
    theme.save!

    visit("/")

    expect(page).to have_css(
      '.brand-navigation__items a[href="/latest"] span',
      text: "Fallback",
    )
  end

  it "keeps mobile bar submenus reachable without a clipping scrollport", mobile: true do
    theme.update_setting(:mobile_mode, "bar")
    theme.save!

    visit("/")
    find('summary[aria-label="Open Explore submenu"]').click

    expect(page).to have_link("Categories", href: "/categories", visible: true)
    expect(
      page.evaluate_script(
        "getComputedStyle(document.querySelector('.brand-navigation__nav')).overflowX",
      ),
    ).to eq("visible")
  end

  [false, true].each do |custom|
    it "#{custom ? 'overrides' : 'inherits'} core-header icon colors without recoloring native controls or text" do
      SiteSetting.interface_color_selector = "header"
      if custom
        theme.update_setting(:header_icon_color, "123456")
        theme.update_setting(:header_icon_hover_color, "#ABCDEF")
      end
      items = ["left", "right"].flat_map do |alignment|
        ["icon_only", "icon_and_label"].map do |presentation|
          {
            label: "#{alignment} #{presentation}",
            url: "/latest",
            icon: "circle-info",
            surface: "site_header",
            header_alignment: alignment,
            header_presentation: presentation,
          }
        end
      end
      theme.update_setting(:navigation_items, items)
      theme.save!
      visit("/")

      native_icon = find(".d-header .d-header-icons .d-icon", match: :first)
      native_before = page.evaluate_script("getComputedStyle(arguments[0]).color", native_icon)
      links = all(".brand-navigation-header-link > a", count: 4)
      links.each do |link|
        icon = link.find(".d-icon")
        normal = page.evaluate_script("getComputedStyle(arguments[0]).color", icon)
        if custom
          expect(normal).to eq("rgb(18, 52, 86)")
        else
          expect(normal).to eq(native_before)
        end
        text = link.first(".brand-navigation-header-link__label", minimum: 0)
        text_before = page.evaluate_script("getComputedStyle(arguments[0]).color", text) if text
        link.hover
        expected_hover = "rgb(171, 205, 239)"
        # Resolve the theme variable via the native control's own hover state.
        unless custom
          native_icon.find(:xpath, "..").hover
          expected_hover = page.evaluate_script("getComputedStyle(arguments[0]).color", native_icon)
          link.hover
        end
        expect(page.evaluate_script("getComputedStyle(arguments[0]).color", icon)).to eq(expected_hover)
        expect(page.evaluate_script("getComputedStyle(arguments[0]).color", text)).to eq(text_before) if text
        link.send_keys(:tab)
        find(":focus").send_keys([:shift, :tab])
        expect(link).to match_selector(":focus-visible")
        expect(page.evaluate_script("getComputedStyle(arguments[0]).color", icon)).to eq(expected_hover)
      end
      find(".brand-navigation__brand").hover
      expect(page.evaluate_script("getComputedStyle(arguments[0]).color", native_icon)).to eq(native_before)
    end
  end

  it "uses configured submenu colors for labels, descriptions, and hover" do
    theme.update_setting(:hover_background_color, "#123456")
    theme.update_setting(:submenu_background_color, "#000000")
    theme.update_setting(:submenu_text_color, "#FFFFFF")
    theme.update_setting(
      :navigation_items,
      [
        {
          label: "Explore",
          url: "/categories",
          visibility: "everyone",
          children: [
            {
              label: "Categories",
              url: "/categories",
              description: "Browse every category",
              visibility: "everyone",
            },
          ],
        },
      ],
    )
    theme.save!

    visit("/")
    find('summary[aria-label="Open Explore submenu"]').click

    child_link = find(".brand-navigation__submenu > ul a", text: "Categories")
    description = find(".brand-navigation__child-description")

    expect(
      page.evaluate_script("getComputedStyle(arguments[0]).color", child_link),
    ).to eq("rgb(255, 255, 255)")
    expect(
      page.evaluate_script("getComputedStyle(arguments[0]).color", description),
    ).to eq("rgb(255, 255, 255)")
    expect(
      page.evaluate_script("getComputedStyle(arguments[0]).opacity", description),
    ).to eq("0.78")

    child_link.hover
    expect(
      page.evaluate_script("getComputedStyle(arguments[0]).backgroundColor", child_link),
    ).to eq("rgb(18, 52, 86)")
  end

  it "keeps an administrator in the navigation editor after saving" do
    sign_in(Fabricate(:admin))
    editor_path = "/admin/customize/themes/#{theme.id}/schema/navigation_items"

    visit(editor_path)
    expect(page).to have_button("Save Changes")
    click_button("Save Changes")

    expect(page).to have_current_path(editor_path)
    expect(page).to have_css(".schema-setting-editor")
  end

  it "shows administrator enhancements for a locally uploaded component" do
    sign_in(Fabricate(:admin))

    visit("/admin/customize/themes/#{theme.id}")

    expect(page).to have_css(".brand-navigation-admin-panel")
    expect(page).to have_css(".brand-navigation-bundles")
  end

  it "reconciles imported appearance settings with the visible controls" do
    sign_in(Fabricate(:admin))
    settings_path = "/admin/customize/themes/#{theme.id}"
    bundle = {
      format: "brand-navigation-settings",
      version: 1,
      settings: { bar_background_color: "#123456" },
    }

    visit(settings_path)
    find(".brand-navigation-bundles textarea").set(bundle.to_json)
    click_button("Import settings")

    expect(page).to have_css(".alert-success", text: "Configuration bundle imported")
    expect(
      find('input[type="color"][data-setting="bar_background_color"]').value,
    ).to eq("#123456")
    expect(page).to have_button("Save colors", disabled: true)

    visit(settings_path)
    expect(
      find('input[type="color"][data-setting="bar_background_color"]').value,
    ).to eq("#123456")
    expect(page).to have_button("Save colors", disabled: true)
  end

  context "with an unpublished staging theme" do
    let(:staging_theme) { Fabricate(:theme, enabled: true, user_selectable: false) }
    let(:theme) { upload_theme_component(parent_theme_id: staging_theme.id) }

    it "imports settings through preview without activating the visitor theme" do
      sign_in(Fabricate(:admin))
      settings_path =
        "/admin/customize/themes/#{theme.id}?preview_theme_id=#{staging_theme.id}"
      bundle = {
        format: "brand-navigation-settings",
        version: 1,
        settings: {
          bar_background_color: "#123456",
          navigation_items: [{ label: "Staged", url: "/latest" }],
        },
      }

      visit("/")
      expect(page).not_to have_css("[data-brand-navigation]")

      visit("/?preview_theme_id=#{staging_theme.id}")
      expect(page).to have_css("[data-brand-navigation]")

      visit(settings_path)
      expect(page).to have_css(".brand-navigation-bundles")
      find(".brand-navigation-bundles textarea").set(bundle.to_json)
      click_button("Import settings")
      expect(page).to have_css(".alert-success", text: "Configuration bundle imported")

      visit(settings_path)
      expect(
        find('input[type="color"][data-setting="bar_background_color"]').value,
      ).to eq("#123456")

      visit("/")
      expect(page).not_to have_css("[data-brand-navigation]")
    end
  end
end
