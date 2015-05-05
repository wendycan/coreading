class AddArticlesToGroup < ActiveRecord::Migration
  def change
    add_column :groups, :articles_count, :integer
  end
end
