# frozen_string_literal: true

RSpec.describe "Brand Navigation" do
  let(:theme) { upload_theme_component }

  let(:appearance_color_labels) do
    {
      bar_background_color: "Navigation bar — background",
      bar_text_color: "Navigation bar — text and icons",
      hover_background_color: "Navigation menus — hover/highlight background",
      submenu_background_color: "Dropdown menus — background",
      submenu_text_color: "Dropdown menus — text and icons",
      submenu_hover_text_color: "Dropdown menus — text and icons on hover/focus",
      header_icon_color: "Discourse header — icons",
      header_icon_hover_color: "Discourse header — icons on hover/focus",
      header_text_color: "Discourse header — link text",
      header_text_hover_color: "Discourse header — link text on hover/focus",
      header_hover_background_color: "Discourse header — link and icon background on hover/focus",
    }
  end

  def inherited_appearance_values
    appearance_color_labels.transform_values { "" }
  end

  def configure_appearance_values(values)
    values.each { |name, value| theme.update_setting(name, value) }
    theme.save!
  end

  def save_native_appearance_color(name, value)
    selector = "section.theme.settings .setting[data-setting='#{name}']"
    find(selector).find("input.input-setting-string").set(value)
    find(selector).find(".setting-controls__ok").click
    expect(page).not_to have_css("#{selector} .setting-controls__ok")
    expect(theme.reload.settings.fetch(name).value).to eq(value)
  end

  def edit_appearance_color(name, value)
    checkbox = ".brand-navigation-admin-panel input[type='checkbox'][data-setting='#{name}']"
    expect(page).to have_css("#{checkbox}:checked")
    picker = find(".brand-navigation-admin-panel input[type='color'][data-setting='#{name}']")
    expect(picker).not_to be_disabled
    # The established dispatched-input pattern exercises the HTML color input,
    # not the operating system's color chooser (covered separately by E08).
    page.execute_script(
      "arguments[0].value=arguments[1]; arguments[0].dispatchEvent(new Event('input',{bubbles:true}));",
      picker,
      value,
    )
  end

  def expect_persisted_appearance_values(expected)
    expect(expected.keys.sort).to eq(appearance_color_labels.keys.sort)
    try_until_success do
      saved = theme.reload.settings
      expected.each do |name, value|
        expect(saved.fetch(name).value).to eq(value), "stored #{name}"
      end
    end
    expected.each do |name, value|
      row = find("section.theme.settings .setting[data-setting='#{name}']")
      expect(row).to have_field(with: value)
    end
  end

  def expect_appearance_controls(expected)
    expected.each do |name, value|
      checkbox = ".brand-navigation-admin-panel input[type='checkbox'][data-setting='#{name}']"
      expect(page).to have_css("#{checkbox}#{value.empty? ? ':not(:checked)' : ':checked'}")
      picker = find(".brand-navigation-admin-panel input[type='color'][data-setting='#{name}']")
      if value.empty?
        expect(picker).to be_disabled
      else
        expect(picker).not_to be_disabled
        expect(picker.value).to eq(value.downcase)
      end
    end
  end

  def expect_appearance_values(expected)
    expect_persisted_appearance_values(expected)
    expect_appearance_controls(expected)
  end

  def expect_appearance_before_and_after_reload(expected, settings_path)
    [false, true].each do |reload_page|
      visit(settings_path) if reload_page
      expect(page).to have_button("Save colors", disabled: true)
      expect_appearance_values(expected)
    end
  end

  def expect_appearance_checkbox_names
    expect(page).to have_css(".brand-navigation-admin-panel input[type='checkbox'][data-setting]", count: 11)
    page.driver.with_playwright_page do |browser_page|
      appearance_color_labels.each_value do |label|
        expect(
          browser_page.get_by_role("checkbox", name: "Use a custom color for #{label}", exact: true).count,
        ).to eq(1)
      end
    end
  end

  def tab_to_appearance_checkbox(name)
    selector = ".brand-navigation-admin-panel input[type='checkbox'][data-setting='#{name}']"
    # Include hidden and disabled controls for a conservative full-page bound,
    # plus one Tab for wrapping back to the start of the document.
    maximum_tabs = page.evaluate_script(<<~JS)
      document.querySelectorAll(
        "a[href], area[href], button, input, select, textarea, summary, iframe, " +
        "object, embed, [tabindex], [contenteditable], audio[controls], video[controls]"
      ).length + 1
    JS
    reached = false
    maximum_tabs.times do
      page.driver.with_playwright_page { |browser_page| browser_page.keyboard.press("Tab") }
      reached = page.evaluate_script("document.activeElement?.matches(arguments[0]) === true", selector)
      break if reached
    end
    expect(reached).to eq(true), "keyboard reaches #{name}"
    expect(page).to have_css("#{selector}:focus-visible")
  end

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

  shared_examples "optional navigation appearance controls" do |device, width|
    def appearance_style(node, property)
      page.evaluate_script("getComputedStyle(arguments[0])[arguments[1]]", node, property)
    end

    def appearance_palette(node, expression)
      page.evaluate_script(<<~JS, node, expression)
        (() => {
          const probe = document.createElement("span");
          probe.style.cssText = "position:absolute;visibility:hidden;pointer-events:none";
          probe.style.setProperty("color", arguments[1], "important");
          arguments[0].append(probe);
          try { return getComputedStyle(probe).color; } finally { probe.remove(); }
        })()
      JS
    end

    def appearance_keyboard_focus(node)
      page.driver.with_playwright_page { |p| p.mouse.move(1, 850) }
      # Bound traversal by the page's controls, including a wrap to its start.
      maximum_tabs = page.evaluate_script(<<~JS)
        document.querySelectorAll(
          "a[href], area[href], button, input, select, textarea, summary, iframe, " +
          "object, embed, [tabindex], [contenteditable], audio[controls], video[controls]"
        ).length + 1
      JS
      reached = false
      maximum_tabs.times do
        page.driver.with_playwright_page { |p| p.keyboard.press("Tab") }
        reached = page.evaluate_script("document.activeElement === arguments[0]", node)
        break if reached
      end
      expect(reached).to eq(true)
      expect(node).to match_selector(":focus-visible")
      expect(node).not_to match_selector(":hover")
    end

    def appearance_native_styles
      page.evaluate_script(<<~JS)
        [".d-header .d-header-icons .d-icon", ".d-header button.login-button"].map(selector => {
          const node = document.querySelector(selector);
          if (!node) { throw new Error("Missing native appearance reference: " + selector); }
          const style = getComputedStyle(node), rect = node.getBoundingClientRect();
          return {selector, font:style.fontSize, color:style.color,
            background:style.backgroundColor, width:rect.width, height:rect.height};
        })
      JS
    end

    it "applies independent optional header sizes and interaction colors on #{device}" do
      SiteSetting.interface_color_selector = "header"
      SiteSetting.title = "CWL"
      theme.update_setting(
        :navigation_items,
        [
          { label: "Home", url: "/latest" },
          { label: "Info", url: "/about", icon: "circle-info", surface: "site_header",
            header_alignment: "left", header_presentation: "icon_only" },
          { label: "Status", url: "/latest", icon: "circle-info", surface: "site_header",
            header_alignment: "right", header_presentation: "icon_and_label" },
        ],
      )
      theme.save!

      resize_window(width: width, height: 900) do
        visit("/")
        page.driver.with_playwright_page { |p| p.mouse.move(1, 850) }
        native_before = appearance_native_styles
        baseline_icons = all(".brand-navigation-header-link > a > .d-icon", count: 2).map do |icon|
          appearance_style(icon, "fontSize")
        end
        baseline_text = appearance_style(find(".brand-navigation-header-link__label"), "fontSize")
        baseline_backgrounds = all(".brand-navigation-header-link > a", count: 2).map do |link|
          link.hover
          appearance_style(link, "backgroundColor")
        end
        baseline_focus_backgrounds = all(".brand-navigation-header-link > a", count: 2).map do |link|
          appearance_keyboard_focus(link)
          appearance_style(link, "backgroundColor")
        end
        sizes = {
          header_icon_size_desktop: 28, header_text_size_desktop: 18,
          header_icon_size_mobile: 20, header_text_size_mobile: 17,
        }
        colors = {
          header_icon_color: "#123456", header_icon_hover_color: "#ABCDEF",
          header_text_color: "#234567", header_text_hover_color: "#FFFFFF",
          header_hover_background_color: "#002147",
        }

        sizes.each { |key, value| theme.update_setting(key, value) }
        # Reload Core's preloaded setting records before the phase updates.
        theme.save!
        selected_icon = sizes.fetch(:"header_icon_size_#{device}")
        selected_text = sizes.fetch(:"header_text_size_#{device}")
        [
          [:both, selected_icon, selected_text],
          [:text_only, 0, selected_text],
          [:icon_only, selected_icon, 0],
          [:both_zero, 0, 0],
        ].each do |phase, icon_size, text_size|
          custom = phase != :both_zero
          theme.update_setting(:"header_icon_size_#{device}", icon_size)
          theme.update_setting(:"header_text_size_#{device}", text_size)
          colors.each { |key, value| theme.update_setting(key, custom ? value : "") }
          theme.save!
          visit("/")
          page.driver.with_playwright_page { |p| p.mouse.move(1, 850) }
          expect(appearance_native_styles).to eq(native_before)

          icons = all(".brand-navigation-header-link > a > .d-icon", count: 2)
          expected_icons = icon_size > 0 ? ["#{icon_size}px"] * 2 : baseline_icons
          expect(icons.map { |icon| appearance_style(icon, "fontSize") }).to eq(expected_icons)
          label = find(".brand-navigation-header-link__label")
          expected_text = text_size > 0 ? "#{text_size}px" : baseline_text
          expect(appearance_style(label, "fontSize")).to eq(expected_text)
          other = device == :desktop ? :mobile : :desktop
          [:header_icon_size, :header_text_size].each do |prefix|
            key = :"#{prefix}_#{other}"
            expect(theme.reload.settings.fetch(key).value).to eq(sizes.fetch(key))
          end

          all(".brand-navigation-header-link > a", count: 2).each_with_index do |link, index|
            icon = link.find(".d-icon")
            text = link.first(".brand-navigation-header-link__label", minimum: 0)
            normal_icon = custom ? "rgb(18, 52, 86)" : appearance_palette(link, "var(--d-header-icon-color,var(--header_primary-low-mid))")
            hover_icon = custom ? "rgb(171, 205, 239)" : appearance_palette(link, "var(--d-header-icon-color--hover,var(--header_primary))")
            normal_text = custom ? "rgb(35, 69, 103)" : appearance_palette(link, "var(--header_primary)")
            hover_text = custom ? "rgb(255, 255, 255)" : appearance_palette(link, "var(--header_primary)")
            hover_background = custom ? "rgb(0, 33, 71)" : baseline_backgrounds.fetch(index)
            focus_background = custom ? "rgb(0, 33, 71)" : baseline_focus_backgrounds.fetch(index)
            page.driver.with_playwright_page { |p| p.mouse.move(1, 850) }
            expect(appearance_style(icon, "color")).to eq(normal_icon)
            expect(appearance_style(text, "color")).to eq(normal_text) if text
            link.hover
            expect(link).to match_selector(":hover")
            expect(appearance_style(icon, "color")).to eq(hover_icon)
            expect(appearance_style(text, "color")).to eq(hover_text) if text
            expect(appearance_style(link, "backgroundColor")).to eq(hover_background)
            appearance_keyboard_focus(link)
            expect(appearance_style(icon, "color")).to eq(hover_icon)
            expect(appearance_style(text, "color")).to eq(hover_text) if text
            expect(appearance_style(link, "backgroundColor")).to eq(focus_background)
          end
          expect(appearance_native_styles).to eq(native_before)
        end
      end
    end

    it "keeps optional submenu hover foreground inherited or independently white on #{device}" do
      theme.update_setting(:hover_background_color, "#002147")
      theme.update_setting(:submenu_background_color, "#FFFFFF")
      theme.update_setting(:submenu_text_color, "#002147")
      theme.update_setting(
        :navigation_items,
        [
          {
            label: "Explore", url: "/categories",
            children: [
              { label: "Categories", url: "/categories", icon: "circle-info",
                description: "Browse every category" },
            ],
          },
        ],
      )
      theme.save!

      resize_window(width: width, height: 900) do
        ["", "#FFFFFF"].each do |foreground|
          theme.update_setting(:submenu_hover_text_color, foreground)
          theme.save!
          visit("/")
          find("#brand-navigation-menu").click if device == :mobile
          find('summary[aria-label="Open Explore submenu"]').click
          child = find(".brand-navigation__submenu > ul a", text: "Categories")
          pieces = [child.find(".d-icon"), child.find(".brand-navigation__child-label"),
                    child.find(".brand-navigation__child-description")]
          page.driver.with_playwright_page { |p| p.mouse.move(1, 850) }
          expect(pieces.map { |node| appearance_style(node, "color") }).to all(eq("rgb(0, 33, 71)"))
          expect(appearance_style(child.find(".brand-navigation__child-description"), "opacity")).to eq("0.78")
          expected = foreground.empty? ? "rgb(0, 33, 71)" : "rgb(255, 255, 255)"
          child.hover
          expect(child).to match_selector(":hover")
          expect(appearance_style(child, "backgroundColor")).to eq("rgb(0, 33, 71)")
          expect(pieces.map { |node| appearance_style(node, "color") }).to all(eq(expected))
          appearance_keyboard_focus(child)
          expect(appearance_style(child, "backgroundColor")).to eq("rgb(0, 33, 71)")
          expect(pieces.map { |node| appearance_style(node, "color") }).to all(eq(expected))
        end
      end
    end
  end

  context "with desktop optional appearance controls" do
    include_examples "optional navigation appearance controls", :desktop, 1280
  end

  context "with mobile optional appearance controls", mobile: true do
    include_examples "optional navigation appearance controls", :mobile, 390
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

  it "preserves a native color save after a no-op Inherit all and a different Appearance save" do
    color_names = %i[
      bar_background_color
      bar_text_color
      hover_background_color
      submenu_background_color
      submenu_text_color
      submenu_hover_text_color
      header_icon_color
      header_icon_hover_color
      header_text_color
      header_text_hover_color
      header_hover_background_color
    ]
    expected = color_names.to_h { |name| [name, ""] }
    color_names.each { |name| theme.update_setting(name, "") }
    theme.save!
    sign_in(Fabricate(:admin))
    settings_path = "/admin/customize/themes/#{theme.id}"

    visit(settings_path)
    expect(page).to have_css('.brand-navigation-admin-panel input[type="color"]', count: 11)
    appearance_panel = find(".brand-navigation-admin-panel")
    color_names.each do |name|
      expect(page).to have_css("input[type='checkbox'][data-setting='#{name}']:not(:checked)")
    end
    click_button("Inherit all")
    expect(page).to have_button("Save colors", disabled: true)

    # Keep the same page and Appearance instance throughout both editors' saves.
    native_row = find("section.theme.settings .setting[data-setting='bar_background_color']")
    native_row.find("input.input-setting-string").set("#123456")
    native_row.find(".setting-controls__ok").click
    expect(native_row).not_to have_css(".setting-controls__ok")
    expect(theme.reload.settings.fetch(:bar_background_color).value).to eq("#123456")
    expect(
      page.evaluate_script("arguments[0] === document.querySelector('.brand-navigation-admin-panel')", appearance_panel),
    ).to eq(true)

    within(".brand-navigation-admin-panel") do
      find("input[type='checkbox'][data-setting='header_icon_color']").click
      expect(page).to have_css("input[type='checkbox'][data-setting='header_icon_color']:checked")
      picker = find("input[type='color'][data-setting='header_icon_color']")
      page.execute_script(
        "arguments[0].value='#456789'; arguments[0].dispatchEvent(new Event('input',{bubbles:true}));",
        picker,
      )
      click_button("Save colors")
    end
    expect(page).to have_css(".alert-success", text: "Brand Navigation colors saved")
    expected[:bar_background_color] = "#123456"
    expected[:header_icon_color] = "#456789"

    [false, true].each do |reload_page|
      visit(settings_path) if reload_page
      expect(page).to have_button("Save colors", disabled: true)
      saved_settings = theme.reload.settings
      expected.each do |name, value|
        expect(saved_settings.fetch(name).value).to eq(value)
        row = find("section.theme.settings .setting[data-setting='#{name}']")
        expect(row).to have_field(with: value)
        checkbox = "input[type='checkbox'][data-setting='#{name}']"
        expect(page).to have_css("#{checkbox}#{value.empty? ? ':not(:checked)' : ':checked'}")
      end
      %i[bar_background_color header_icon_color].each do |name|
        expect(find("input[type='color'][data-setting='#{name}']").value).to eq(expected.fetch(name))
      end
    end
  end

  it "preserves initially custom colors after a native-only save and a different Appearance save" do
    expected = inherited_appearance_values.merge(
      bar_background_color: "#112233",
      bar_text_color: "#334455",
      header_icon_color: "#223344",
    )
    configure_appearance_values(expected)
    sign_in(Fabricate(:admin, locale: "en"))
    settings_path = "/admin/customize/themes/#{theme.id}"
    visit(settings_path)
    appearance_panel = find(".brand-navigation-admin-panel")
    expect_appearance_values(expected)

    save_native_appearance_color(:bar_background_color, "#123456")
    expected[:bar_background_color] = "#123456"
    try_until_success do
      picker = find(".brand-navigation-admin-panel input[type='color'][data-setting='bar_background_color']")
      expect(picker.value).to eq(expected.fetch(:bar_background_color).downcase)
    end
    expect_appearance_values(expected)
    expect(page).to have_button("Save colors", disabled: true)
    expect(
      page.evaluate_script("arguments[0] === document.querySelector('.brand-navigation-admin-panel')", appearance_panel),
    ).to eq(true)

    edit_appearance_color(:header_icon_color, "#456789")
    click_button("Save colors")
    expect(page).to have_css(".alert-success", text: "Brand Navigation colors saved")
    expected[:header_icon_color] = "#456789"
    expect_appearance_before_and_after_reload(expected, settings_path)
  end

  it "preserves an intentional same-field Appearance draft and resets only color overrides" do
    expected = inherited_appearance_values.merge(
      bar_background_color: "#112233",
      header_icon_color: "#223344",
    )
    configure_appearance_values(expected)
    non_color_settings = lambda do
      theme.reload.settings.reject { |name, _| appearance_color_labels.key?(name.to_sym) }.transform_values(&:value)
    end
    retained = JSON.parse(non_color_settings.call.to_json)
    sign_in(Fabricate(:admin, locale: "en"))
    settings_path = "/admin/customize/themes/#{theme.id}"
    visit(settings_path)
    appearance_panel = find(".brand-navigation-admin-panel")

    edit_appearance_color(:bar_background_color, "#445566")
    save_native_appearance_color(:bar_background_color, "#667788")
    expected[:bar_background_color] = "#667788"
    expect_persisted_appearance_values(expected)
    expect_appearance_controls(expected.merge(bar_background_color: "#445566"))
    expect(page).to have_button("Save colors", disabled: false)
    expect(
      page.evaluate_script("arguments[0] === document.querySelector('.brand-navigation-admin-panel')", appearance_panel),
    ).to eq(true)

    # This field was deliberately drafted before the native save. Its draft
    # retains precedence; it is not an untouched-field preservation case.
    click_button("Save colors")
    expect(page).to have_css(".alert-success", text: "Brand Navigation colors saved")
    expected[:bar_background_color] = "#445566"
    expect_appearance_before_and_after_reload(expected, settings_path)

    click_button("Inherit all")
    expect(page).to have_css(".alert-success", text: "Brand Navigation colors saved")
    expect_appearance_before_and_after_reload(inherited_appearance_values, settings_path)
    expect(JSON.parse(non_color_settings.call.to_json)).to eq(retained)
  end

  it "retains an Appearance draft after rejection before persistence and saves it after recovery" do
    expected = inherited_appearance_values.merge(
      bar_background_color: "#112233",
      header_icon_color: "#223344",
    )
    configure_appearance_values(expected)
    sign_in(Fabricate(:admin, locale: "en"))
    settings_path = "/admin/customize/themes/#{theme.id}"
    visit(settings_path)
    appearance_panel = find(".brand-navigation-admin-panel")
    save_native_appearance_color(:bar_background_color, "#123456")
    expected[:bar_background_color] = "#123456"
    edit_appearance_color(:header_icon_color, "#456789")

    pattern = %r{/admin/themes/#{theme.id}\.json(?:\?|$)}
    rejected_requests = []
    handler = lambda do |route, request|
      if request.method == "PUT"
        rejected_requests << request.post_data
        route.fulfill(
          status: 422,
          contentType: "application/json",
          body: JSON.generate(errors: ["Synthetic Appearance rejection before persistence"]),
        )
      else
        route.continue
      end
    end

    # Core's existing system specs use this routing/ensure-unroute mechanism.
    # No request reaches Core during this rejection, so this case makes no
    # assertion that a real partially processed bulk update is atomic.
    page.driver.with_playwright_page do |browser_page|
      browser_page.route(pattern, handler)
      begin
        click_button("Save colors")
        expect(page).to have_css(".alert-error", text: "Synthetic Appearance rejection before persistence")
        expect(page).not_to have_css(".alert-success", text: "Brand Navigation colors saved")
        expect(rejected_requests.length).to eq(1)
        expect_persisted_appearance_values(expected)
        expect_appearance_controls(expected.merge(header_icon_color: "#456789"))
        expect(page).to have_button("Save colors", disabled: false)
        expect(
          page.evaluate_script("arguments[0] === document.querySelector('.brand-navigation-admin-panel')", appearance_panel),
        ).to eq(true)
      ensure
        browser_page.unroute(pattern, handler: handler)
      end
    end

    # Planned recovery within the example: the next save uses real Core
    # persistence after the test-only rejection has been removed.
    click_button("Save colors")
    expect(page).to have_css(".alert-success", text: "Brand Navigation colors saved")
    expect(page).not_to have_css(".alert-error")
    expected[:header_icon_color] = "#456789"
    expect_appearance_before_and_after_reload(expected, settings_path)
  end

  it "names all eleven Custom checkboxes and preserves keyboard-operated custom and inherited states after reload" do
    expected = inherited_appearance_values
    configure_appearance_values(expected)
    sign_in(Fabricate(:admin, locale: "en"))
    settings_path = "/admin/customize/themes/#{theme.id}"
    visit(settings_path)
    expect_appearance_values(expected)
    expect_appearance_checkbox_names

    appearance_color_labels.each_key.with_index do |name, index|
      tab_to_appearance_checkbox(name)
      page.driver.with_playwright_page { |browser_page| browser_page.keyboard.press("Space") }
      expect(page).to have_css("input[type='checkbox'][data-setting='#{name}']:checked")
      expect(page).to have_css("input[type='color'][data-setting='#{name}']:enabled")
      expected[name] = format("#%06d", 123450 + index)
      edit_appearance_color(name, expected.fetch(name))
    end
    expect_appearance_controls(expected)
    expect_appearance_checkbox_names
    click_button("Save colors")
    expect(page).to have_css(".alert-success", text: "Brand Navigation colors saved")
    expect_appearance_before_and_after_reload(expected, settings_path)
    expect_appearance_checkbox_names

    appearance_color_labels.each_key.with_index do |name, index|
      next if index.odd?
      tab_to_appearance_checkbox(name)
      page.driver.with_playwright_page { |browser_page| browser_page.keyboard.press("Space") }
      expect(page).to have_css("input[type='checkbox'][data-setting='#{name}']:not(:checked)")
      expect(page).to have_css("input[type='color'][data-setting='#{name}']:disabled")
      expected[name] = ""
    end
    expect_appearance_controls(expected)
    expect_appearance_checkbox_names
    click_button("Save colors")
    expect(page).to have_css(".alert-success", text: "Brand Navigation colors saved")
    expect_appearance_before_and_after_reload(expected, settings_path)
    expect_appearance_checkbox_names
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
