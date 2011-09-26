class AddTypeToSpreadsheet < ActiveRecord::Migration
  def up
    add_column :importable_importers, :type, :string
  end

  def down
    remove_column :importable_importers, :type
  end
end
