json.extract! book_history, :id, :book_id, :library_id, :student_id, :action, :created_at, :updated_at
json.url book_history_url(book_history, format: :json)
