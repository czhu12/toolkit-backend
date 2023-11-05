class CreateScripts < ActiveRecord::Migration[7.1]
  def change
    create_table :scripts do |t|
      t.text :code, default: ""
      t.string :description
      t.bigint :run_count, default: 0, null: false
      t.string :slug, null: false
      t.string :title, null: false
      t.integer :visibility, default: 0
      t.bigint :user_id

      t.timestamps
    end
    add_index :scripts, :slug, unique: true
  end
end
