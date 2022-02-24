# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_02_24_103252) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "human_resources", force: :cascade do |t|
    t.bigint "project_id"
    t.string "name"
    t.integer "instances"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["project_id"], name: "index_human_resources_on_project_id"
  end

  create_table "organization_users", force: :cascade do |t|
    t.bigint "organization_id"
    t.bigint "user_id"
    t.index ["organization_id"], name: "index_organization_users_on_organization_id"
    t.index ["user_id"], name: "index_organization_users_on_user_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "projects", force: :cascade do |t|
    t.bigint "organization_id"
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["organization_id"], name: "index_projects_on_organization_id"
  end

  create_table "schedule_tasks", force: :cascade do |t|
    t.bigint "project_id"
    t.bigint "task_resource_id"
    t.integer "start_date"
    t.integer "end_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["project_id"], name: "index_schedule_tasks_on_project_id"
    t.index ["task_resource_id"], name: "index_schedule_tasks_on_task_resource_id"
  end

  create_table "task_precedences", force: :cascade do |t|
    t.bigint "task_id"
    t.bigint "required_task_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["required_task_id"], name: "index_task_precedences_on_required_task_id"
    t.index ["task_id"], name: "index_task_precedences_on_task_id"
  end

  create_table "task_resources", force: :cascade do |t|
    t.bigint "project_id"
    t.bigint "task_id"
    t.bigint "human_resource_id"
    t.integer "duration"
    t.integer "capacity"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["human_resource_id"], name: "index_task_resources_on_human_resource_id"
    t.index ["project_id"], name: "index_task_resources_on_project_id"
    t.index ["task_id"], name: "index_task_resources_on_task_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.bigint "project_id"
    t.string "title"
    t.string "description"
    t.integer "instances"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["project_id"], name: "index_tasks_on_project_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password_digest"
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "telephone"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
