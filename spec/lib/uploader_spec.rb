require 'spec_helper'

module Importable
  describe Uploader do

    let(:importable_spreadsheet) { Spreadsheet.new }

    before do
      Importable::Uploader.enable_processing = false
      @uploader = Importable::Uploader.new(importable_spreadsheet, :file)
    end

    after do
      Importable::Uploader.enable_processing = true
    end

    it "should not allow storing files that are not Excel spreadsheets" do
      text_file = File.open support_file('text.txt')

      lambda {
        @uploader.store!(text_file)
      }.should raise_error(
        CarrierWave::IntegrityError,
        'You are not allowed to upload "txt" files, allowed types: ["xls", "xlsx"]'
      )
    end
  end
end
