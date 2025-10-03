class Tag < ApplicationRecord
  has_many :taggings, dependent: :destroy
  has_many :news, through: :taggings, source: :taggable, source_type: "News"
  has_many :videos, through: :taggings, source: :taggable, source_type: "Video"

  validates :name, presence: true
  validates :locale, inclusion: { in: I18n.available_locales.map(&:to_s) }
  validates :name, uniqueness: { scope: :locale }

  scope :for_locale, ->(locale) { where(locale: locale.to_s) }
end
