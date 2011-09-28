require 'spec_helper'

describe Importable do
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
      import_params = {
        'method' => 'bars'
      }
      FooResource.expects(:get).with(:bars, params: {})

      Importable::Resource.new(mapper_name: 'foo_resource', import_params: import_params).rows
    end

    it "should use params[:import_params] as params to the api method" do
      import_params = {
        'method' => 'bars',
        'start_date' => '2010-04-14',
        'end_date' => '2010-04-15'
      }
      request_params = {'start_date' => '2010-04-14', 'end_date' => '2010-04-15'}

      FooResource.expects(:get).with(:bars, params: request_params)

      Importable::Resource.new(mapper_name: 'foo_resource', import_params: import_params).rows
    end
  end
  
  describe "#resource_class" do
    it "returns the associated resource class" do
      resource_class = Importable::Resource.new(mapper_name: 'foo_resource').resource_class
      resource_class.should eq FooResource
    end
  end
end
