class ScriptsController < ApplicationController
  INITIAL_CODE = Rails.root.join("resources", "initial_script.js").read.strip
  before_action :authenticate_user!
  before_action :set_script, only: [:show, :edit, :update, :destroy]

  # Uncomment to enforce Pundit authorization
  # after_action :verify_authorized
  # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # GET /scripts
  def index
    @pagy, @scripts = pagy(current_user.scripts.sort_by_params(params[:sort], sort_direction))
  end

  # Show the source of the script
  def show

  end

  def source
  end

  # GET /scripts/1/edit
  def edit
  end

  def fork
    script = Script.public_visibility.friendly.find(params[:id])
    new_script = script.clone
    new_script.user = current_user
    new_script.save
  end

  # POST /scripts or /scripts.json
  def create
    script = current_user.scripts.create!(
      title: "Untitled",
      code: INITIAL_CODE,
    )
    redirect_to edit_script_url(script)
  end

  # PATCH/PUT /scripts/1 or /scripts/1.json
  def update
    respond_to do |format|
      if @script.update(script_params)
        format.html { redirect_to @script, notice: "Script was successfully updated." }
        format.json { render :show, status: :ok }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @script.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /scripts/1 or /scripts/1.json
  def destroy
    @script.destroy!
    respond_to do |format|
      format.html { redirect_to scripts_url, status: :see_other, notice: "Script <b>#{@script.title}</b> was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_script
    @script = current_user.scripts.friendly.find(params[:id])
    # Uncomment to authorize with Pundit
    # authorize @script
  rescue ActiveRecord::RecordNotFound
    redirect_to scripts_path
  end

  # Only allow a list of trusted parameters through.
  def script_params
    params.require(:script).permit(
      :code,
      :description,
      :run_count,
      :slug,
      :title,
      :visibility,
    )

    # Uncomment to use Pundit permitted attributes
    # params.require(:script).permit(policy(@script).permitted_attributes)
  end
end
