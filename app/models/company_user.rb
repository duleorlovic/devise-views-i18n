class CompanyUser < ApplicationRecord
  belongs_to :company
  belongs_to :user
  enum position: %i[admin active invited].each_with_object({}) { |k, o| o[k] = k.to_s }
end
