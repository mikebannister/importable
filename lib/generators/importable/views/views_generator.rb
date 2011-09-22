module Importable
  class ViewsGenerator < Rails::Generators::NamedBase
    source_root File.expand_path('../../../../../app/views/importable', __FILE__)
    argument :name, :type => :string, :default => 'views'

    def copy_view_files
      empty_directory "app/views/importable/spreadsheets"
      copy_file "spreadsheets/_actions.erb", "app/views/importable/spreadsheets/_actions.erb"
      copy_file "spreadsheets/_choose_worksheet_step.erb", "app/views/importable/spreadsheets/_choose_worksheet_step.erb"
      copy_file "spreadsheets/_errors.erb", "app/views/importable/spreadsheets/_errors.erb"
      copy_file "spreadsheets/_form.html.erb", "app/views/importable/spreadsheets/_form.html.erb"
      copy_file "spreadsheets/_upload_file_step.erb", "app/views/importable/spreadsheets/_upload_file_step.erb"
      copy_file "spreadsheets/new.html.erb", "app/views/importable/spreadsheets/new.html.erb"
      copy_file "spreadsheets/show.html.erb", "app/views/importable/spreadsheets/show.html.erb"
    end
  end
end
