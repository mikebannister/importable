require 'spec_helper'

module Importable
  describe ResourcesController do
    describe "POST create" do
      describe "#init_resource" do
        before do
          @resource_importer = FooImporter.create!(mapper_name: 'foo')
          Resource.stubs(:new).returns(@resource_importer)
        end

        it "should assign the new resource as @importer" do
          post :create, type: 'foo', :use_route => :importable
          assigns(:importer).should eq @resource_importer
        end

        it "should assign the import_params to @importer#import_params" do
          import_params = { 'find' => 'all', 'start_date' => '2010-04-14', 'end_date' => '2010-04-15' }
          post :create, type: 'foo', import_params: import_params, :use_route => :importable

          assigns(:importer).import_params.should eq import_params
        end
      end
    end
  end
end
