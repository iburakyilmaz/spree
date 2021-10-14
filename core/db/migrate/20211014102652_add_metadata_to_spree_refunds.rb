class AddMetadataToSpreeRefunds < ActiveRecord::Migration[6.1]
  def change
    add_column :spree_refunds, :public_metadata, :text
    add_column :spree_refunds, :private_metadata, :text
  end
end
