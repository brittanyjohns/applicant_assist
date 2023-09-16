# == Schema Information
#
# Table name: contacts
#
#  id           :bigint           not null, primary key
#  company_name :string
#  email        :string
#  job_title    :string
#  name         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Contact < ApplicationRecord
  has_many :conversations
  has_many :posts, as: :author
  after_create_commit { broadcast_append_to("contacts") }
end
