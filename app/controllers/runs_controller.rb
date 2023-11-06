class RunsController < ApplicationController
  before_action :set_script

  # Uncomment to enforce Pundit authorization
  # after_action :verify_authorized
  # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # Show the source of the script
  def serve

  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_script
    @script = Script.public_visibility.friendly.find(params[:id])
    # Uncomment to authorize with Pundit
    # authorize @script
  rescue ActiveRecord::RecordNotFound
    redirect_to scripts_path
  end
end
