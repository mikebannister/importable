module Importable
  class Spreadsheet < ActiveRecord::Base
    include MultiStep::ImportHelpers

    delegate :first_row, :last_row, :sheets, :row, :to => :spreadsheet
    delegate :invalid_objects, :to => :mapper

    mount_uploader :file, Importable::Uploader

    validates_presence_of :file
    validates_with Importable::Validator

    def headers
      @headers ||= spreadsheet.row(first_row)
    end

    def default_sheet=(sheet)
      spreadsheet.default_sheet = sheet
    end

    def default_sheet
      spreadsheet.default_sheet
    end

    def spreadsheet
      @spreadsheet ||= spreadsheet_class.new(file.current_path)
    end

    def import!
      mapper.valid?
    end

    def mapper
      mapper_class.new(rows)
    end

    def mapper_class
      singular_mapper_class || plural_mapper_class
    end

    def spreadsheet_class
      extension = file.current_path.split('.').last
      return Excel if extension == 'xls'
      return Excelx if extension == 'xlsx'
    end

    def rows
      @rows ||= begin
        (first_row + 1).upto(last_row).map do |index|
          data = {}
          raw_data = row(index)
          headers.zip(raw_data) do |key, val|
            data[key] = val
          end
          data
        end
      end
    end

    def self.mapper_files
      Dir["#{Rails.root}/app/imports/**.rb"]
    end

    def self.mapper_types
      mapper_files.map do |mapper_file|
        file_name = File.basename(mapper_file, '.rb')
        mapper_name = file_name.slice(0..-8) if file_name.ends_with?('_mapper')
        mapper_name.try(:singularize)
      end.compact
    end

    def self.mapper_type_exists?(type)
      self.mapper_types.flat_map do |t|
        [ t.pluralize, t.singularize ]
      end.include?(type)
    end
  
    private
  
    def singular_mapper_class
      "#{object_type.singularize}_mapper".camelize.constantize rescue nil
    end

    def plural_mapper_class
      "#{object_type.pluralize}_mapper".camelize.constantize rescue nil
    end
  end
end
