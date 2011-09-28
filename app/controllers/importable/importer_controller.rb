module Importable
  class ImporterController < ::ApplicationController
    before_filter :require_type_param
    before_filter :prepend_map_specific_view_path

    def new
      @importer = importer_class.new(mapper_name: @type)
    end
  
    def show
      @importer = importer_class.find(params[:id])
    end

    def importer_class
      "Importable::#{importer_name}".constantize
    end

    def importer_name
      params[:controller].split('/').last.singularize.camelize
    end

    def require_type_param
      unless Mapper.mapper_type_exists?(params[:type])
        raise ParamRequiredError.new("#{params[:type]} import mapper does not exist")
      end
      @type = params[:type]
    end

    def prepend_map_specific_view_path
      prepend_view_path File.join(Rails.root, 'app/views', @type.pluralize)
    end
    
    def init_import_params
      @importer.import_params = params[:import_params] if params[:import_params]
    end

    def return_url
      index_path_sym = "#{@type.pluralize}_path".to_sym
      controller_name = params[:controller].split('/').last

      if params[:return_to] == 'index' and self.respond_to?(index_path_sym)
        main_app.send(index_path_sym)
      elsif params[:return_to] == 'import'
        new_importable_path = "new_#{controller_name.singularize}_path".to_sym
        send(new_importable_path, type: @type)
      else
        importable_path = "#{controller_name.singularize}_path".to_sym
        send(importable_path, id: @importer.id, type: @type)
      end
    end
  end
end
