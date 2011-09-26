class CreateFoos < ActiveRecord::Migration
  def change
    create_table :foos do |t|
      t.integer :moof
      t.integer :doof

      t.integer :a
      t.integer :b
      t.integer :c
      t.integer :d

      t.integer :q
      t.integer :r
      t.integer :s
      t.integer :t

      t.date :foobar_date

      t.timestamps
    end
  end
end
