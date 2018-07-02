class CreateTextures < ActiveRecord::Migration[5.1]
  def change
    create_table :textures do |t|
      t.integer :profile_id
      t.string :hash
      t.string :type
      t.string :model
      t.timestamps null: false
    end
  end
end
