class CreateVideos < ActiveRecord::Migration[8.0]
  def change
    create_table :videos do |t|
      t.string :title_pt, null: false
      t.string :title_es, null: false
      t.text :description_pt, null: false
      t.text :description_es, null: false
      t.string :url, null: false
      t.string :slug, null: false
      t.references :author, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :videos, :slug, unique: true
  end
end
