json.extract! student, :id, :email, :name, :password, :edu_level, :book_limit, :created_at, :updated_at
json.url student_url(student, format: :json)
