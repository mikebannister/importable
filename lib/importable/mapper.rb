module Importable
  class Mapper
    attr_accessor :raw_data
    attr_accessor :data
    attr_accessor :invalid_items

    def initialize(data, params={})
      @params = params
      @raw_data = data
      @invalid_items = []

      before_mapping
      map_to_objects
      after_mapping
      validate_items
      save_items
    end

    class << self

      attr_accessor :from_mappings

      def require_param(name, message)
        @required_params ||= []
        @required_params << {
          name: name,
          message: message
        }
      end

      def required_params
        @required_params || []
      end

      def mapper_root
        "#{Rails.root}/app/imports"
      end

      def mapper_types
        Dir["#{mapper_root}/**/*.rb"].map do |file|
          offset = mapper_root.length + 1
          file.slice(offset..-11)
        end.sort
      end

      def mapper_type_exists?(type)
        type = type.try(:sub, '-', '/')

        mapper_types.flat_map do |t|
          [ t.pluralize, t.singularize ]
        end.include?(type)
      end

      def register_from_mapping(from, to)
        @from_mappings ||= {}
        @from_mappings[from] = to
      end

      def method_missing(sym, *args, &block)
        if sym.to_s.ends_with('_maps_from')
          from = sym.to_s.slice(0...-10).to_sym
          options = args.second || {}

          register_from_mapping(from, args.first)
          return
        end

        super(sym, *args, &block)
      end
    end

    def before_mapping
    end

    def after_mapping
    end

    def map_row
      raise NotImplementedError.new('map_row method must be overriden by mapper')
    end

    def valid?
      @invalid_items.empty?
    end

    def map_to_objects
      @data = @raw_data.flat_map do |raw_row|
        row = if raw_row.instance_of?(Hash)
          Importable::Row.from_hash(raw_row)
        else
          Importable::Row.from_resource(raw_row)
        end
        map_row(row)
      end
    end

    def save_items
      if valid?
        @data.each { |object| object.save! if object.new_record? }
      end
    end

    def validate_items
      @data.each_with_index do |object, index|
        line_number = index + 2
        @invalid_items << [object, line_number] unless object.valid?
      end
    end

    def original_value_for(line_number, field)
      if self.class.from_mappings
        original_key = self.class.from_mappings[field]
        if original_key
          line = @raw_data[line_number - 2]
          line[original_key.to_s]
        end
      end
    end

    def method_missing(sym, *args, &block)
      return @params[sym] if !!@params[sym]
      super(sym, *args, &block)
    end
  end
end
