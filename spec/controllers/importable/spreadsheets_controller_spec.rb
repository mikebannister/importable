require 'spec_helper'

module Importable
  describe SpreadsheetsController do
    context "spreadsheet uploaded" do
      let(:multi_spreadsheet_file) { File.open support_file('foo_multi_worksheet.xlsx') }
      let(:multi_spreadsheet) { Spreadsheet.create!(file: multi_spreadsheet_file, mapper_name: 'foo') }
      let(:single_spreadsheet_file) { File.open support_file('foo_single_worksheet.xlsx') }
      let(:single_spreadsheet) { Spreadsheet.create!(file: single_spreadsheet_file, mapper_name: 'foo') }
      let(:spreadsheet_new) { Spreadsheet.new(file: multi_spreadsheet_file, mapper_name: 'foo') }

      describe "POST create" do
        describe "choose worksheet step" do
          before do
            spreadsheet_new # load
            Spreadsheet.stubs(:new).returns(spreadsheet_new)
          end

          describe "#init_spreadsheet" do
            it "should assign the new spreadsheet as @importer" do
              post :create, type: 'foo', current_step: 'upload_file', :use_route => :importable
              assigns(:importer).should eq spreadsheet_new
            end
          end

          describe "#set_current_step" do
            it "should set the current_step to 'choose_worksheet' on @imported_spreadsheet" do
              post :create, type: 'foo', current_step: 'upload_file', :use_route => :importable
              assigns(:importer).current_step.should eq 'choose_worksheet'
            end
          end
          
          describe "#prepare_next_step" do
            it "should save the @imported_spreadsheet" do
              spreadsheet_new.expects(:save)
              post :create, type: 'foo', current_step: 'upload_file', :use_route => :importable
            end
          
            it "should set the next step to 'choose_worksheet'" do
              post :create, type: 'foo', current_step: 'upload_file', :use_route => :importable
              assigns(:importer).current_step.should eq 'choose_worksheet'
            end
          end
        end

        describe "import data" do
          describe "#set_current_step" do
            it "should set the current_step to 'import_data' on @imported_spreadsheet" do
              post :create, type: 'foo', current_step: 'choose_worksheet', id: multi_spreadsheet.id, :use_route => :importable
              assigns(:importer).current_step.should eq 'import_data'
            end
          end
          
          describe "#prepare_next_step" do
            it "should not save the @imported_spreadsheet" do
              multi_spreadsheet.expects(:save).times(0)
              post :create, type: 'foo', current_step: 'choose_worksheet', id: multi_spreadsheet.id, :use_route => :importable
            end
          
            it "should set the next step to 'import_data'" do
              post :create, type: 'foo', current_step: 'choose_worksheet', id: multi_spreadsheet.id, :use_route => :importable
              assigns(:importer).current_step.should eq 'import_data'
            end
          
            it "should set the next step to 'upload_file' if the back button is pressed" do
              post :create, type: 'foo', current_step: 'choose_worksheet', id: multi_spreadsheet.id, back_button: 1, :use_route => :importable
              assigns(:importer).current_step.should eq 'upload_file'
            end
          end

          describe "import successfull" do
            it "should set the default sheet if specified" do
              post :create, type: 'foo', current_step: 'choose_worksheet', id: multi_spreadsheet.id, default_sheet: 1, :use_route => :importable
              assigns(:importer).default_sheet.should eq 'Sheet2'
            end
            
            it "should parse the default sheet if specified" do
              post :create, type: 'foo', current_step: 'choose_worksheet', id: multi_spreadsheet.id, default_sheet: 1, :use_route => :importable
              assigns(:importer).headers.should eq %w[ q r s t ]
            end
            
            it "should use the first sheet if non are specified" do
              post :create, type: 'foo', current_step: 'choose_worksheet', id: multi_spreadsheet.id, :use_route => :importable
              assigns(:importer).default_sheet.should eq 'Sheet1'
            end
            
            it "should redirect with appropriate flash message for a multi workbook spreadsheet" do
              multi_spreadsheet.stubs(:import!).returns(true)
              post :create, type: 'foo', current_step: 'choose_worksheet', id: multi_spreadsheet.id, :use_route => :importable
              flash[:notice].should eq "Sheet1 worksheet of foo spreadsheet was successfully imported."
            end
            
            it "should redirect with appropriate flash message for a single workbook spreadsheet" do
              single_spreadsheet.stubs(:import!).returns(true)
              post :create, type: 'foo', current_step: 'choose_worksheet', id: single_spreadsheet.id, :use_route => :importable
              flash[:notice].should eq "Foo spreadsheet was successfully imported."
            end

            describe "existing uploaded spreadsheet" do
              before do
                multi_spreadsheet # load
                Spreadsheet.stubs(:find).returns(multi_spreadsheet)
              end

              it "should call import! on the @importer" do
                multi_spreadsheet.expects(:import!)
                post :create, type: 'foo', current_step: 'choose_worksheet', id: multi_spreadsheet.id, :use_route => :importable
              end
              
              it "should prevent the current step from changing if import is unsuccessful" do
                multi_spreadsheet.stubs(:import!).returns(false)
                post :create, type: 'foo', current_step: 'choose_worksheet', id: multi_spreadsheet.id, :use_route => :importable
                assigns(:importer).current_step.should eq 'choose_worksheet'
              end
              
              it "should render 'new' if the file upload is invalid" do
                multi_spreadsheet.stubs(:valid?).returns(false)
                post :create, type: 'foo', current_step: 'choose_worksheet', id: multi_spreadsheet.id, :use_route => :importable
                response.should render_template("spreadsheets/new")
              end
            end
          end
        end
      end
    end
  end
end
