json.extract! book_count, :id, :book_id, :library_id, :book_copies, :created_at, :updated_at
json.url book_count_url(book_count, format: :json)
