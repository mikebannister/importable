module Importable
  class Resource < Importer
    def rows
      method = import_params.delete('method')
      request_params = { params: import_params }

      if method
        resource_class.get(method.to_sym, request_params)
      else
        resource_class.all(request_params)
      end
    end

    def resource_class
      mapper_name.sub('-', '/').camelize.constantize
    end
  end
end
