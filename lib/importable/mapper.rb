module Importable
  class Mapper
    attr_accessor :data
    attr_accessor :invalid_objects
  
    def initialize(data)
      @raw_data = data
      @invalid_objects = []
    
      map_to_objects!
      validate_objects!
      save_objects!
    end

    def map_row
      raise NotImplementedError.new('map_row method must be overriden by mapper')
    end

    def valid?
      @invalid_objects.empty?
    end

    def map_to_objects!
      @data = @raw_data.flat_map do |raw_row|
        row = Importable::Row.new(raw_row)
        map_row(row)
      end
    end
  
    def save_objects!
      if valid?
        @data.each { |object| object.save! if object.new_record? } 
      end
    end

    def validate_objects!
      @data.each_with_index do |object, index|
        line_number = (index + 2)
        @invalid_objects << [object, line_number] unless object.valid?
      end
    end
  end
end
