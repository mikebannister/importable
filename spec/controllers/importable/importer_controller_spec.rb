require 'spec_helper'

module Importable

  class FooImporterController < ImporterController
    def create
      @importer = FooImporter.new(mapper_name: 'foo')

      init_import_params

      if @importer.fake_valid?
        redirect_to(return_url)
        return
      end

      # if not redirected
      render :new
    end

    def new_foo_importer_path(path)
      '/fake_new_foo_importer_path'
    end

    def foo_importer_path(path)
      '/fake_foo_importer_path'
    end
  end

  describe FooImporterController do
    let(:importer) { FooImporter.create!(mapper_name: 'foo') }

    describe "POST create" do
      describe "#init_import_params" do
        it "should set import_params on the importer from params[:import_params]" do
          post :create, import_params: { moof: 1 }, type: 'foo', :use_route => :importable
          assigns(:importer).import_params.should eq ({ 'moof' => '1' })
        end
      end
    end
    
    describe "GET new" do
      it "should assign a new importer as @importer" do
        get :new, type: 'foo', :use_route => :importable
        assigns(:importer).should be_a FooImporter
      end
    
      it "should assign the importer's type as @type" do
        get :new, type: 'foo', :use_route => :importable
        assigns(:type).should eq 'foo'
      end
    
      it "should raise a params exception if the mapper type is not valid" do
        expect {
          get :new, type: 'bar', :use_route => :importable
        }.to raise_error(ParamRequiredError, 'bar import mapper does not exist')
      end
    
      it "should use the base import template by default" do
        get :new, type: 'foo', :use_route => :importable
        response.should render_template("importable/foo_importer/new")
      end
    
      describe "with rendered views" do
        render_views
        it "should use the mapper specific template if it exists" do
          get :new, type: 'moof', :use_route => :importable
          response.body.should have_content 'foo importer content'
        end
      end
    end

    describe "POST create" do
      describe "#return_url" do
        it "should redirect to the show view if import is successful" do
          post :create, type: 'foo', id: importer.id, :use_route => :importable
          response.should redirect_to("/fake_foo_importer_path")
        end
        
        it "should redirect to the object type's index view if import is successful and params[:return_to] is set to index" do
          post :create, type: 'foo', id: importer.id, return_to: 'index', :use_route => :importable
          response.should redirect_to("/foos")
        end
        
        it "should redirect back to the import view if import is successful and params[:return_to] is set to import" do
          post :create, type: 'foo', id: importer.id, return_to: 'import', :use_route => :importable
          response.should redirect_to("/fake_new_foo_importer_path")
        end

        it "should render 'new' if import is unsuccessful" do
          FooImporter.any_instance.stubs(:fake_valid?).returns(false)

          post :create, type: 'foo', id: importer.id, :use_route => :importable
          response.should render_template("importable/foo_importer/new")
        end
      end
    end

    describe "GET show" do
      it "should assign the importer identified by params[:id] as @importer" do
        get :show, type: 'foo', id: importer.id, :use_route => :importable
        assigns(:importer).should eq importer
      end
    end
  end
end
