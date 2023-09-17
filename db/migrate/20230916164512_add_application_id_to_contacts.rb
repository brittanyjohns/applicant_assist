class AddApplicationIdToContacts < ActiveRecord::Migration[7.1]
  def change
    add_column :contacts, :application_id, :integer
  end
end
