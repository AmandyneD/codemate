class Project < ApplicationRecord
  has_many :project_technologies, dependent: :destroy
  has_many :technologies, through: :project_technologies

  has_many :collaborations, dependent: :destroy
  has_many :users, through: :collaborations

  has_many :bookmarks, dependent: :destroy
  has_many :conversations, dependent: :destroy

  validates :title, presence: true
  validates :short_description, presence: true
  validates :description, presence: true
  validates :category, presence: true
  validates :estimated_duration, presence: true
  validates :status, presence: true
  validates :max_collaborators,
            presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 1 }

  scope :published, -> { where.not(status: "draft") }

  after_initialize :set_defaults, if: :new_record?

  def owner_collaboration
    collaborations.find_by(owner: true)
  end

  def owner
    owner_collaboration&.user
  end

  def accepted_collaborations
    collaborations.where(status: "accepted")
  end

  def accepted_members_count
    accepted_collaborations.count
  end

  def recruiting?
    status == "open" && accepted_members_count < max_collaborators
  end

  private

  def set_defaults
    self.status ||= "draft"
  end
end
