class CreatePrompts < ActiveRecord::Migration[7.1]
  def change
    create_table :prompts do |t|
      t.string :subject
      t.text :body
      t.boolean :active

      t.timestamps
    end
  end
end
