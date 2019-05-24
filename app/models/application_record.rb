class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  # t('successfully') instead I18n.t('successfully')
  include AbstractController::Translation
end
