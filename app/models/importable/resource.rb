module Importable
  class Resource < Importer
    def rows
      resource_class.all
    end
    
    def resource_class
      mapper_name.camelize.constantize
    end
  end
end
