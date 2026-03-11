class UsersController < ApplicationController
  before_action :set_user, only: [ :show, :edit, :update ]
  before_action :authenticate_user!, only: [ :edit, :update ]
  before_action :authorize_user!, only: [ :edit, :update ]

  def index
    @users = User.includes(:technologies, avatar_attachment: :blob)

    if params[:q].present?
      query = "%#{params[:q].strip}%"
      @users = @users.where("display_name ILIKE ?", query)
    end

    if params[:stack].present?
      @users = @users
        .joins(:technologies)
        .where(technologies: { category: params[:stack] })
        .distinct
    end

    @users = @users.order(created_at: :desc)
  end

  def show
    @owned_projects = @user.collaborations
                           .where(owner: true, status: "accepted")
                           .includes(:project)
                           .map(&:project)

    @joined_projects = @user.collaborations
                            .where(owner: false, status: "accepted")
                            .includes(:project)
                            .map(&:project)

    @favorite_projects = @user.bookmarked_projects
                              .includes(:technologies)
                              .order(created_at: :desc)
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: "Profile updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def authorize_user!
    return if @user == current_user

    redirect_to user_path(@user), alert: "You are not allowed to edit this profile."
  end

  def user_params
    params.require(:user).permit(
      :display_name,
      :bio,
      :github_url,
      :avatar,
      technology_ids: []
    )
  end
end
