# frozen_string_literal: true

RSpec.describe "Core features" do
  let(:theme) { upload_theme_or_component }

  before do
    theme.update_setting(:enabled, true)
    theme.save!
  end

  it "runs with Brand Navigation enabled" do
    visit("/")

    expect(page).to have_css("[data-brand-navigation]")
  end

  it_behaves_like "having working core features"
end
