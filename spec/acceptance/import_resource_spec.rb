require 'spec_helper'

feature "Import resource" do
  background do
    start_fake_foo_api!
  end

  scenario "Import a resource" do
    visit '/import/foo_resource/resource'
    click_on "Import"

    page.should have_content "Foo resource was successfully imported."
  end
end
