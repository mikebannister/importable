class CreateFooRelations < ActiveRecord::Migration
  def change
    create_table :foo_relations do |t|
      t.timestamps
    end
  end
end
