class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :user_id
      t.integer :article_id
      t.string :ty
      t.integer :si
      t.integer :ei
      t.text :sm
      t.timestamps
    end
  end
end
