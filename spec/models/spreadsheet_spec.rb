require 'spec_helper'

module Importable
  describe Spreadsheet do
    let(:single_worksheet_spreadsheet) do
      spreadsheet_file = File.open support_file('foo_single_worksheet.xlsx')
      Spreadsheet.new(mapper_name: 'foo', file: spreadsheet_file)
    end

    let(:invalid_spreadsheet) do
      spreadsheet_file = File.open support_file('foo_required_field_invalid.xlsx')
      Spreadsheet.new(mapper_name: 'foo_required_field', file: spreadsheet_file)
    end

    let(:invalid_multi_spreadsheet) do
      spreadsheet_file = File.open support_file('foo_multi_worksheet_required_field_invalid.xlsx')
      Spreadsheet.new(mapper_name: 'foo_required_field', file: spreadsheet_file)
    end

    let(:multi_worksheet_spreadsheet) do
      spreadsheet_file = File.open support_file('foo_multi_worksheet.xlsx')
      Spreadsheet.new(file: spreadsheet_file)
    end

    let(:older_excel_spreadsheet) do
      spreadsheet_file = File.open support_file('foo_single_worksheet.xls')
      Spreadsheet.new(file: spreadsheet_file)
    end

    it "should be valid with valid attributes" do
      single_worksheet_spreadsheet.should be_valid
    end

    it "should be invalid without a file" do
      spreadsheet = Spreadsheet.new(mapper_name: 'foo')
      spreadsheet.should_not be_valid
    end

    it "should be invalid with an invalid file" do
      invalid_spreadsheet.should_not be_valid
    end

    it "should be valid with an invalid file if there are multiple sheets but none has been selected" do
      invalid_multi_spreadsheet.should be_valid
    end

    let(:valid_import_param_spreadsheet) do
      spreadsheet_file = support_file('foo_single_worksheet.xlsx')
      Spreadsheet.new(
        import_params: { foo_id: 1 },
        file: File.open(spreadsheet_file), mapper_name: 'foo_required_param'
      )
    end

    let(:invalid_import_param_spreadsheet) do
      spreadsheet_file = support_file('foo_single_worksheet.xlsx')
      Spreadsheet.new(file: File.open(spreadsheet_file), mapper_name: 'foo_required_param')
    end

    it "should be valid if the required params are present" do
      valid_import_param_spreadsheet.should be_valid
    end
    
    it "should be invalid if the required params are not present" do
      invalid_import_param_spreadsheet.should_not be_valid
    end

    describe "#headers" do
      it "should return a list of header values" do
        single_worksheet_spreadsheet.headers.should eq %w[ a b c d ]
      end
    end

    describe "#sheets" do
      it "should return a list of header values" do
        multi_worksheet_spreadsheet.sheets.should eq %w[ Sheet1 Sheet2 ]
      end
    end

    describe "#spreadsheet" do
      it "should be an Excel spreadsheet object if the file is an xls file" do
        older_excel_spreadsheet.spreadsheet.should be_an Excel
      end

      it "should be an Excelx spreadsheet object if the file is an xlsx file" do
        multi_worksheet_spreadsheet.spreadsheet.should be_an Excelx
      end
    end

    describe "#spreadsheet_class" do
      it "should be an Excel class object if the file is an xls file" do
        older_excel_spreadsheet.spreadsheet_class.should eq Excel
      end

      it "should be an Excelx class object if the file is an xlsx file" do
        multi_worksheet_spreadsheet.spreadsheet_class.should eq Excelx
      end
    end

    describe "#imported_items_ready?" do
      it "should be false if the default worksheet has not been set" do
        multi_worksheet_spreadsheet.imported_items_ready?.should be_false
      end

      it "should be true if the default worksheet has not been set but there is only one in the workbook" do
        single_worksheet_spreadsheet.imported_items_ready?.should be_true
      end

      it "should be true if the default worksheet has been set" do
        multi_worksheet_spreadsheet.default_sheet = 'Sheet1'
        multi_worksheet_spreadsheet.imported_items_ready?.should be_true
      end
    end

    describe "#rows" do
      it "should return the spreadsheet rows as a list of hashes" do
        rows = single_worksheet_spreadsheet.rows

        rows.each do |row|
          row.keys.should eq %w[ a b c d ]
        end

        rows[0].values.should eq [1, 2, 3, 4]
        rows[1].values.should eq [2, 3, 4, 5]
        rows[2].values.should eq [3, 4, 5, 6]
        rows[3].values.should eq [4, 5, 6, 7]
      end
    end

    describe "#mapper_class" do
      it "should return the mapper class for the spreadsheet" do
        mapper_class = single_worksheet_spreadsheet.mapper_class
        mapper_class.should eq FooMapper
      end

      it "should not care if the mappers have pluralization" do
        spreadsheet_file = File.open support_file('foo_single_worksheet.xlsx')
        spreadsheet = Spreadsheet.new(mapper_name: 'singular_widgets', file: spreadsheet_file)
        spreadsheet.mapper_class.should eq SingularWidgetMapper
        spreadsheet = Spreadsheet.new(mapper_name: 'singular_widget', file: spreadsheet_file)
        spreadsheet.mapper_class.should eq SingularWidgetMapper
        spreadsheet = Spreadsheet.new(mapper_name: 'plural_widgets', file: spreadsheet_file)
        spreadsheet.mapper_class.should eq PluralWidgetsMapper
        spreadsheet = Spreadsheet.new(mapper_name: 'plural_widget', file: spreadsheet_file)
        spreadsheet.mapper_class.should eq PluralWidgetsMapper
      end
    end
  end
end
