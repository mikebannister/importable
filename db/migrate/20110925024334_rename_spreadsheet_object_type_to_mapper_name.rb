class RenameSpreadsheetObjectTypeToMapperName < ActiveRecord::Migration
  def up
    rename_column :importable_spreadsheets, :object_type, :mapper_name
  end

  def down
    rename_column :importable_spreadsheets, :mapper_name, :object_type
  end
end
