class AddMetadataToSpreeCustomerReturns < ActiveRecord::Migration[6.1]
  def change
    add_column :spree_customer_returns, :public_metadata, :text
    add_column :spree_customer_returns, :private_metadata, :text
  end
end
