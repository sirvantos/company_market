class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :nickname, null: false
      t.string :remember_token

      t.timestamps
    end

    add_index :users, [:remember_token]
    add_index :users, [:email], unique: true
  end
end
