class AddMetadataToSpreeShipments < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_shipments, :public_metadata, :text
    add_column :spree_shipments, :private_metadata, :text
  end
end
