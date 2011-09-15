module Importable
  class SpreadsheetsController < ApplicationController
    before_filter :require_type_param

    def new
      @spreadsheet = Spreadsheet.new
    end

    def create
      init_spreadsheet!

      if @spreadsheet.valid?
        set_current_step!
        prepare_next_step!

        if @spreadsheet.last_step?
          if import!
            notice = "'#{@spreadsheet.default_sheet}' of #{@type} spreadsheet was successfully imported."
            redirect_to spreadsheet_path(id: @spreadsheet.id, type: @type), notice: notice
            return
          end
          @spreadsheet.previous_step
        end
      end

      # if not redirected
      render action: 'new'
    end

    def show
      @spreadsheet = Spreadsheet.find(params[:id])
    end

    private

    def init_spreadsheet!
      @spreadsheet = begin
        if params[:current_step] == 'upload_file'
          Spreadsheet.new(file: params[:file], object_type: params[:type])
        else
          Spreadsheet.find(params[:spreadsheet_id])
        end
      end
    end

    def set_current_step!
      @spreadsheet.current_step = params[:current_step]
    end

    def prepare_next_step!
      if @spreadsheet.persisted? or @spreadsheet.save
        if params[:back_button]
          @spreadsheet.previous_step
        else
          @spreadsheet.next_step
        end
        params[:current_step] = @spreadsheet.current_step
      end
    end

    def import!
      default_sheet = @spreadsheet.sheets[params[:default_sheet].to_i]
      @spreadsheet.default_sheet = default_sheet
      @spreadsheet.import!
    end

    def require_type_param
      unless Spreadsheet.mapper_type_exists?(params[:type])
        raise Exceptions::ParamRequiredError.new("#{params[:type]} import mapper does not exist")
      end
      @type = params[:type]
    end
  end
end
