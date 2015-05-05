class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :title
      t.text :desc
      t.integer :count, default: 0
      t.integer :admin_id

      t.timestamps
    end
  end
end
