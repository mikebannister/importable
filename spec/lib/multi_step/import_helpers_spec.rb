require 'spec_helper'

module MultiStep
  class FooMultiStepImport
    include MultiStep::ImportHelpers
  
    def sheets
      # multiple fake sheets
      [nil, nil]
    end
  end

  describe ImportHelpers do
    let(:foo_multi_step_import) { FooMultiStepImport.new }
  
    describe "#steps" do
      it "should return a list of import steps" do
        steps = foo_multi_step_import.steps
        steps[0].should eq 'upload_file'
        steps[1].should eq 'choose_worksheet'
        steps[2].should eq 'import_data'
      end
    end

    describe "#current_step" do
      it "should initially return 'upload_file'" do
        foo_multi_step_import.current_step.should eq 'upload_file'
      end

      it "should return whatever the current step is set to" do
        foo_multi_step_import.current_step = 'moof'
        foo_multi_step_import.current_step.should eq 'moof'
      end
    end
  
    describe "#first_step?" do
      it "should return true if current step is 'upload_file'" do
        foo_multi_step_import.current_step = 'upload_file'
        foo_multi_step_import.first_step?.should be_true
        foo_multi_step_import.current_step = 'moof'
        foo_multi_step_import.first_step?.should be_false
      end
    end

    describe "#last_step?" do
      it "should return true if current step is 'import_data'" do
        foo_multi_step_import.current_step = 'import_data'
        foo_multi_step_import.last_step?.should be_true
        foo_multi_step_import.current_step = 'moof'
        foo_multi_step_import.last_step?.should be_false
      end
    end
  
    describe "#next_step" do
      it "should step through each available step" do
        foo_multi_step_import.current_step.should eq 'upload_file'
        foo_multi_step_import.next_step
        foo_multi_step_import.current_step.should eq 'choose_worksheet'
        foo_multi_step_import.next_step
        foo_multi_step_import.current_step.should eq 'import_data'
      end

      it "should step skip choosing worksheet if there's only one" do
        foo_multi_step_import.stub(:sheets).and_return(['one fake worksheet'])

        foo_multi_step_import.current_step.should eq 'upload_file'
        foo_multi_step_import.next_step
        foo_multi_step_import.current_step.should eq 'import_data'
      end
    end
  
    describe "#previous_step" do
      before do
        # fast forward
        foo_multi_step_import.current_step = 'import_data'
      end
    
      it "should step through each available step backwards" do
        foo_multi_step_import.previous_step
        foo_multi_step_import.current_step.should eq 'choose_worksheet'
        foo_multi_step_import.previous_step
        foo_multi_step_import.current_step.should eq 'upload_file'
      end

      it "should step skip choosing worksheet if there's only one" do
        foo_multi_step_import.stub(:sheets).and_return(['one fake worksheet'])

        foo_multi_step_import.current_step.should eq 'import_data'
        foo_multi_step_import.previous_step
        foo_multi_step_import.current_step.should eq 'upload_file'
      end
    end
  end
end
