module Importable
  class Mapper
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
        line_number = (index + 2)
        @invalid_items << [object, line_number] unless object.valid?
      end
    end

    def method_missing(sym, *args, &block)
      return @params[sym] if !!@params[sym]
      super(sym, *args, &block)
    end
  end
end
