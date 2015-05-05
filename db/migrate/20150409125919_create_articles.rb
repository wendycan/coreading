class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string  :title
      t.text    :body
      t.string  :pdf
      t.string  :path_type, :default => 'pdf'
      t.integer :user_id
      t.integer :public, :default => 0

      t.timestamps
    end
  end
end
