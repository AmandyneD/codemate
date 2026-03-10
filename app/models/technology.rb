class Technology < ApplicationRecord
  has_many :user_technologies, dependent: :destroy
  has_many :users, through: :user_technologies

  has_many :project_technologies, dependent: :destroy
  has_many :projects, through: :project_technologies

  CATEGORIES = %w[
    frontend
    backend
    fullstack
    mobile
    database
    devops
    cloud
    ai
    data
    crm
    design
    nocode
    testing
    analytics
    other
  ].freeze

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :slug, presence: true, uniqueness: { case_sensitive: false }
  validates :category, presence: true, inclusion: { in: CATEGORIES }

  before_validation :normalize_fields

  scope :approved, -> { where(approved: true) }
  scope :ordered, -> { order(:name) }
  scope :by_category, ->(category) { category.present? ? where(category: category) : all }

  private

  def normalize_fields
    self.name = name.to_s.strip
    self.slug = slug.present? ? slug.to_s.parameterize : name.to_s.parameterize
    self.category = category.to_s.strip.downcase
  end
end
