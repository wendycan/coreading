class RenameTypeToArticles < ActiveRecord::Migration
  def change
    rename_column :articles, :type, :path_type
  end
end
