require 'spec_helper'

module Importable
  describe ResourcesController do
    describe "POST create" do
      describe "#init_resource" do
        it "should assign the new resource as @importer" do
          resource_importer = FooImporter.create!(mapper_name: 'foo')
          Resource.stubs(:new).returns(resource_importer)

          post :create, type: 'foo', :use_route => :importable
          assigns(:importer).should eq resource_importer
        end
      end
    end
  end
end
