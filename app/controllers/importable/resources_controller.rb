module Importable
  class ResourcesController < ImporterController
    def create
      init_resource
      init_import_params

      if @importer.save and @importer.import!
        redirect_to return_url, notice: "#{@type.humanize} was successfully imported."
        return
      end
      
      # if not redirected
      render action: 'new'
    end

    private

    def init_resource
      resource_attributes = {
        mapper_name: params[:type],
        import_params: params[:import_params]
      }
      @importer = Importable::Resource.new(resource_attributes)
    end
  end
end
