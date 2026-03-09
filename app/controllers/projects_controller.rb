class ProjectsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_project, only: %i[show edit update]
  before_action :authorize_owner!, only: %i[edit update]

  def index
    @projects = Project.published.includes(:technologies, collaborations: :user)

    @projects = @projects.where(category: params[:category]) if params[:category].present?
    @projects = @projects.where(estimated_duration: params[:estimated_duration]) if params[:estimated_duration].present?

    if params[:technology_id].present?
      @projects = @projects.joins(:project_technologies)
                           .where(project_technologies: { technology_id: params[:technology_id] })
    end

    @projects = @projects.distinct.order(created_at: :desc)
  end

  def show
    @accepted_collaborations = @project.collaborations
                                      .where(status: "accepted")
                                      .includes(:user)

    @pending_collaborations = @project.collaborations
                                      .where(status: "pending")
                                      .includes(:user)

    @project_owner = @project.owner
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)

    if @project.save
      @project.collaborations.create!(
        user: current_user,
        owner: true,
        status: "accepted"
      )

      redirect_to @project, notice: "Projet créé avec succès."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @project.update(project_params)
      redirect_to @project, notice: "Projet mis à jour avec succès."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def authorize_owner!
    return if @project.owner == current_user

    redirect_to @project, alert: "Vous n’êtes pas autorisée à modifier ce projet."
  end

  def project_params
    params.require(:project).permit(
      :title,
      :short_description,
      :description,
      :category,
      :estimated_duration,
      :max_collaborators,
      :status,
      technology_ids: []
    )
  end
end
