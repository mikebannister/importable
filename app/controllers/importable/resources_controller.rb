module Importable
  class ResourcesController < ImporterController
    def create
      started_at = Time.now

      init_resource
      init_import_params

      if @importer.save and @importer.import!
        redirect_to return_url, notice: return_notice, flash: { start: started_at.to_f, end: Time.now.to_f }
        return
      end

      # if not redirected
      render action: 'new'
    end

    private

    def return_notice
      "#{@importer.mapper.data.count} #{importer_type.pluralize} were successfully imported."
    end

    def importer_type
      @type.sub('-', ' ').humanize
    end

    def init_resource
      resource_attributes = {
        mapper_name: params[:type],
        import_params: params[:import_params]
      }
      @importer = Importable::Resource.new(resource_attributes)
    end
  end
end
