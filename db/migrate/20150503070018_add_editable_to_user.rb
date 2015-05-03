class AddEditableToUser < ActiveRecord::Migration
  def change
    add_column :users, :editable, :boolean, default: false
  end
end
