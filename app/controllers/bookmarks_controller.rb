class BookmarksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: [ :create, :destroy ]

  def index
    @favorite_projects = current_user.bookmarked_projects
                                     .includes(:technologies)
                                     .order(created_at: :desc)
  end

  def create
    current_user.bookmarks.find_or_create_by!(project: @project)
    redirect_to @project, notice: "Project added to favorites."
  end

  def destroy
    bookmark = current_user.bookmarks.find_by!(project: @project)
    bookmark.destroy
    redirect_to @project, notice: "Project removed from favorites."
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end
end
