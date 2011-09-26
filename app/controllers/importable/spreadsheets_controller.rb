module Importable
  class SpreadsheetsController < ImporterController
    def create
      init_spreadsheet
      init_import_params
      set_default_sheet

      if @importer.save
        set_current_step
        prepare_next_step

        if @importer.last_step?
          if @importer.import!
            notice = if @importer.sheets.one?
              "#{@type.humanize} spreadsheet was successfully imported."
            else
              "#{@importer.default_sheet} worksheet of #{@type} spreadsheet was successfully imported."
            end
            redirect_to return_url, notice: notice
            return
          end
          @importer.previous_step
        end
      end

      # if not redirected
      render action: 'new'
    end

    private

    def import_template
      class_based_template if template_exists?(class_based_template)
    end

    def class_based_template
      File.join('importable/spreadsheets', @type.pluralize, params[:action])
    end

    def init_spreadsheet
      @importer = if params[:current_step] == 'upload_file'
        Spreadsheet.new(file: params[:file], mapper_name: params[:type])
      else
        Spreadsheet.find(params[:id])
      end
    end

    def set_current_step
      @importer.current_step = params[:current_step]
    end

    def prepare_next_step
      if params[:back_button]
        @importer.previous_step
      else
        @importer.next_step
      end
      params[:current_step] = @importer.current_step
    end

    def set_default_sheet
      if params[:default_sheet]
        default_sheet = @importer.sheets[params[:default_sheet].to_i]
        @importer.default_sheet = default_sheet
      end
    end
  end
end
