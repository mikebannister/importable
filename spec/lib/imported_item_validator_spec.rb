require 'spec_helper'

module Importable
  describe ImportedItemsValidator do
    let(:valid_spreadsheet) do
      spreadsheet_file = support_file('foo_required_field_valid.xlsx')
      Spreadsheet.new(file: File.open(spreadsheet_file), mapper_name: 'foo_required_field')
    end

    let(:invalid_spreadsheet) do
      spreadsheet_file = support_file('foo_required_field_invalid.xlsx')
      Spreadsheet.new(file: File.open(spreadsheet_file), mapper_name: 'foo_required_field')
    end

    let(:foo_with_relations_spreadsheet) do
      spreadsheet_file = support_file('foo_with_relations.xls')
      Spreadsheet.new(file: File.open(spreadsheet_file), mapper_name: 'foo_with_relations')
    end

    let(:foo_with_relations_with_link_spreadsheet) do
      spreadsheet_file = support_file('foo_with_relations.xls')
      Spreadsheet.new(file: File.open(spreadsheet_file), mapper_name: 'foo_with_relations_with_link')
    end

    let(:invalid_spreadsheet_require_params) do
      spreadsheet_file = support_file('foo_required_field_invalid.xlsx')
      Spreadsheet.new(file: File.open(spreadsheet_file), mapper_name: 'foo_required_param_and_field')
    end

    it "should be invalid if any underlying objects are invalid" do
      invalid_spreadsheet.should_not be_valid
    end

    it "should not perform this validation if are required params missing" do
      invalid_spreadsheet_require_params.valid?

      # it has an error for the required param but none added for invalid spreadsheet
      invalid_spreadsheet_require_params.errors.should have_exactly(1).items
    end

    it "should not perform this validation if the importer is not ready" do
      Spreadsheet.any_instance.stubs(:imported_items_ready?).returns(false)

      invalid_spreadsheet.valid?
      invalid_spreadsheet.errors.should be_empty
    end

    it "should be valid if all underlying objects are valid" do
      valid_spreadsheet.should be_valid
    end

    it "should generate a list of meaningful error messages" do
      invalid_spreadsheet.valid?
      messages = invalid_spreadsheet.errors.messages[:doof]
      messages.should include "on line 3 can't be blank"
      messages.should include "on line 4 can't be blank"
    end

    it "should generate errors messages that show the original value if it was not blank but resulted in a nil attribute" do
      foo_with_relations_spreadsheet.valid?

      messages = foo_with_relations_spreadsheet.errors.messages[:foo_relation_id]
      messages.should include "on line 5 could not be found: exists not"
    end
  end
end
