class Match < ApplicationRecord
  belongs_to :import

  has_one :cache_report, class_name: 'Cache::Report', dependent: :destroy
  has_many :kills, dependent: :destroy
end
