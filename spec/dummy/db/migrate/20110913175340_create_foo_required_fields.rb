class CreateFooRequiredFields < ActiveRecord::Migration
  def change
    create_table :foo_required_fields do |t|
      t.integer :moof
      t.integer :doof

      t.timestamps
    end
  end
end
