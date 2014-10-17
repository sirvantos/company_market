class AddConfirmationHash < ActiveRecord::Migration
  def change
    add_column :authorizations, :confirmation_hash, :string, unique: true, default: nil
    add_index :authorizations, [:confirmation_hash], unique: true
  end
end
