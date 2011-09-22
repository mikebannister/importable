module Importable
  class ViewsGenerator < Rails::Generators::NamedBase
    source_root File.expand_path('../../../../../app/views/importable', __FILE__)
    argument :name, :type => :string, :default => ''

    def copy_view_files

      files = %w[
        _actions
        _choose_worksheet_step
        _errors
        _extras
        _upload_file_step
        new
        show
      ]

      files.each do |file|
        from_path = "spreadsheets/#{file}.html.erb"
        path_parts = []
        path_parts.unshift("importable/spreadsheets/#{file}.html.erb")
        # include the name as a namespace if it's not blank
        path_parts.unshift(name) unless name.blank?
        to_path = File.join('app/views', *path_parts)
        copy_file from_path, to_path
      end
    end
  end
end
