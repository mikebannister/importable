class CreateFooImporters < ActiveRecord::Migration
  def change
    create_table :foo_importers do |t|
      t.string :type
      t.string :mapper_name

      t.timestamps
    end
  end
end
