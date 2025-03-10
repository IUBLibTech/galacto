class AddExternalKeyToContentBlocks < ActiveRecord::Migration[7.2]
  def change
    add_column :content_blocks, :external_key, :string
    remove_index :content_blocks, :name
  end
end
