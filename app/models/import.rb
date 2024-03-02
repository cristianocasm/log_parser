class Import < ApplicationRecord
  has_one_attached :log_file

  has_many :matches, dependent: :destroy
end
