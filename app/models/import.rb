class Import < ApplicationRecord
  include HasOneUniqueAttachedLogFile

  PENDING = 'pending'
  PARSING = 'parsing'
  PARSED = 'parsed'
  ERROR = 'error'

  has_many :matches, dependent: :destroy

  validates :status, presence: true, inclusion: {
    in: [PENDING, PARSING, PARSED, ERROR],
    message: "%{value} is not a valid status"
  }
end
