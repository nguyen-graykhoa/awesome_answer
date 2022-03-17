class RemoveLikeCountFromQuestion < ActiveRecord::Migration[7.0]
  def change
    remove_column :questions, :like_count, :integer
  end
end
