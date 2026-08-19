# frozen_string_literal: true

RSpec.describe "Brand Navigation" do
  let(:theme) { upload_theme_component }

  before do
    theme.update_setting(:brand_name, "Example")
    theme.update_setting(:brand_url, "/latest")
    theme.update_setting(
      :navigation_items,
      [
        { label: "Latest", url: "/latest", target: "_self", visibility: "everyone" },
        {
          label: "Explore",
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
    expect(page).to have_css("details summary", text: "Explore")
    expect(page).to have_link("Categories", href: "/categories", visible: :all)
  end

  it "does not mount the application component in embed mode" do
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
end
