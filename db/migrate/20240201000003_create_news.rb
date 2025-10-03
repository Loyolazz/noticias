class CreateNews < ActiveRecord::Migration[8.0]
  def change
    create_table :news do |t|
      t.string :title_pt, null: false
      t.string :title_es, null: false
      t.text :body_pt, null: false
      t.text :body_es, null: false
      t.string :slug, null: false
      t.references :author, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :news, :slug, unique: true
  end
end
