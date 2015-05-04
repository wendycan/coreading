class ChangeColumnsToArticles < ActiveRecord::Migration
  def change
    change_column :articles, :public, :integer, :default => 0
    change_column :articles, :path_type, :string, :default => 'online'
  end
end
