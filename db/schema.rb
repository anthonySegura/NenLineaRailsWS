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

ActiveRecord::Schema.define(version: 20171009030117) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "sesions", force: :cascade do |t|
    t.integer "n_partidas"
    t.integer "tam_tablero"
    t.integer "tiempo_espera"
    t.integer "n2win"
    t.string "tipo"
    t.string "estado"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_sesions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "nickname"
    t.string "password"
    t.integer "puntuacion"
    t.integer "categoria"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "puntos", default: 0
  end

  create_table "usuarios", force: :cascade do |t|
    t.string "nombre"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "sesions", "users"
end
