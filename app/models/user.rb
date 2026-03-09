class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :user_technologies, dependent: :destroy
  has_many :technologies, through: :user_technologies

  has_many :collaborations, dependent: :destroy
  has_many :projects, through: :collaborations

  has_many :owned_collaborations, -> { where(owner: true) },
           class_name: "Collaboration",
           dependent: :destroy
  has_many :owned_projects, through: :owned_collaborations, source: :project

  has_many :bookmarks, dependent: :destroy
  has_many :bookmarked_projects, through: :bookmarks, source: :project

  has_many :started_conversations,
           class_name: "Conversation",
           foreign_key: :sender_id,
           dependent: :destroy,
           inverse_of: :sender

  has_many :received_conversations,
           class_name: "Conversation",
           foreign_key: :recipient_id,
           dependent: :destroy,
           inverse_of: :recipient

  has_many :messages, dependent: :destroy

  validates :display_name, presence: true
end
