require 'spec_helper'

feature "Import spreadsheet" do
  scenario "Import spreadsheet with a single worksheet" do
    spreadsheet_file = support_file('foo_single_worksheet.xlsx')

    visit '/import/foo/spreadsheet'
    attach_file("Choose foo spreadsheet file", spreadsheet_file)
    click_button "Upload"
    page.should have_content "Foo spreadsheet was successfully imported."
  end

  scenario "Import spreadsheet with multiple worksheets" do
    spreadsheet_file = support_file('foo_multi_worksheet.xlsx')

    visit '/import/foo/spreadsheet'
    attach_file("Choose foo spreadsheet file", spreadsheet_file)
    click_button "Upload"
    page.should have_content "Choose worksheet"
    choose "Sheet2"
    click_button "Continue"
    page.should have_content "Sheet2 worksheet of foo spreadsheet was successfully imported."
  end

  scenario "Import invalid spreadsheet" do
    spreadsheet_file = support_file('foo_required_field_invalid.xlsx')

    visit '/import/foo_required_field/spreadsheet'
    attach_file("Choose foo required field spreadsheet file", spreadsheet_file)
    click_button "Upload"
    page.should have_content "Doof on line 3 can't be blank"
  end

  scenario "Import invalid multi worksheet spreadsheet" do
    spreadsheet_file = support_file('foo_multi_worksheet_required_field_invalid.xlsx')

    visit '/import/foo_required_field/spreadsheet'
    attach_file("Choose foo required field spreadsheet file", spreadsheet_file)
    click_button "Upload"
    page.should have_content "Choose worksheet"
    click_button "Continue"
    page.should have_content "Doof on line 3 can't be blank"
  end

  scenario "Import redirects to index page if requested" do
    spreadsheet_file = support_file('foo_multi_worksheet.xlsx')

    visit '/import/foo/spreadsheet?return_to=index'
    attach_file("Choose foo spreadsheet file", spreadsheet_file)
    click_button "Upload"
    page.should have_content "Choose worksheet"
    click_button "Continue"
    page.should have_content "Sheet1 worksheet of foo spreadsheet was successfully imported."
    page.should have_content "Foos index"
  end

  scenario "Import redirects back to the import page if requested" do
    spreadsheet_file = support_file('foo_multi_worksheet.xlsx')

    visit '/import/foo/spreadsheet?return_to=import'
    attach_file("Choose foo spreadsheet file", spreadsheet_file)
    click_button "Upload"
    page.should have_content "Choose worksheet"
    click_button "Continue"
    page.should have_content "Sheet1 worksheet of foo spreadsheet was successfully imported."
    page.should have_content "Foo spreadsheet upload"
  end
end
