class CreateStudents < ActiveRecord::Migration[5.2]
  def change
    create_table :students do |t|
      t.references :university, foreign_key: true
      t.string :email
      t.string :name
      t.string :password_digest
      t.string :edu_level
      t.integer :book_limit

      t.timestamps
    end
  end
end
