require 'spec_helper'

feature "Import spreadsheet" do
  scenario "Import spreadsheet with a single worksheet" do
    visit '/importable/spreadsheets'
  end
end
