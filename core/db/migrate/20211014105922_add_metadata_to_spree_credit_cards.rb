class AddMetadataToSpreeCreditCards < ActiveRecord::Migration[6.1]
  def change
    add_column :spree_credit_cards, :public_metadata, :text
    add_column :spree_credit_cards, :private_metadata, :text
  end
end
