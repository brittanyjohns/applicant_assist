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

  def self.prompt_subject_list
    self.active.pluck(:subject).uniq.sort
  end

  def self.prompt_body(subject)
    self.active.where(subject: subject).first&.body || "No prompt body found for #{subject}"
  end
end
