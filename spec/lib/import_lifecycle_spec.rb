require 'spec_helper'

module Importable
  class FooImporter < Importer
    attr_accessor :object_type

    def rows 
      []
    end
  end

  describe ImportLifecycle do
    
    let(:data) do
      [
        {
          moof: 1,
          doof: 2
        },
        {
          moof: 3,
          doof: 4
        },
        {
          moof: 5,
          doof: 6
        }
      ]
    end

    let(:importer) { FooImporter.new }
    
    it "should be valid if the required params are present" do
      importer.object_type = 'foo'
      importer.should be_valid
    end
    
    it "should be invalid if the required params are not present" do
      importer.object_type = 'foo_required_param'
      importer.should_not be_valid
    end

    describe "#import!" do
      it "should initialize a mapper to handle the actual importing" do
        importer.object_type = 'foo'

        mapper = FooMapper.new(data)
        FooMapper.expects(:new).returns(mapper)

        importer.import!
      end
    end
    
    describe "#imported_items_ready?" do
      it "should be true by default" do
        importer.imported_items_ready?.should be_true
      end
    end
    
    describe "#mapper_class" do
      it "should return the mapper class for the importer" do
        importer.object_type = 'foo'
        mapper_class = importer.mapper_class
        mapper_class.should eq FooMapper

        importer.object_type = 'foo_required_field'
        mapper_class = importer.mapper_class
        mapper_class.should eq FooRequiredFieldMapper
      end
    
      it "should not care if the mappers have pluralization" do
        importer.object_type = 'singular_widgets'
        importer.mapper_class.should eq SingularWidgetMapper

        importer.object_type = 'singular_widget'
        importer.mapper_class.should eq SingularWidgetMapper

        importer.object_type = 'plural_widgets'
        importer.mapper_class.should eq PluralWidgetsMapper

        importer.object_type = 'plural_widget'
        importer.mapper_class.should eq PluralWidgetsMapper
      end
    end
    
    describe "#mapper" do
      it "should return the mapper instance for the spreadsheet" do
        importer.object_type = 'foo'
        importer.mapper.should be_a FooMapper
      end
    end
    
    describe "self#mapper_files" do
      it "should list the available mapper files" do
        FooImporter.mapper_files[0].ends_with?('foo_mapper.rb').should be_true
        FooImporter.mapper_files[1].ends_with?('foo_required_field_mapper.rb').should be_true
      end
    end
    
    describe "self#mapper_types" do
      it "should list the available mapper types" do
        FooImporter.mapper_types[0].should eq 'foo'
        FooImporter.mapper_types[1].should eq 'foo_required_field'
      end
    end
    
    describe "self#mapper_type_exists?" do
      it "should return true if the supplied mapper type exists" do
        FooImporter.mapper_type_exists?('foo').should be_true
        FooImporter.mapper_type_exists?('foo_required_field').should be_true
      end
    
      it "should return false if the supplied mapper type doesn't exist" do
        FooImporter.mapper_type_exists?('bar').should be_false
        FooImporter.mapper_type_exists?('').should be_false
        FooImporter.mapper_type_exists?(nil).should be_false
      end
    
      it "should not care about pluralization" do
        FooImporter.mapper_type_exists?('singular_widget').should be_true
        FooImporter.mapper_type_exists?('singular_widgets').should be_true
        FooImporter.mapper_type_exists?('plural_widget').should be_true
        FooImporter.mapper_type_exists?('plural_widgets').should be_true
        FooImporter.mapper_type_exists?('foos').should be_true
        FooImporter.mapper_type_exists?('foo_required_fields').should be_true
      end
    end
  end
end
