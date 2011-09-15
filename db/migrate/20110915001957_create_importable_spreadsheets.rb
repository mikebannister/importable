class CreateImportableSpreadsheets < ActiveRecord::Migration
  def change
    create_table :importable_spreadsheets do |t|
      t.string :file
      t.string :object_type

      t.timestamps
    end
  end
end
