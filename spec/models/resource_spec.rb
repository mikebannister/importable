require 'spec_helper'

describe Importable do
  describe "#rows" do
    it "should return a list of resources" do
      start_fake_foo_api!

      rows = Importable::Resource.new(mapper_name: 'foo_resource').rows
      rows.should have_exactly(3).items
    end
  end
  
  describe "#resource_class" do
    it "returns the associated resource class" do
      resource_class = Importable::Resource.new(mapper_name: 'foo_resource').resource_class
      resource_class.should eq FooResource
    end
  end
end
