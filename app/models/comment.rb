class Comment < ApplicationRecord
  STATUSES = %w[pending approved rejected].freeze

  belongs_to :user
  belongs_to :commentable, polymorphic: true

  validates :body, presence: true
  validates :locale, inclusion: { in: I18n.available_locales.map(&:to_s) }
  validates :status, inclusion: { in: STATUSES }

  scope :pending, -> { where(status: "pending") }
  scope :approved, -> { where(status: "approved") }

  def approve!
    update!(status: "approved")
  end

  def reject!
    update!(status: "rejected")
  end
end
