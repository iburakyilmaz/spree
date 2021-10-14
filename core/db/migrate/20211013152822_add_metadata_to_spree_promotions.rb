class AddMetadataToSpreePromotions < ActiveRecord::Migration[6.1]
  def change
    add_column :spree_promotions, :public_metadata, :text
    add_column :spree_promotions, :private_metadata, :text
  end
end
