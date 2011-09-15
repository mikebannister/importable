require 'spec_helper'

module Importable
  describe SpreadsheetsController do
    describe "GET new" do
      it "assigns a new importable spreadsheet as @spreadsheet" do
        get :new, type: 'foo', :use_route => :importable
        assigns(:spreadsheet).should be_a Spreadsheet
      end
  
      it "assigns the spreadsheet type as @type" do
        get :new, type: 'foo', :use_route => :importable
        assigns(:type).should eq 'foo'
      end
  
      it "raises params exception if the mapper type is not valid" do
        expect {
          get :new, type: 'bar', :use_route => :importable
        }.to raise_error(Exceptions::ParamRequiredError, 'bar import mapper does not exist')
      end
    end

    context "spreadsheet uploaded" do
      let(:spreadsheet_file) { File.open support_file('foo_multi_worksheet.xlsx') }
      let(:spreadsheet) { Spreadsheet.create!(file: spreadsheet_file, object_type: 'foo') }
      let(:spreadsheet_new) { Spreadsheet.new(file: spreadsheet_file, object_type: 'foo') }

      describe "POST create" do
        context "choose worksheet step" do
          before do
            spreadsheet_new # load
            Spreadsheet.stub!(:new).and_return(spreadsheet_new)
          end

          context "#init_spreadsheet!" do
            it "assigns the new spreadsheet as @spreadsheet" do
              post :create, type: 'foo', current_step: 'upload_file', :use_route => :importable
              assigns(:spreadsheet).should eq spreadsheet
            end
          end
  
          context "#set_current_step!" do
            it "sets the current_step to 'choose_worksheet' on @imported_spreadsheet" do
              post :create, type: 'foo', current_step: 'upload_file', :use_route => :importable
              assigns(:spreadsheet).current_step.should eq 'choose_worksheet'
            end
          end

          context "#prepare_next_step!" do
            it "should save the @imported_spreadsheet" do
              spreadsheet_new.should_receive(:save)
              post :create, type: 'foo', current_step: 'upload_file', :use_route => :importable
            end

            it "should set the next step to 'choose_worksheet'" do
              post :create, type: 'foo', current_step: 'upload_file', :use_route => :importable
              assigns(:spreadsheet).current_step.should eq 'choose_worksheet'
            end
          end
        end

        context "parse and map" do
          context "#init_spreadsheet!" do
            it "assigns the existing spreadsheet as @spreadsheet" do
              post :create, type: 'foo', current_step: 'choose_worksheet', spreadsheet_id: spreadsheet.id, :use_route => :importable
              assigns(:spreadsheet).should eq spreadsheet
            end
          end

          context "#set_current_step!" do
            it "sets the current_step to 'import_data' on @imported_spreadsheet" do
              post :create, type: 'foo', current_step: 'choose_worksheet', spreadsheet_id: spreadsheet.id, :use_route => :importable
              assigns(:spreadsheet).current_step.should eq 'import_data'
            end
          end

          context "#prepare_next_step!" do
            it "should not save the @imported_spreadsheet" do
              spreadsheet.should_not_receive(:save)
              post :create, type: 'foo', current_step: 'choose_worksheet', spreadsheet_id: spreadsheet.id, :use_route => :importable
            end
          
            it "should set the next step to 'import_data'" do
              post :create, type: 'foo', current_step: 'choose_worksheet', spreadsheet_id: spreadsheet.id, :use_route => :importable
              assigns(:spreadsheet).current_step.should eq 'import_data'
            end
          
            it "should set the next step to 'upload_file' if the back button is pressed" do
              post :create, type: 'foo', current_step: 'choose_worksheet', spreadsheet_id: spreadsheet.id, back_button: 1, :use_route => :importable
              assigns(:spreadsheet).current_step.should eq 'upload_file'
            end
          end

          context "#import!" do
            it "should set the default sheet if specified" do
              post :create, type: 'foo', current_step: 'choose_worksheet', spreadsheet_id: spreadsheet.id, default_sheet: 1, :use_route => :importable
              assigns(:spreadsheet).default_sheet.should eq 'Sheet2'
            end

            it "should use the first sheet if non are specified" do
              post :create, type: 'foo', current_step: 'choose_worksheet', spreadsheet_id: spreadsheet.id, :use_route => :importable
              assigns(:spreadsheet).default_sheet.should eq 'Sheet1'
            end

            context "existing uploaded spreadsheet" do
              before do
                spreadsheet # load
                Spreadsheet.stub!(:find).and_return(spreadsheet)
              end

              it "should call import! on the @spreadsheet" do
                spreadsheet.should_receive(:import!)
                post :create, type: 'foo', current_step: 'choose_worksheet', spreadsheet_id: spreadsheet.id, :use_route => :importable
              end

              it "should redirect to the show view if import is successful" do
                spreadsheet.stub(:import!).and_return(true)
                post :create, type: 'foo', current_step: 'choose_worksheet', spreadsheet_id: spreadsheet.id, :use_route => :importable
                response.should redirect_to("/importable/foo/#{spreadsheet.id}")
              end

              it "should render 'new' if import is unsuccessful" do
                spreadsheet.stub(:import!).and_return(false)
                post :create, type: 'foo', current_step: 'choose_worksheet', spreadsheet_id: spreadsheet.id, :use_route => :importable
                response.should render_template("spreadsheets/new")
              end

              it "should prevent the current step from changing if import is unsuccessful" do
                spreadsheet.stub(:import!).and_return(false)
                post :create, type: 'foo', current_step: 'choose_worksheet', spreadsheet_id: spreadsheet.id, :use_route => :importable
                assigns(:spreadsheet).current_step.should eq 'choose_worksheet'
              end

              it "should render 'new' if the file upload is invalid" do
                spreadsheet.stub(:valid?).and_return(false)
                post :create, type: 'foo', current_step: 'choose_worksheet', spreadsheet_id: spreadsheet.id, :use_route => :importable
                response.should render_template("spreadsheets/new")
              end
            end
          end
        end
      end

      describe "GET show" do
        it "assigns the importable spreadsheet identified by params[:id] as @spreadsheet" do
          get :show, type: 'foo', id: spreadsheet.id, :use_route => :importable
          assigns(:spreadsheet).should eq spreadsheet
        end
      end
    end
  end
end
