class CreateLibrarians < ActiveRecord::Migration[5.2]
  def change
    create_table :librarians do |t|
      t.references :university, foreign_key: true
      t.references :library, foreign_key: true
      t.string :email
      t.string :name
      t.string :password_digest
      t.integer :is_approved

      t.timestamps
    end
  end
end
