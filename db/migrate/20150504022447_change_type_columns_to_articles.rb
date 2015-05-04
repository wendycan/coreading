class ChangeTypeColumnsToArticles < ActiveRecord::Migration
  def change
    change_column :articles, :path_type, :string, :default => 'pdf'
  end
end
