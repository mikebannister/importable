require 'spec_helper'

module Importable
  describe Spreadsheet do
    let(:single_worksheet_spreadsheet) do
      spreadsheet_file = File.open support_file('foo_single_worksheet.xlsx')
      Spreadsheet.new(object_type: 'foo', file: spreadsheet_file)
    end

    let(:invalid_spreadsheet) do
      spreadsheet_file = File.open support_file('foo_required_field_invalid.xlsx')
      Spreadsheet.new(object_type: 'foo_required_field', file: spreadsheet_file)
    end

    let(:invalid_multi_spreadsheet) do
      spreadsheet_file = File.open support_file('foo_multi_worksheet_required_field_invalid.xlsx')
      Spreadsheet.new(object_type: 'foo_required_field', file: spreadsheet_file)
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
      spreadsheet = Spreadsheet.new(object_type: 'foo')
      spreadsheet.should_not be_valid
    end

    it "should be invalid with an invalid file" do
      invalid_spreadsheet.should_not be_valid
    end

    it "should be valid with an invalid file if there are multiple sheets but none has been selected" do
      invalid_multi_spreadsheet.should be_valid
    end

    it "should be invalid with an invalid file if there are multiple sheets but one has been selected (implied by the object being saved)" do
      invalid_multi_spreadsheet.save!
      invalid_multi_spreadsheet.should be_invalid
    end

    describe "#headers" do
      it "should return a list of header values" do
        single_worksheet_spreadsheet.headers.should eq %w[ a b c d ]
      end
    end

    describe "#import!" do
      it "should initialize a mapper to handle the actual importing" do
        data = single_worksheet_spreadsheet.rows
        mapper = FooMapper.new(data)

        FooMapper.should_receive(:new).and_return(mapper)

        single_worksheet_spreadsheet.import!
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
        spreadsheet = Spreadsheet.new(object_type: 'singular_widgets', file: spreadsheet_file)
        spreadsheet.mapper_class.should eq SingularWidgetMapper
        spreadsheet = Spreadsheet.new(object_type: 'singular_widget', file: spreadsheet_file)
        spreadsheet.mapper_class.should eq SingularWidgetMapper
        spreadsheet = Spreadsheet.new(object_type: 'plural_widgets', file: spreadsheet_file)
        spreadsheet.mapper_class.should eq PluralWidgetsMapper
        spreadsheet = Spreadsheet.new(object_type: 'plural_widget', file: spreadsheet_file)
        spreadsheet.mapper_class.should eq PluralWidgetsMapper
      end
    end

    describe "#mapper" do
      it "should return the mapper instance for the spreadsheet" do
        mapper = single_worksheet_spreadsheet.mapper
        mapper.should be_a FooMapper
      end
    end

    describe "self#mapper_files" do
      it "should list the available mapper files" do
        Spreadsheet.mapper_files[0].ends_with?('foo_mapper.rb').should be_true
        Spreadsheet.mapper_files[1].ends_with?('foo_required_field_mapper.rb').should be_true
      end
    end

    describe "self#mapper_types" do
      it "should list the available mapper types" do
        Spreadsheet.mapper_types[0].should eq 'foo'
        Spreadsheet.mapper_types[1].should eq 'foo_required_field'
      end
    end

    describe "self#mapper_type_exists?" do
      it "should return true if the supplied mapper type exists" do
        Spreadsheet.mapper_type_exists?('foo').should be_true
        Spreadsheet.mapper_type_exists?('foo_required_field').should be_true
      end

      it "should return false if the supplied mapper type doesn't exist" do
        Spreadsheet.mapper_type_exists?('bar').should be_false
        Spreadsheet.mapper_type_exists?('').should be_false
        Spreadsheet.mapper_type_exists?(nil).should be_false
      end

      it "should not care about pluralization" do
        Spreadsheet.mapper_type_exists?('singular_widget').should be_true
        Spreadsheet.mapper_type_exists?('singular_widgets').should be_true
        Spreadsheet.mapper_type_exists?('plural_widget').should be_true
        Spreadsheet.mapper_type_exists?('plural_widgets').should be_true
        Spreadsheet.mapper_type_exists?('foos').should be_true
        Spreadsheet.mapper_type_exists?('foo_required_fields').should be_true
      end
    end
  end
end
