class AddPdfToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :pdf, :string
    add_column :articles, :type, :string
    add_column :articles, :public, :boolean
    add_column :articles, :user_id, :integer
  end
end
