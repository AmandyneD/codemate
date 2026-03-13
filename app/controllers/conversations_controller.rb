class ConversationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: [ :create ]
  before_action :set_conversation, only: [ :show ]
  before_action :authorize_conversation_access!, only: [ :show ]

  def index
    @conversations =
      Conversation
        .where("sender_id = :user_id OR recipient_id = :user_id", user_id: current_user.id)
        .includes(:project, :sender, :recipient, messages: :user)
        .order(updated_at: :desc)
  end

  def show
    @project = @conversation.project
    @messages = @conversation.messages.includes(:user).order(:created_at)
    @other_user = @conversation.other_user(current_user)
    @message = Message.new
  end

  def create
    target_user = User.find(params[:recipient_id])

    if target_user == current_user
      redirect_to project_path(@project), alert: "You cannot start a conversation with yourself."
      return
    end

    unless authorized_to_message?(target_user)
      redirect_to project_path(@project), alert: "You are not allowed to message this user for this project."
      return
    end

    @conversation =
      Conversation.find_by(
        project: @project,
        sender: current_user,
        recipient: target_user
      ) ||
      Conversation.find_by(
        project: @project,
        sender: target_user,
        recipient: current_user
      )

    unless @conversation
      @conversation = Conversation.create!(
        project: @project,
        sender: current_user,
        recipient: target_user
      )
    end

    redirect_to conversation_path(@conversation)
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_conversation
    @conversation = Conversation.find(params[:id])
  end

  def authorize_conversation_access!
    return if @conversation.includes_user?(current_user)

    redirect_to projects_path, alert: "You are not allowed to access this conversation."
  end

  def authorized_to_message?(target_user)
    owner = @project.owner
    return false unless owner

    target_collaboration = @project.collaborations.find_by(user: target_user)

    # Owner can message accepted or pending collaborators
    if current_user == owner
      return target_collaboration.present? && target_collaboration.status.in?(%w[pending accepted])
    end

    # Any logged-in user can message the owner
    return true if target_user == owner

    # Members cannot message each other
    false
  end
end
