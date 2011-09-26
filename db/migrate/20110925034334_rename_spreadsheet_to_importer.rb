class RenameSpreadsheetToImporter < ActiveRecord::Migration
  def up
    rename_table :importable_spreadsheets, :importable_importers
  end

  def down
    rename_table :importable_importers, :importable_spreadsheets
  end
end
