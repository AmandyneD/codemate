class TechnologiesController < ApplicationController
  def index
    @technologies = Technology.approved.ordered
  end

  def show
    @technology = Technology.find(params[:id])
  end

  def search
    technologies = Technology.approved
    technologies = technologies.by_category(params[:category]) if params[:category].present?

    if params[:q].present?
      q = params[:q].strip.downcase

      technologies = technologies
        .where("name ILIKE ?", "%#{q}%")
        .order(
          Arel.sql(
            ActiveRecord::Base.send(
              :sanitize_sql_array,
              [
                "CASE
                  WHEN LOWER(name) = ? THEN 0
                  WHEN LOWER(name) LIKE ? THEN 1
                  WHEN LOWER(name) LIKE ? THEN 2
                  ELSE 3
                END, name ASC",
                q,
                "#{q}%",
                "%#{q}%"
              ]
            )
          )
        )
    else
      technologies = technologies.ordered
    end

    technologies = technologies.limit(20)

    render json: technologies.map { |technology|
      {
        id: technology.id,
        name: technology.name,
        category: technology.category
      }
    }
  end
end
