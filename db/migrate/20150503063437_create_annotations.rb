class CreateAnnotations < ActiveRecord::Migration
  def change
    create_table :annotations do |t|
      t.integer :user_id
      t.text :text
      t.text :quote
      t.string :tag
      t.text :range
      t.integer :article_id

      t.timestamps
    end
  end
end
