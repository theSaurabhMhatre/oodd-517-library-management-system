json.extract! book, :id, :isbn, :title, :author, :language, :published, :edition, :image, :subject, :summary, :is_special, :created_at, :updated_at
json.url book_url(book, format: :json)
