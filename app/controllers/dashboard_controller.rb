class DashboardController < ApplicationController
  before_action :authenticate_user!

  def projects
    @owned_projects = current_user.owned_projects
                                  .includes(:technologies, collaborations: :user)
                                  .distinct
                                  .order(created_at: :desc)

    @joined_projects = current_user.projects
                                   .joins(:collaborations)
                                   .where(collaborations: { user_id: current_user.id, owner: false, status: "accepted" })
                                   .includes(:technologies, collaborations: :user)
                                   .distinct
                                   .order(created_at: :desc)
  end
end
