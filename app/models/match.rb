class Match < ApplicationRecord
  belongs_to :import

  has_many :kills, dependent: :destroy
end
