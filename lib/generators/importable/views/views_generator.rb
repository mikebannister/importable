module Importable
  class ViewsGenerator < Rails::Generators::NamedBase
    source_root File.expand_path('../../../../../app/views/importable', __FILE__)
    argument :name, :type => :string, :default => ''

    def copy_view_files

      files = %w[
        _actions
        _choose_worksheet_step
        _errors
        _upload_file_step
        new
        show
      ]

      namespace = "#{name}/" unless name.blank?

      files.each do |file|
        from_path = "spreadsheets/#{file}.html.erb"
        to_path = "app/views/importable/spreadsheets/#{namespace}#{file}.html.erb"
        copy_file from_path, to_path
      end
    end
  end
end
