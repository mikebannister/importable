module Importable
  class ImportedItemsValidator < ActiveModel::Validator
    def validate(importer)
      # don't bother if there are already validation errors
      return if importer.errors[:base].any?

      mapper = importer.mapper

      importer.invalid_items.each do |object, line_number|
        object.errors.messages.each do |error|
          field, errors = *error
          errors.each do |original_message|

            original_val = mapper.original_value_for(line_number, field)

            message = if original_val
              if importer.class == Spreadsheet
                "on line #{line_number} could not be found: #{original_val}"
              else
                "could not be found: #{original_val}"
              end
            else
              "on line #{line_number} #{original_message}"
            end

            importer.errors[field] << message
          end
        end
      end
    end
  end
end
