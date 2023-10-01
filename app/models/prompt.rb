# == Schema Information
#
# Table name: prompts
#
#  id         :bigint           not null, primary key
#  active     :boolean
#  body       :text
#  subject    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Prompt < ApplicationRecord
  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
end
