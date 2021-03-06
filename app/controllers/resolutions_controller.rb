class ResolutionsController < ApplicationController
  before_action :resolution, only: [:edit, :update]

  def index
    @resolutions = Resolution.order_by_name.paginate(page: params[:page])
  end

  def new
    @resolution = Resolution.new
  end

  def create
    @resolution = Resolution.new(resolution_params)

    if request.xhr?
      @resolution.save
    elsif @resolution.save
      redirect_back(fallback_location: root_path, flash: { success: t('create') })
    else
      render 'new'
    end
  end

  def update
    if request.xhr?
      @resolution.update(resolution_params)
    elsif @resolution.update(resolution_params)
      redirect_back(fallback_location: root_path, flash: { success: t('update') })
    else
      render 'edit'
    end
  end

  private

  def resolution
    @resolution ||= Resolution.find(params[:id])
  end

  def resolution_params
    params.require(:resolution).permit(:name)
  end
end
