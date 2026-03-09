class UserTechnology < ApplicationRecord
  belongs_to :user
  belongs_to :technology

  validates :user_id, uniqueness: { scope: :technology_id }
end
