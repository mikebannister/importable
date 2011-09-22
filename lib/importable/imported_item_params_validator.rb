module Importable
  class ImportedItemParamsValidator < ActiveModel::Validator
    attr_reader :spreadsheet

    def validate(spreadsheet)
      @spreadsheet = spreadsheet
      required_params.each do |required|
        spreadsheet.errors[:base] << required[:message] if import_params[required[:name]].blank?
      end
    end
    
    private

    def import_params
      spreadsheet.import_params || {}
    end

    def required_params
      mapper_class.required_params
    end

    def mapper_class
      spreadsheet.mapper_class
    end
  end
end
