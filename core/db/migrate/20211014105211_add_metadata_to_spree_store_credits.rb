class AddMetadataToSpreeStoreCredits < ActiveRecord::Migration[6.1]
  def change
    add_column :spree_store_credits, :public_metadata, :text
    add_column :spree_store_credits, :private_metadata, :text
  end
end
