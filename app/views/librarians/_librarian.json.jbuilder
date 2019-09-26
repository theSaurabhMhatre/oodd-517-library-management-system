json.extract! librarian, :id, :email, :name, :password, :is_approved, :created_at, :updated_at
json.url librarian_url(librarian, format: :json)
