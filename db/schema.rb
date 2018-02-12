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

ActiveRecord::Schema.define(version: 20180218213027) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "access_tokens", force: :cascade do |t|
    t.bigint "user_id"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_access_tokens_on_user_id"
  end

  create_table "permissions", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "project_id"
    t.boolean "read", default: true, null: false
    t.boolean "write", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_permissions_on_project_id"
    t.index ["user_id"], name: "index_permissions_on_user_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "export"
    t.text "description"
    t.string "backup_name", null: false
    t.index ["name"], name: "index_projects_on_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.datetime "expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin"
  end

  add_foreign_key "access_tokens", "users"
  add_foreign_key "permissions", "projects"
  add_foreign_key "permissions", "users"

  create_view "credentials",  sql_definition: <<-SQL
      SELECT users.id AS user_id,
      users.email,
      access_tokens.password_digest
     FROM (access_tokens
       JOIN users ON ((access_tokens.user_id = users.id)))
  UNION
   SELECT users.id AS user_id,
      users.email,
      users.password_digest
     FROM users;
  SQL

end
