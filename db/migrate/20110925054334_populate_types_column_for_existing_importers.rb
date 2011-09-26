class PopulateTypesColumnForExistingImporters < ActiveRecord::Migration
  def up
    Importable::Importer.where(type: nil).update_all(type: 'spreadsheet')
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "Can't reverse populate type columns"
  end
end
