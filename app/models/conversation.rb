class Conversation < ApplicationRecord
  belongs_to :project
  belongs_to :sender
  belongs_to :recipient
end
