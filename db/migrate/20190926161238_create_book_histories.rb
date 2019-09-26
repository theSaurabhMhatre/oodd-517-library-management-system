class CreateBookHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :book_histories do |t|
      t.references :book, foreign_key: true
      t.references :library, foreign_key: true
      t.references :student, foreign_key: true
      t.string :action

      t.timestamps
    end
  end
end
