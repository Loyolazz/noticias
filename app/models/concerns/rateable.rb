module Rateable
  extend ActiveSupport::Concern

  included do
    has_many :ratings, as: :rateable, dependent: :destroy
  end

  def average_rating
    ratings.average(:value)&.to_f || 0.0
  end
end
