class CreateContentBlocks < ActiveRecord::Migration[7.2]
  def change
    create_table :content_blocks do |t|
      t.string :name
      t.text :value
      t.timestamps null: false
    end
    add_index :content_blocks, :name, unique: true
  end
end
