class ProjectsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_project, only: %i[show edit update destroy]
  before_action :authorize_owner!, only: %i[edit update destroy]

  def index
    @projects = Project.includes(:technologies)
                      .where.not(status: "draft")
                      .order(created_at: :desc)

    if params[:q].present?
      query = "%#{params[:q].strip}%"
      @projects = @projects.where(
        "title ILIKE :q OR short_description ILIKE :q OR description ILIKE :q",
        q: query
      )
    end

    if params[:stack].present?
      @projects = @projects.joins(:technologies)
                          .where(technologies: { category: params[:stack] })
    end

    if params[:estimated_duration].present?
      @projects = @projects.where(estimated_duration: params[:estimated_duration])
    end

    @projects = @projects.distinct
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

  def destroy
    @project.destroy
    redirect_to my_projects_path, notice: "Projet supprimé avec succès."
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
