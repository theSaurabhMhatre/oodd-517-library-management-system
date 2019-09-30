json.extract! book_request, :id, :book_id, :library_id, :student_id, :request_type, :created_at, :updated_at
json.url book_request_url(book_request, format: :json)
