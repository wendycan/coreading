class AddTokenToUser < ActiveRecord::Migration
  def change
    add_column :users, :authentication_token, :string
    add_column :users, :editable, :boolean, default: false
  end
end
