module Importable
  class Validator < ActiveModel::Validator
    def validate(spreadsheet)
      if spreadsheet.file.try(:current_path)
        spreadsheet.mapper.invalid_objects.each do |object, line_number|
          object.errors.messages.each do |error|
            field, errors = *error
            errors.each do |message|
              spreadsheet.errors[field] << "#{message} (line #{line_number})"
            end
          end
        end
      end
    end
  end
end
