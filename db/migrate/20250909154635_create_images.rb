class CreateImages < ActiveRecord::Migration[8.0]
  def change
    create_table :images do |t|
      t.string :name
      t.string :description
      t.references :album, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
