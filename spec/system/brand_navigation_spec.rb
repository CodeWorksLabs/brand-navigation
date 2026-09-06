# frozen_string_literal: true

RSpec.describe "Brand Navigation" do
  let(:theme) { upload_theme_component }

  before do
    theme.update_setting(:enabled, true)
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

  it "hides every component surface in hidden mobile mode", mobile: true do
    theme.update_setting(:mobile_mode, "bar")
    theme.update_setting(
      :navigation_items,
      [
        {
          label: "Social",
          url: "https://example.com/social",
          icon: "globe",
          surface: "site_header",
          visibility: "everyone",
        },
      ],
    )
    theme.save!

    visit("/")
    expect(page).to have_css("[data-brand-navigation]")
    expect(page).to have_css(".brand-navigation-header-icon")

    theme.update_setting(:mobile_mode, "hidden")
    theme.save!

    visit("/")

    expect(page).not_to have_css("[data-brand-navigation]")
    expect(page).not_to have_css("#brand-navigation-menu")
    expect(page).not_to have_css(".brand-navigation-header-icon")
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

  it "keeps an administrator in the navigation editor after saving" do
    sign_in(Fabricate(:admin))
    editor_path = "/admin/customize/themes/#{theme.id}/schema/navigation_items"

    visit(editor_path)
    expect(page).to have_button("Save Changes")
    click_button("Save Changes")

    expect(page).to have_current_path(editor_path)
    expect(page).to have_css(".schema-setting-editor")
  end
end
