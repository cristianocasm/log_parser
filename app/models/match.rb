class Match < ApplicationRecord
  belongs_to :import

  has_one :cache_report, dependent: :destroy
  has_many :kills, dependent: :destroy
end
