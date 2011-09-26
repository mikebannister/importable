module Importable
  class Spreadsheet < Importer
    delegate :first_row, :last_row, :sheets, :row, :to => :spreadsheet

    mount_uploader :file, Importable::Uploader

    validates_presence_of :file

    def headers
      @headers ||= spreadsheet.row(first_row)
    end

    def default_sheet=(sheet)
      @imported_items_ready = true
      spreadsheet.default_sheet = sheet
    end

    def default_sheet
      spreadsheet.default_sheet
    end

    def spreadsheet
      @spreadsheet ||= spreadsheet_class.new(file.current_path)
    end

    def spreadsheet_class
      extension = file.current_path.split('.').last
      return Excel if extension == 'xls'
      return Excelx if extension == 'xlsx'
    end

    def imported_items_ready?
      @imported_items_ready or (file.current_path and sheets.length == 1)
    end

    def rows
      @rows ||= begin
        (first_row + 1).upto(last_row).map do |index|
          data = {}
          raw_data = row(index)
          headers.zip(raw_data) do |key, val|
            data[key] = val
          end
          data
        end
      end
    end
  end
end
