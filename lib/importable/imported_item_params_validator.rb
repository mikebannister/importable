module Importable
  class ImportedItemParamsValidator < ActiveModel::Validator
    attr_reader :importer

    def validate(importer)
      @importer = importer
      required_params.each do |required|
        importer.errors[:base] << required[:message] if import_params[required[:name]].blank?
      end
    end

    private

    def import_params
      importer.import_params || {}
    end

    def required_params
      mapper_class.required_params
    end

    def mapper_class
      importer.mapper_class
    end
  end
end
