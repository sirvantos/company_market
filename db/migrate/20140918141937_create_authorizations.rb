class CreateAuthorizations < ActiveRecord::Migration
  def change
    create_table :authorizations do |t|
      t.string :provider, null: false
      t.string :uid, null: false
      t.integer :user_id
      t.datetime :expires_at
      t.string :auth_token
      t.string :password_digest

      t.timestamps
    end

    add_index :authorizations, [:provider, :user_id, :password_digest], unique: true, name: 'auth_provider_user_id_password_digest_idx'
    add_index :authorizations, [:provider, :uid], unique: true
  end
end
