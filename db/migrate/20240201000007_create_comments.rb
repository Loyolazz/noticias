class CreateComments < ActiveRecord::Migration[8.0]
  def change
    create_table :comments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :commentable, null: false, polymorphic: true
      t.text :body, null: false
      t.string :locale, null: false, default: "pt"
      t.string :status, null: false, default: "pending"

      t.timestamps
    end

    add_index :comments, :status
  end
end
