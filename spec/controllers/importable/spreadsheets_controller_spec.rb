require 'spec_helper'

module Importable
  describe SpreadsheetsController do
    describe "GET new" do
      it "should assign a new importable spreadsheet as @spreadsheet" do
        get :new, type: 'foo', :use_route => :importable
        assigns(:spreadsheet).should be_a Spreadsheet
      end
  
      it "should assign the spreadsheet's type as @type" do
        get :new, type: 'foo', :use_route => :importable
        assigns(:type).should eq 'foo'
      end
  
      it "should raise a params exception if the mapper type is not valid" do
        expect {
          get :new, type: 'bar', :use_route => :importable
        }.to raise_error(Exceptions::ParamRequiredError, 'bar import mapper does not exist')
      end

      it "should use the base import template by default" do
        get :new, type: 'foo', :use_route => :importable
        response.should render_template("importable/spreadsheets/new")
      end

      describe "with rendered views" do
        render_views
        it "should use the mapper specific template if it exists" do
          override_import_templates('moofs') do
            get :new, type: 'moof', :use_route => :importable
            response.body.should have_content 'moofs content'
          end
        end
      end
    end

    context "spreadsheet uploaded" do
      let(:multi_spreadsheet_file) { File.open support_file('foo_multi_worksheet.xlsx') }
      let(:multi_spreadsheet) { Spreadsheet.create!(file: multi_spreadsheet_file, object_type: 'foo') }
      let(:single_spreadsheet_file) { File.open support_file('foo_single_worksheet.xlsx') }
      let(:single_spreadsheet) { Spreadsheet.create!(file: single_spreadsheet_file, object_type: 'foo') }
      let(:spreadsheet_new) { Spreadsheet.new(file: multi_spreadsheet_file, object_type: 'foo') }

      describe "POST create" do
        context "choose worksheet step" do
          before do
            spreadsheet_new # load
            Spreadsheet.stubs(:new).returns(spreadsheet_new)
          end

          context "#init_spreadsheet!" do
            it "should assign the new spreadsheet as @spreadsheet" do
              post :create, type: 'foo', current_step: 'upload_file', :use_route => :importable
              assigns(:spreadsheet).should eq multi_spreadsheet
            end
          end
  
          context "#set_current_step!" do
            it "should set the current_step to 'choose_worksheet' on @imported_spreadsheet" do
              post :create, type: 'foo', current_step: 'upload_file', :use_route => :importable
              assigns(:spreadsheet).current_step.should eq 'choose_worksheet'
            end
          end

          context "#prepare_next_step!" do
            it "should save the @imported_spreadsheet" do
              spreadsheet_new.expects(:save)
              post :create, type: 'foo', current_step: 'upload_file', :use_route => :importable
            end

            it "should set the next step to 'choose_worksheet'" do
              post :create, type: 'foo', current_step: 'upload_file', :use_route => :importable
              assigns(:spreadsheet).current_step.should eq 'choose_worksheet'
            end
          end
        end

        context "import data" do
          context "#init_spreadsheet!" do
            it "should assign the existing spreadsheet as @spreadsheet" do
              post :create, type: 'foo', current_step: 'choose_worksheet', spreadsheet_id: multi_spreadsheet.id, :use_route => :importable
              assigns(:spreadsheet).should eq multi_spreadsheet
            end
          end

          context "#set_current_step!" do
            it "should set the current_step to 'import_data' on @imported_spreadsheet" do
              post :create, type: 'foo', current_step: 'choose_worksheet', spreadsheet_id: multi_spreadsheet.id, :use_route => :importable
              assigns(:spreadsheet).current_step.should eq 'import_data'
            end
          end

          context "#prepare_next_step!" do
            it "should not save the @imported_spreadsheet" do
              multi_spreadsheet.expects(:save).times(0)
              post :create, type: 'foo', current_step: 'choose_worksheet', spreadsheet_id: multi_spreadsheet.id, :use_route => :importable
            end
          
            it "should set the next step to 'import_data'" do
              post :create, type: 'foo', current_step: 'choose_worksheet', spreadsheet_id: multi_spreadsheet.id, :use_route => :importable
              assigns(:spreadsheet).current_step.should eq 'import_data'
            end
          
            it "should set the next step to 'upload_file' if the back button is pressed" do
              post :create, type: 'foo', current_step: 'choose_worksheet', spreadsheet_id: multi_spreadsheet.id, back_button: 1, :use_route => :importable
              assigns(:spreadsheet).current_step.should eq 'upload_file'
            end
          end

          context "#import!" do
            it "should set the default sheet if specified" do
              post :create, type: 'foo', current_step: 'choose_worksheet', spreadsheet_id: multi_spreadsheet.id, default_sheet: 1, :use_route => :importable
              assigns(:spreadsheet).default_sheet.should eq 'Sheet2'
            end

            it "should parse the default sheet if specified" do
              post :create, type: 'foo', current_step: 'choose_worksheet', spreadsheet_id: multi_spreadsheet.id, default_sheet: 1, :use_route => :importable
              assigns(:spreadsheet).headers.should eq %w[ q r s t ]
            end

            it "should use the first sheet if non are specified" do
              post :create, type: 'foo', current_step: 'choose_worksheet', spreadsheet_id: multi_spreadsheet.id, :use_route => :importable
              assigns(:spreadsheet).default_sheet.should eq 'Sheet1'
            end

            it "should redirect with appropriate flash message for a multi workbook spreadsheet" do
              multi_spreadsheet.stubs(:import!).returns(true)
              post :create, type: 'foo', current_step: 'choose_worksheet', spreadsheet_id: multi_spreadsheet.id, :use_route => :importable
              flash[:notice].should eq "Sheet1 worksheet of foo spreadsheet was successfully imported."
            end

            it "should redirect with appropriate flash message for a single workbook spreadsheet" do
              single_spreadsheet.stubs(:import!).returns(true)
              post :create, type: 'foo', current_step: 'choose_worksheet', spreadsheet_id: single_spreadsheet.id, :use_route => :importable
              flash[:notice].should eq "Foo spreadsheet was successfully imported."
            end

            context "existing uploaded spreadsheet" do
              before do
                multi_spreadsheet # load
                Spreadsheet.stubs(:find).returns(multi_spreadsheet)
              end

              it "should call import! on the @spreadsheet" do
                multi_spreadsheet.expects(:import!)
                post :create, type: 'foo', current_step: 'choose_worksheet', spreadsheet_id: multi_spreadsheet.id, :use_route => :importable
              end

              it "should redirect to the show view if import is successful" do
                multi_spreadsheet.stubs(:import!).returns(true)
                post :create, type: 'foo', current_step: 'choose_worksheet', spreadsheet_id: multi_spreadsheet.id, :use_route => :importable
                response.should redirect_to("/importable/foo/#{multi_spreadsheet.id}")
              end

              it "should redirect to the object type's index view if import is successful and params[:return_to] is set to index" do
                multi_spreadsheet.stubs(:import!).returns(true)
                post :create, type: 'foo', current_step: 'choose_worksheet', spreadsheet_id: multi_spreadsheet.id, return_to: 'index', :use_route => :importable
                response.should redirect_to("/foos")
              end

              it "should render 'new' if import is unsuccessful" do
                multi_spreadsheet.stubs(:import!).returns(false)
                post :create, type: 'foo', current_step: 'choose_worksheet', spreadsheet_id: multi_spreadsheet.id, :use_route => :importable
                response.should render_template("spreadsheets/new")
              end

              it "should prevent the current step from changing if import is unsuccessful" do
                multi_spreadsheet.stubs(:import!).returns(false)
                post :create, type: 'foo', current_step: 'choose_worksheet', spreadsheet_id: multi_spreadsheet.id, :use_route => :importable
                assigns(:spreadsheet).current_step.should eq 'choose_worksheet'
              end

              it "should render 'new' if the file upload is invalid" do
                multi_spreadsheet.stubs(:valid?).returns(false)
                post :create, type: 'foo', current_step: 'choose_worksheet', spreadsheet_id: multi_spreadsheet.id, :use_route => :importable
                response.should render_template("spreadsheets/new")
              end
            end
          end
        end
      end

      describe "GET show" do
        it "should assign the importable spreadsheet identified by params[:id] as @spreadsheet" do
          get :show, type: 'foo', id: multi_spreadsheet.id, :use_route => :importable
          assigns(:spreadsheet).should eq multi_spreadsheet
        end
      end
    end
  end
end
