class ImportsController < ApplicationController
  around_action :skip_bullet,
    if: -> { params[:action] == 'show' && request.referrer == new_import_url }

  before_action :set_import, only: %i[ show destroy ]

  INCLUDES_PER_ACTION = {
    show: {matches: :cache_report}
  }.with_indifferent_access

  # GET /imports or /imports.json
  def index
    @imports = Import.includes(matches: :cache_report).all
  end

  # GET /imports/1 or /imports/1.json
  def show
  end

  # GET /imports/new
  def new
    @import = Import.new
  end

  # POST /imports or /imports.json
  def create
    @import = Import.new(import_params)

    respond_to do |format|
      if @import.save
        format.html { redirect_to import_url(@import), notice: "Import was successfully created." }
        format.json { render :show, status: :created, location: @import }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @import.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /imports/1 or /imports/1.json
  def destroy
    @import.destroy!

    respond_to do |format|
      format.html { redirect_to imports_url, notice: "Import was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_import
      @import = Import.includes(INCLUDES_PER_ACTION[params[:action]]).
        find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def import_params
      params.require(:import).permit(:log_file, :status)
    end
end
