require 'spec_helper'

module Importable
  describe ImportedItemsValidator do
    let(:valid_spreadsheet) do
      spreadsheet_file = support_file('foo_required_field_valid.xlsx')
      Spreadsheet.new(file: File.open(spreadsheet_file), object_type: 'foo_required_field')
    end
    let(:invalid_spreadsheet) do
      spreadsheet_file = support_file('foo_required_field_invalid.xlsx')
      Spreadsheet.new(file: File.open(spreadsheet_file), object_type: 'foo_required_field')
    end

    it "should be invalid if any underlying objects are invalid" do
      invalid_spreadsheet.should_not be_valid
    end

    it "should generate a list of meaningful error messages" do
      invalid_spreadsheet.valid?
      messages =  invalid_spreadsheet.errors.messages[:doof]
      messages[0].should eq "can't be blank (line 3)"
      messages[1].should eq "can't be blank (line 4)"
    end

    it "should be valid if all underlying objects are valid" do
      valid_spreadsheet.should be_valid
    end
  end
end
