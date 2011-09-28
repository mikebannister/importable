module Importable
  class Importer < ActiveRecord::Base
    include MultiStep::ImportHelpers

    attr_accessor :import_params
    delegate :invalid_items, :to => :mapper

    validates_with Importable::ImportedItemParamsValidator
    validates_with Importable::ImportedItemsValidator, :if => :imported_items_ready?

    def import!
      #TODO: help
      mapper.valid?
    end

    def mapper
      @mapper ||= mapper_class.new(rows, import_params)
    end

    def mapper_class
      singular_mapper_class || plural_mapper_class
    end

    def singular_mapper_class
      "#{mapper_name.singularize}_mapper".camelize.constantize rescue nil
    end

    def plural_mapper_class
      "#{mapper_name.pluralize}_mapper".camelize.constantize rescue nil
    end
    
    def imported_items_ready?
      true
    end

    class << self

      def mapper_files
        Dir["#{Rails.root}/app/imports/**.rb"].sort
      end

      def mapper_types
        mapper_files.map do |mapper_file|
          file_name = File.basename(mapper_file, '.rb')
          mapper_name = file_name.slice(0..-8) if file_name.ends_with?('_mapper')
          mapper_name.try(:singularize)
        end.compact
      end

      def mapper_type_exists?(type)
        mapper_types.flat_map do |t|
          [ t.pluralize, t.singularize ]
        end.include?(type)
      end
    end
  end
end
