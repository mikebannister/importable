module MultiStep
  module ImportHelpers
    attr_writer :current_step

    def steps
      %w[ upload_file choose_worksheet import_data ]
    end

    def current_step
      @current_step || steps.first
    end

    def next_step
      distance = 1
      # skip choose worksheet step if there's only 1 worksheet
      if self.current_step == 'upload_file' and self.sheets.length <= 1
        distance = 2
      end
      self.current_step = steps[steps.index(current_step) + distance]
    end

    def previous_step
      distance = 1
      # skip choose worksheet step if there's only 1 worksheet
      if self.current_step == 'import_data' and self.sheets.length <= 1
        distance = 2
      end
      self.current_step = steps[steps.index(current_step) - distance]
    end

    def first_step?
      current_step == steps.first
    end

    def last_step?
      current_step == steps.last
    end
  end
end
