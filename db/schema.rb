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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_05_07_020433) do

  create_table "api_keys", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "user_id"
    t.string "access_token", limit: 191
    t.datetime "expire_at"
    t.integer "source"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["access_token"], name: "index_api_keys_on_access_token"
    t.index ["user_id"], name: "index_api_keys_on_user_id"
  end

  create_table "fileds", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "form_id"
    t.boolean "must_in"
    t.string "name"
    t.boolean "default"
    t.boolean "repeat"
    t.boolean "is_case"
    t.text "extra"
    t.string "label"
    t.string "f_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "forms", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name"
    t.integer "user_id"
    t.string "notes"
    t.string "takon"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "settings", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "var", null: false
    t.text "value"
    t.integer "thing_id"
    t.string "thing_type", limit: 30
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["thing_type", "thing_id", "var"], name: "index_settings_on_thing_type_and_thing_id_and_var", unique: true
  end

  create_table "user_data", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name"
    t.string "date"
    t.string "file"
    t.string "number"
    t.string "select"
    t.string "text"
    t.string "textarea"
    t.integer "form_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "uid"
  end

  create_table "users", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "login", limit: 40
    t.string "name", limit: 100, default: ""
    t.string "email", limit: 100
    t.string "avatar"
    t.string "phone", limit: 100
    t.boolean "available"
    t.string "uid", limit: 40
    t.string "number", limit: 191
    t.string "uuid", limit: 18
    t.string "gender"
    t.integer "category"
    t.integer "syn"
    t.text "school_ids"
    t.integer "status", default: 0
    t.string "remember_token", limit: 40
    t.datetime "remember_token_expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["login"], name: "index_users_on_login"
    t.index ["number"], name: "index_users_on_number"
  end

  create_table "values", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "filed_id"
    t.string "content"
    t.integer "userid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
