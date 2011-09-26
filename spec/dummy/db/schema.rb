# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110925054334) do

  create_table "foo_importers", :force => true do |t|
    t.string   "type"
    t.string   "mapper_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "foo_required_fields", :force => true do |t|
    t.integer  "moof"
    t.integer  "doof"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "foos", :force => true do |t|
    t.integer  "moof"
    t.integer  "doof"
    t.integer  "a"
    t.integer  "b"
    t.integer  "c"
    t.integer  "d"
    t.integer  "q"
    t.integer  "r"
    t.integer  "s"
    t.integer  "t"
    t.date     "foobar_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "importable_importers", :force => true do |t|
    t.string   "file"
    t.string   "mapper_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
  end

end
