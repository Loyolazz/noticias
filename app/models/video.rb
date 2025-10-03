class Video < ApplicationRecord
  extend FriendlyId
  include Plugins::LocalizedContent
  include Taggable
  include Rateable

  friendly_id :title_pt, use: :slugged
  localizes :title, :description

  belongs_to :author, class_name: "User", optional: true
  has_many :comments, as: :commentable, dependent: :destroy

  validates :title_pt, :title_es, :description_pt, :description_es, :url, presence: true

  scope :ordered, -> { order(created_at: :desc) }

  def should_generate_new_friendly_id?
    slug.blank? || will_save_change_to_title_pt?
  end
end
