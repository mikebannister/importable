module Importable
  class ResourcesController < ImporterController
    def create
      init_resource
      init_import_params

      if @importer.save and @importer.import!
        importer_type = @type.sub('-', ' ').humanize
        redirect_to return_url, notice: "#{importer_type} was successfully imported."
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
