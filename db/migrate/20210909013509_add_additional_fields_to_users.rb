class AddAdditionalFieldsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :first_name, :string, before: :email
    add_column :users, :last_name, :string, before: :email
    add_column :users, :phone, :string, after: :email
  end
end
