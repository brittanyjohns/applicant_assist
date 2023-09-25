# == Schema Information
#
# Table name: docs
#
#  id                :bigint           not null, primary key
#  body              :text
#  current           :boolean
#  doc_type          :string
#  documentable_type :string           not null
#  name              :string
#  raw_body          :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  documentable_id   :bigint           not null
#
# Indexes
#
#  index_docs_on_documentable  (documentable_type,documentable_id)
#
class Doc < ApplicationRecord
  belongs_to :documentable, polymorphic: true
  has_rich_text :displayed_content

  def self.doc_types
    ["resume"]
  end
end
