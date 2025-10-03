class News < ApplicationRecord
  extend FriendlyId
  include PgSearch::Model
  include Plugins::LocalizedContent
  include Taggable
  include Rateable

  friendly_id :title_pt, use: :slugged
  localizes :title, :body

  belongs_to :author, class_name: "User", optional: true
  has_many :comments, as: :commentable, dependent: :destroy

  validates :title_pt, :title_es, :body_pt, :body_es, presence: true

  pg_search_scope :search_query,
                  against: { title_pt: 'A', title_es: 'B', body_pt: 'C', body_es: 'D' },
                  using: { tsearch: { prefix: true } }

  scope :ordered, -> { order(created_at: :desc) }

  def self.search_by_term(term)
    scope = term.present? ? search_query(term) : all
    scope.ordered
  end

  def should_generate_new_friendly_id?
    slug.blank? || will_save_change_to_title_pt?
  end
end
