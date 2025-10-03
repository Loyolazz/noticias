module Taggable
  extend ActiveSupport::Concern

  included do
    has_many :taggings, as: :taggable, dependent: :destroy
    has_many :tags, through: :taggings

    accepts_nested_attributes_for :taggings, allow_destroy: true
  end

  def tag_names(locale = I18n.locale)
    tags.where(locale: locale).pluck(:name)
  end

  def tag_list(locale = I18n.locale)
    tag_names(locale).join(', ')
  end
end
