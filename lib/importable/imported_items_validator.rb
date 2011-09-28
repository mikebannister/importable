module Importable
  class ImportedItemsValidator < ActiveModel::Validator
    def validate(importer)
      # don't bother if there are already validation errors
      return if importer.errors[:base].any?

      importer.invalid_items.each do |object, line_number|
        object.errors.messages.each do |error|
          field, errors = *error
          errors.each do |message|
            importer.errors[field] << "#{message} (line #{line_number})"
          end
        end
      end
    end
  end
end
