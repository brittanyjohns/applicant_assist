# == Schema Information
#
# Table name: companies
#
#  id         :bigint           not null, primary key
#  industry   :string
#  name       :string
#  website    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Company < ApplicationRecord
end