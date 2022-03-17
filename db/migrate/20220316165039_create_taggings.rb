class CreateTaggings < ActiveRecord::Migration[7.0]
  def change
    create_table :taggings do |t|
      t.references :question, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true
      t.string :name

      t.timestamps
    end
  end
end
