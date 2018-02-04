class Micropost < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  # descending oreder of data retrieving from the database
  default_scope -> { order(created_at: :desc) }
end
