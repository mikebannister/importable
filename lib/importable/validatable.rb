module Importable
  module Validatable
    extend ActiveSupport::Concern

    included do
      include ActiveModel::Validations
      include ActiveModel::Serialization

      attr_accessor :attributes
    end
    
    module InstanceMethod
      def initialize(attributes = {})
        @attributes = attributes
      end

      def read_attribute_for_validation(key)
        @attributes[key]
      end
    end
  end
end
