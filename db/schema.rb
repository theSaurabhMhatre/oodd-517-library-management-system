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

ActiveRecord::Schema.define(version: 2019_09_26_220743) do

  create_table "admins", force: :cascade do |t|
    t.string "email"
    t.string "name"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "book_counts", force: :cascade do |t|
    t.integer "book_id"
    t.integer "library_id"
    t.integer "book_copies"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_book_counts_on_book_id"
    t.index ["library_id"], name: "index_book_counts_on_library_id"
  end

  create_table "book_histories", force: :cascade do |t|
    t.integer "book_id"
    t.integer "library_id"
    t.integer "student_id"
    t.string "action"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_book_histories_on_book_id"
    t.index ["library_id"], name: "index_book_histories_on_library_id"
    t.index ["student_id"], name: "index_book_histories_on_student_id"
  end

  create_table "book_requests", force: :cascade do |t|
    t.integer "book_id"
    t.integer "library_id"
    t.integer "student_id"
    t.string "request_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_book_requests_on_book_id"
    t.index ["library_id"], name: "index_book_requests_on_library_id"
    t.index ["student_id"], name: "index_book_requests_on_student_id"
  end

  create_table "books", force: :cascade do |t|
    t.string "isbn"
    t.string "title"
    t.string "author"
    t.string "language"
    t.date "published"
    t.string "edition"
    t.string "image"
    t.string "subject"
    t.text "summary"
    t.string "is_special"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "librarians", force: :cascade do |t|
    t.integer "university_id"
    t.integer "library_id"
    t.string "email"
    t.string "name"
    t.string "password_digest"
    t.integer "is_approved"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["library_id"], name: "index_librarians_on_library_id"
    t.index ["university_id"], name: "index_librarians_on_university_id"
  end

  create_table "libraries", force: :cascade do |t|
    t.integer "university_id"
    t.string "name"
    t.string "location"
    t.integer "max_days"
    t.float "overdue_fine"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["university_id"], name: "index_libraries_on_university_id"
  end

  create_table "students", force: :cascade do |t|
    t.integer "university_id"
    t.string "email"
    t.string "name"
    t.string "password_digest"
    t.string "edu_level"
    t.integer "book_limit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["university_id"], name: "index_students_on_university_id"
  end

  create_table "universities", force: :cascade do |t|
    t.string "name"
    t.string "city"
    t.string "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
