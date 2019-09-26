class CreateLibraries < ActiveRecord::Migration[5.2]
  def change
    create_table :libraries do |t|
      t.references :university, foreign_key: true
      t.string :name
      t.string :location
      t.integer :max_days
      t.float :overdue_fine

      t.timestamps
    end
  end
end
