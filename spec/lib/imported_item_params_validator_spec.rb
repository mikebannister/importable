require 'spec_helper'

module Importable
  describe ImportedItemParamsValidator do
    let(:valid_spreadsheet) do
      spreadsheet_file = support_file('foo_single_worksheet.xlsx')
      Spreadsheet.new(
        import_params: { foo_id: 1 },
        file: File.open(spreadsheet_file), object_type: 'foo_required_param'
      )
    end

    let(:invalid_spreadsheet) do
      spreadsheet_file = support_file('foo_single_worksheet.xlsx')
      Spreadsheet.new(file: File.open(spreadsheet_file), object_type: 'foo_required_param')
    end

    it "should be valid if required field is present" do
      valid_spreadsheet.should be_valid
    end
    
    it "should be invalid if required field is not present" do
      invalid_spreadsheet.should_not be_valid
      invalid_spreadsheet.errors.messages[:base].first.should eq "You must choose a foo!"
    end
  end
end
