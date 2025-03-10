class UpdateSingleUseLinksColumnNames < ActiveRecord::Migration[7.2]
  def change
    rename_column :single_use_links, :downloadKey, :download_key
    rename_column :single_use_links, :itemId, :item_id
  end
end
