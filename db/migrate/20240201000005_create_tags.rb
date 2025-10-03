class CreateTags < ActiveRecord::Migration[8.0]
  def change
    create_table :tags do |t|
      t.string :name, null: false
      t.string :locale, null: false, default: "pt"

      t.timestamps
    end

    add_index :tags, [:name, :locale], unique: true
  end
end
