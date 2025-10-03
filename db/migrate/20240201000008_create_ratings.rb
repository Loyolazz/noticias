class CreateRatings < ActiveRecord::Migration[8.0]
  def change
    create_table :ratings do |t|
      t.references :user, null: false, foreign_key: true
      t.references :rateable, null: false, polymorphic: true
      t.integer :value, null: false, default: 0

      t.timestamps
    end

    add_index :ratings, [:user_id, :rateable_type, :rateable_id], unique: true, name: "index_ratings_on_user_and_rateable"
  end
end
