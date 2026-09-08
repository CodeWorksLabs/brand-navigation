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
    visit("/")
    expect(page).to have_css("[data-brand-navigation]")

    visit("/?embed_mode=true")

    expect(page).not_to have_css("[data-brand-navigation]")
    expect(page).not_to have_css("#brand-navigation-menu")
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
end
