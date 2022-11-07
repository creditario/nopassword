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

ActiveRecord::Schema[7.0].define(version: 2022_01_25_215037) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "no_password_sessions", force: :cascade do |t|
    t.datetime "expires_at"
    t.datetime "claimed_at"
    t.string "token", null: false
    t.string "user_agent", null: false
    t.string "remote_addr", null: false
    t.string "return_url"
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end
end
