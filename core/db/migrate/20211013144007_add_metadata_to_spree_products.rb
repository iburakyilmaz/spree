class AddMetadataToSpreeProducts < ActiveRecord::Migration[6.1]
  def change
    add_column :spree_products, :public_metadata, :text
    add_column :spree_products, :private_metadata, :text
  end
end
