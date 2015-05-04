class AddArticleToAnnotion < ActiveRecord::Migration
  def change
    add_column :annotations, :article_id, :integer
  end
end
