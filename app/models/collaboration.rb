class Collaboration < ApplicationRecord
  belongs_to :user
  belongs_to :project

  validates :status, presence: true
  validates :user_id, uniqueness: { scope: :project_id }
  validates :owner, inclusion: { in: [ true, false ] }
  validates :role, length: { maximum: 100 }, allow_blank: true

  scope :accepted, -> { where(status: "accepted") }
  scope :pending, -> { where(status: "pending") }
end
