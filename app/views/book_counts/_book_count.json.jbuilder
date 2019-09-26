json.extract! book_count, :id, :book_id, :library_id, :count, :created_at, :updated_at
json.url book_count_url(book_count, format: :json)
