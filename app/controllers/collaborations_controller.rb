class CollaborationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: [ :create, :index ]
  before_action :set_collaboration, only: [ :update ]

  def create
    if @project.owner == current_user
      redirect_to @project, alert: "You cannot join your own project."
      return
    end

    if @project.status == "closed" || @project.status == "completed" || @project.status == "full"
      redirect_to @project, alert: "This project is not accepting new members."
      return
    end

    existing_collaboration = @project.collaborations.find_by(user: current_user)

    if existing_collaboration.present?
      redirect_to @project, alert: "You have already interacted with this project."
      return
    end

    @project.collaborations.create!(
      user: current_user,
      status: "pending",
      owner: false
    )

    redirect_to @project, notice: "Your request has been sent."
  end

  def index
    authorize_owner!

    @pending_collaborations = @project.collaborations.pending.includes(:user)
    @accepted_collaborations = @project.collaborations.accepted.includes(:user)
  end

  def update
    @project = @collaboration.project
    authorize_owner_for(@project)

    case params[:status]
    when "accepted"
      if @project.accepted_members_count >= @project.max_collaborators
        redirect_to project_collaborations_path(@project), alert: "This project is already full."
        return
      end

      @collaboration.update!(status: "accepted")

      if @project.accepted_members_count >= @project.max_collaborators
        @project.update!(status: "full")
      end

      redirect_to project_collaborations_path(@project), notice: "Collaboration accepted."
    when "rejected"
      @collaboration.update!(status: "rejected")
      redirect_to project_collaborations_path(@project), notice: "Collaboration rejected."
    when "left"
      if @collaboration.owner
        redirect_to project_path(@project), alert: "The owner cannot leave the project."
        return
      end

      @collaboration.update!(status: "left")

      if @project.status == "full" && @project.accepted_members_count < @project.max_collaborators
        @project.update!(status: "open")
      end

      redirect_to my_projects_path, notice: "You left the project."
    else
      redirect_to project_path(@project), alert: "Invalid action."
    end
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_collaboration
    @collaboration = Collaboration.find(params[:id])
  end

  def authorize_owner!
    return if @project.owner == current_user

    redirect_to @project, alert: "You are not allowed to manage this project."
  end

  def authorize_owner_for(project)
    return if project.owner == current_user

    redirect_to project, alert: "You are not allowed to manage this project."
  end
end
