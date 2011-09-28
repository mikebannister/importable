require 'spec_helper'

class FooImporter <  Importable::Importer
  attr_accessor :mapper_name

  def rows 
    []
  end
end

describe Importable do
  
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
    importer.mapper_name = 'foo'
    importer.should be_valid
  end
  
  it "should be invalid if the required params are not present" do
    importer.mapper_name = 'foo_required_param'
    importer.should_not be_valid
  end

  describe "#import!" do
    it "should initialize a mapper to handle the actual importing" do
      importer.mapper_name = 'foo'

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
      importer.mapper_name = 'foo'
      mapper_class = importer.mapper_class
      mapper_class.should eq FooMapper

      importer.mapper_name = 'foo_required_field'
      mapper_class = importer.mapper_class
      mapper_class.should eq FooRequiredFieldMapper
    end
  
    it "should return the mapper class for importer with module name indicated by dash in the mapper name" do
      importer.mapper_name = 'bar-moof'
      mapper_class = importer.mapper_class
      mapper_class.should eq Bar::MoofMapper
    end
  
    it "should not care if the mappers have pluralization" do
      importer.mapper_name = 'singular_widgets'
      importer.mapper_class.should eq SingularWidgetMapper

      importer.mapper_name = 'singular_widget'
      importer.mapper_class.should eq SingularWidgetMapper

      importer.mapper_name = 'plural_widgets'
      importer.mapper_class.should eq PluralWidgetsMapper

      importer.mapper_name = 'plural_widget'
      importer.mapper_class.should eq PluralWidgetsMapper
    end
  end
  
  describe "#mapper" do
    it "should return the mapper instance for the spreadsheet" do
      importer.mapper_name = 'foo'
      importer.mapper.should be_a FooMapper
    end
  end
end
