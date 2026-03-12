class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_conversation
  before_action :authorize_conversation_access!

  def create
    @message = @conversation.messages.build(message_params)
    @message.user = current_user

    if @message.save
      redirect_to conversation_path(@conversation), notice: "Message sent."
    else
      @project = @conversation.project
      @messages = @conversation.messages.includes(:user).order(:created_at)
      @other_user = @conversation.other_user(current_user)
      render "conversations/show", status: :unprocessable_entity
    end
  end

  private

  def set_conversation
    @conversation = Conversation.find(params[:conversation_id])
  end

  def authorize_conversation_access!
    return if @conversation.includes_user?(current_user)

    redirect_to projects_path, alert: "You are not allowed to access this conversation."
  end

  def message_params
    params.require(:message).permit(:content)
  end
end
