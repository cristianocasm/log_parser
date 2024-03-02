class Kill < ApplicationRecord
  belongs_to :match

  validates :killer, presence: true
  validates :victim, presence: true
  validates :means, presence: true
end
