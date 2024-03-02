class Import < ApplicationRecord
  include HasOneUniqueAttachedLogFile

  has_many :matches, dependent: :destroy

  validates :status, presence: true, inclusion: {
    in: %w(pending parsing parsed error),
    message: "%{value} is not a valid status"
  }
end
