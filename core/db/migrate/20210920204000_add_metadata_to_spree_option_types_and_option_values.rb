class AddMetadataToSpreeOptionTypesAndOptionValues < ActiveRecord::Migration[6.1]
  def change
    add_column :spree_option_types, :public_metadata, :text
    add_column :spree_option_types, :private_metadata, :text

    add_column :spree_option_values, :public_metadata, :text
    add_column :spree_option_values, :private_metadata, :text
  end
end
