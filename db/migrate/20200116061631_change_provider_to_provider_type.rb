class ChangeProviderToProviderType < ActiveRecord::Migration[5.2]
  def change
    rename_column :payment_providers, :provider, :provider_type
  end
end
