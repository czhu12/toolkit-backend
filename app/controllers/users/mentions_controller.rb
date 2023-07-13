class Users::MentionsController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = search_users(params[:query])

    respond_to do |format|
      format.json
    end
  end

  private

  # Replace with a search engine like Meilisearch, ElasticSearch, or pg_search to provide better results
  def search_users(query)
    # Split the query "bob builder" into first and last like name_of_person does
    first_name, last_name = query.split(/\s/, 2)

    # If no last name was provided, reuse the first_name on the last name for better matches
    last_name ||= first_name

    # Database agnostic query uses ILIKE for PostgreSQL and LIKE for others
    User.where(
      User.arel_table[:first_name].matches("%#{first_name}%")
      .or(User.arel_table[:last_name].matches("%#{last_name}%"))
    ).with_attached_avatar.limit(10)
  end

  # By default, we'll only show the users in the current account.
  # You may want to use User.all instead to allow mentioning all users.
  def searchable_users
    current_account.users
  end
end
