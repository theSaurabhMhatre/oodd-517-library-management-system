class CreateBookRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :book_requests do |t|
      t.references :book, foreign_key: true
      t.references :library, foreign_key: true
      t.references :student, foreign_key: true
      t.string :request_type

      t.timestamps
    end
  end
end
