class AddRestorePasswordHash < ActiveRecord::Migration
  def change
    add_column :authorizations, :restore_password_hash, :string
    add_column :authorizations, :restore_password_hash_created, :datetime

    add_index :authorizations, [:id, :restore_password_hash, :restore_password_hash_created], name: 'auth_password_restore_idx'
  end
end