module Importable
  class Resource < Importer
    def rows
      method = import_params.delete('method')
      if method
        resource_class.get(method.to_sym, import_params)
      else
        resource_class.all(params: import_params)
      end
    end

    def resource_class
      mapper_name_with_module.camelize.constantize
    end
  end
end
