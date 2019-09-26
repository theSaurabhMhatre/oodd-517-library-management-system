class CreateBooks < ActiveRecord::Migration[5.2]
  def change
    create_table :books do |t|
      t.string :isbn
      t.string :title
      t.string :author
      t.string :language
      t.date :published
      t.string :edition
      t.string :image
      t.string :subject
      t.text :summary
      t.string :is_special

      t.timestamps
    end
  end
end
