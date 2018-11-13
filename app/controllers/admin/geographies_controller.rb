class Admin::GeographiesController < Admin::BaseController
  load_and_authorize_resource

  def index
  end

  def edit
  end

  def create
    if @geography.save
      redirect_to admin_geographies_path, notice: t("admin.geographies.create.notice")
    else
      render :new
    end
  end

  def update
    if @geography.update(geography_params)
      redirect_to admin_geographies_path, notice: t("admin.geographies.update.notice")
    else
      render :edit
    end
  end

  def destroy
    @geography.destroy!

    redirect_to admin_geographies_path, notice: t("admin.geographies.delete.notice")
  end

  private

    def geography_params
      params.require(:geography).permit(allowed_params)
    end

    def allowed_params
      [:name, :color, :geojson, heading_ids: []]
    end
end
