require 'spec_helper'

feature "Import resource" do
  scenario "Import a resource" do
    with_fake_foo_api do
      visit '/import/foo_resource/resource'
      click_on "Import"

      page.should have_content "Foo resource was successfully imported."
    end
  end

  scenario "Import with missing parameters" do
    visit '/import/foo_required_param_resource/resource'
    click_on "Import"
  end
end
