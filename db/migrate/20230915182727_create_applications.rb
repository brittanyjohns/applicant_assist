class CreateApplications < ActiveRecord::Migration[7.1]
  def change
    create_table :applications do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :job, null: false, foreign_key: true
      t.integer :status
      t.integer :stage
      t.datetime :applied_at
      t.datetime :archived_at
      t.string :job_source
      t.string :job_link
      t.string :company_link
      t.boolean :favorite
      t.integer :rating
      t.text :details
      t.text :notes

      t.timestamps
    end
  end
end
