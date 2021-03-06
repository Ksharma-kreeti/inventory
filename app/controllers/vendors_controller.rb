class VendorsController < ApplicationController
  before_action :vendor, only: [:edit, :update, :show]

  def new
    @vendor = Vendor.new
  end

  def create
    @vendor = Vendor.new(vendor_params)

    if request.xhr?
      @vendor.save
    elsif @vendor.save
      redirect_back(fallback_location: root_path, flash: { success: t('create') })
    else
      render 'new'
    end
  end

  def update
    if request.xhr?
      @vendor.update(vendor_params)
    elsif @vendor.update(vendor_params)
      redirect_back(fallback_location: root_path, flash: { success: t('update') })
    else
      render 'edit'
    end
  end

  def index
    @vendors = Vendor.order_by_name.paginate(page: params[:page])
  end

  def show
    @items = @vendor.items.includes(:brand, :category).order_descending.paginate(page: params[:items_page])
  end

  private

  def vendor
    @vendor ||= Vendor.find(params[:id])
  end

  def vendor_params
    params.require(:vendor).permit(:name, :email, :mobile, :address, :city, :state)
  end
end
