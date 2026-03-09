class Technology < ApplicationRecord
  has_many :user_technologies, dependent: :destroy
  has_many :users, through: :user_technologies

  has_many :project_technologies, dependent: :destroy
  has_many :projects, through: :project_technologies

  validates :name, presence: true, uniqueness: true
end
