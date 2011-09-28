require 'spec_helper'

describe Importable::Resource do
  describe "#rows" do
    it "should call the all method on the underlying resource" do
      FooResource.expects(:all).with(params: {})

      Importable::Resource.new(mapper_name: 'foo_resource', import_params: {}).rows
    end

    it "should call the all method on the underlying resource and params should be passed to the REST method" do
      FooResource.expects(:all).with(params: {'moof' => 'toof'})

      Importable::Resource.new(mapper_name: 'foo_resource', import_params: {'moof' => 'toof'}).rows
    end

    it "should return a list of all resources by default" do
      FooResource.expects(:all).with(params: {})

      Importable::Resource.new(mapper_name: 'foo_resource', import_params: {}).rows
    end

    it "should use params[:import_params][:method] to call a custom REST method on the underlying resource" do
      import_params = { 'method' => 'top_five' }

      FooResource.expects(:get).with(:top_five, {})

      Importable::Resource.new(mapper_name: 'foo_resource', import_params: import_params).rows
    end

    it "should use params[:import_params] as params for custom REST method" do
      request_params = { 'order' => 'asc' }
      import_params = { 'method' => 'top_five' }
      all_params = import_params.merge(request_params)

      FooResource.expects(:get).with(:top_five, request_params)

      Importable::Resource.new(mapper_name: 'foo_resource', import_params: all_params).rows
    end
  end

  describe "#resource_class" do
    it "returns the associated resource class" do
      resource_class = Importable::Resource.new(mapper_name: 'foo_resource').resource_class
      resource_class.should eq FooResource
    end

    it "returns the associated resource class with module name indicated by dash in the mapper name" do
      module MoofModule
        class MoofClass
        end
      end
      resource_class = Importable::Resource.new(mapper_name: 'moof_module-moof_class').resource_class
      resource_class.should eq MoofModule::MoofClass
    end
  end
end
