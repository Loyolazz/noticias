class User < ApplicationRecord
  has_secure_password

  has_many :authored_news, class_name: "News", foreign_key: :author_id, dependent: :nullify
  has_many :authored_videos, class_name: "Video", foreign_key: :author_id, dependent: :nullify

  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships

  has_many :inverse_friendships, class_name: "Friendship", foreign_key: :friend_id, dependent: :destroy
  has_many :inverse_friends, through: :inverse_friendships, source: :user

  has_many :comments, dependent: :destroy
  has_many :ratings, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :locale, inclusion: { in: I18n.available_locales.map(&:to_s) }

  scope :administrators, -> { where(admin: true) }

  def all_friends
    (friends + inverse_friends).uniq
  end

  def banned?
    banned
  end
end
