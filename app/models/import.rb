class Import < ApplicationRecord
  has_one_attached :log_file

  has_many :matches, dependent: :destroy

  validates :status, presence: true, inclusion: {
    in: %w(pending parsing parsed error),
    message: "%{value} is not a valid status"
  }
end
