class Conversation < ApplicationRecord
  belongs_to :project
  belongs_to :sender, class_name: "User", inverse_of: :started_conversations
  belongs_to :recipient, class_name: "User", inverse_of: :received_conversations

  has_many :messages, dependent: :destroy

  validates :sender_id, uniqueness: { scope: [ :recipient_id, :project_id ] }
  validate :different_participants

  def participants
    [ sender, recipient ]
  end

  private

  def different_participants
    return if sender_id != recipient_id

    errors.add(:recipient_id, "must be different from sender")
  end
end
