class CreateDocs < ActiveRecord::Migration[7.1]
  def change
    create_table :docs do |t|
      t.string :name
      t.string :doc_type
      t.text :body
      t.text :raw_body
      t.belongs_to :documentable, polymorphic: true, null: false
      t.boolean :current

      t.timestamps
    end
  end
end
