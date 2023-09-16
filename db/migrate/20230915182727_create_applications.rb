class CreateApplications < ActiveRecord::Migration[7.1]
  def change
    create_table :applications do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :job, null: false, foreign_key: true
      t.integer :status, default: 0
      t.integer :stage, default: 0
      t.datetime :applied_at
      t.datetime :archived_at
      t.string :job_source
      t.string :job_link
      t.string :company_link
      t.boolean :favorite, default: false
      t.integer :rating, default: 0
      t.text :details
      t.text :notes

      t.timestamps
    end
  end
end
