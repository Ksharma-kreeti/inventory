class UpdateUsers < ActiveRecord::Migration
  def change
    remove_column :users, :encrypted_password, :string
    remove_column :users, :reset_password_token, :string
    remove_column :users, :reset_password_sent_at, :datetime
    remove_column :users, :remember_created_at, :datetime
    remove_column :users, :sign_in_count, :integer
    remove_column :users, :current_sign_in_at, :datetime
    remove_column :users, :last_sign_in_at, :datetime
    remove_column :users, :current_sign_in_ip, :string
    remove_column :users, :last_sign_in_ip, :string
    remove_column :users, :admin, :boolean
    remove_column :users, :phone, :string
    add_column :users, :access_token, :string, null: false
    add_column :users, :google_uid, :string, null: false
    change_column_null :users, :first_name, false
    change_column_default :users, :email, from: "", to: nil
  end
end
