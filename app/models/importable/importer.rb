module Importable
  class Importer < ActiveRecord::Base
    include MultiStep::ImportHelpers

    attr_writer :import_params
    delegate :invalid_items, :to => :mapper

    validates_with Importable::ImportedItemParamsValidator
    validates_with Importable::ImportedItemsValidator, :if => :imported_items_ready?

    def import!
      #TODO: help
      mapper.valid?
    end

    def import_params
      @import_params || {}
    end

    def mapper
      @mapper ||= mapper_class.new(rows, import_params)
    end

    def mapper_class
      singular_mapper_class || plural_mapper_class
    end

    def singular_mapper_class
      "#{mapper_name_with_module.singularize}_mapper".camelize.constantize rescue nil
    end

    def plural_mapper_class
      "#{mapper_name_with_module.pluralize}_mapper".camelize.constantize rescue nil
    end

    def mapper_name_with_module
      mapper_name.sub('-', '/')
    end

    def imported_items_ready?
      true
    end
  end
end
