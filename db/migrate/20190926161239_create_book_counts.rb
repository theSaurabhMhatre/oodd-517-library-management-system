class CreateBookCounts < ActiveRecord::Migration[5.2]
  def change
    create_table :book_counts do |t|
      t.references :book, foreign_key: true
      t.references :library, foreign_key: true
      t.integer :book_copies

      t.timestamps
    end
  end
end
