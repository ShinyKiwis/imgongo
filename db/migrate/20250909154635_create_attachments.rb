class CreateAttachments < ActiveRecord::Migration[8.0]
  def change
    create_table :attachments do |t|
      t.string :name
      t.string :description
      t.string :file_type
      t.references :album, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
