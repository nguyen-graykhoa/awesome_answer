class AddLikeCountToQuestion < ActiveRecord::Migration[7.0]
  def change
    add_column :questions, :like_count, :integer
  end
end
