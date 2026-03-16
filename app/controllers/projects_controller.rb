class ProjectsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_project, only: %i[show edit update destroy]
  before_action :authorize_owner!, only: %i[edit update destroy]

  def index
    Rails.logger.info("PROJECT FILTER PARAMS => #{params.to_unsafe_h}")

    @selected_category = params[:category].presence
    @selected_duration = params[:estimated_duration].presence
    @selected_technology_ids = Array(params[:technology_ids]).reject(&:blank?).map(&:to_i)

    @selected_technologies =
      if @selected_technology_ids.any?
        Technology.where(id: @selected_technology_ids).select(:id, :name, :category)
      else
        []
      end

    @projects = Project.where(status: "open")

    if params[:q].present?
      query = "%#{params[:q].strip}%"

      @projects = @projects
        .left_joins(:technologies)
        .where(
          "projects.title ILIKE :query
           OR projects.short_description ILIKE :query
           OR projects.description ILIKE :query
           OR technologies.name ILIKE :query
           OR technologies.category ILIKE :query",
          query: query
        )
    end

    if @selected_technology_ids.any?
      @projects = @projects
        .left_joins(:technologies)
        .where(technologies: { id: @selected_technology_ids })
    end

    if @selected_category.present?
      @projects = @projects
        .left_joins(:technologies)
        .where(technologies: { category: @selected_category })
    end

    if @selected_duration.present?
      @projects = @projects.where(estimated_duration: @selected_duration)
    end

    @projects = @projects
      .distinct
      .includes(:technologies)
      .order(created_at: :desc)
  end

  def show
    @project_owner = @project.owner
    @is_owner = user_signed_in? && (@project_owner == current_user)

    @accepted_collaborations = @project.collaborations
                                       .where(status: "accepted")
                                       .includes(:user)

    @pending_collaborations =
      if @is_owner
        @project.collaborations
                .where(status: "pending")
                .includes(:user)
      else
        Collaboration.none
      end

    @existing_collaboration =
      if user_signed_in?
        @project.collaborations.find_by(user: current_user)
      end

    @existing_bookmark =
      if user_signed_in?
        current_user.bookmarks.find_by(project: @project)
      end
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)

    @project.status =
      if params[:project_action] == "publish"
        "open"
      else
        "draft"
      end

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
    permitted = params.require(:project).permit(
      :title,
      :short_description,
      :description,
      :category,
      :estimated_duration,
      :max_collaborators,
      technology_ids: []
    )

    permitted[:technology_ids] = Array(permitted[:technology_ids]).reject(&:blank?).uniq

    permitted
  end
end
