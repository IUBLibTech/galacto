class CreateTinymceAssets < ActiveRecord::Migration[7.2]
  def change
    create_table :tinymce_assets do |t|
      t.string :file
      t.timestamps null: false
    end
  end
end
