# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_07_11_071950) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "key_availables", force: :cascade do |t|
    t.string "key_code", null: false
    t.serial "number_to_convert", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key_code"], name: "index_key_availables_on_key_code"
  end

  create_table "key_useds", force: :cascade do |t|
    t.string "key_code", null: false
    t.serial "number_to_convert", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key_code"], name: "index_key_useds_on_key_code"
  end

  create_table "shortener_urls", force: :cascade do |t|
    t.string "original_url", null: false
    t.string "key_code", null: false
    t.datetime "expired_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key_code"], name: "index_shortener_urls_on_key_code"
  end

end
