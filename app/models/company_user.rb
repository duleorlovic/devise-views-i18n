class CompanyUser < ApplicationRecord
  FIELDS = %i[position].freeze
  belongs_to :company
  belongs_to :user
  accepts_nested_attributes_for :user
end
