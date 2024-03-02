class Cache::Report < ApplicationRecord
  belongs_to :match

  validates :stats, presence: true
end
