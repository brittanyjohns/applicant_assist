class CreateJobs < ActiveRecord::Migration[7.1]
  def change
    create_table :jobs do |t|
      t.belongs_to :company, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.string :location
      t.string :salary
      t.string :job_type
      t.text :experience
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
