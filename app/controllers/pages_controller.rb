class PagesController < ApplicationController
  def home
    @featured_projects = Project
      .where.not(status: :draft)
      .includes(:technologies)
      .order(created_at: :desc)
      .limit(3)

    @users_count = User.count
    @projects_count = Project.where.not(status: :draft).count
    @contributors_count = Collaboration.where(status: :accepted).count
  end
end
