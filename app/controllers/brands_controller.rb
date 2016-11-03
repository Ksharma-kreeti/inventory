class BrandsController < ApplicationController
  before_action :get_brand, only: [:edit, :update, :show, :destroy]

  def index
    @brands = Brand.paginate(page: params[:page], per_page: 3)
  end

  def new
    @brand = Brand.new
  end

  def create
    @brand = Brand.new(brand_params)

    if @brand.save
      flash[:success] = "Brand was created successfully"
      redirect_to brands_path
    else
      render 'new'
    end
  end

  def update
    if @brand.update(brand_params)
      flash[:success] = "Brand name was successfully updated"
      redirect_to brands_path
    else
      render 'edit'
    end
  end

  def show
    @brand_items = @brand.items.paginate(page: params[:page], per_page: 5)
  end

  def destroy
    flash[:danger] = "#{@brand.name} and their articles have been removed."
    @brand.destroy
    redirect_to brands_path
  end

  private

  def get_brand
    @brand = Brand.find(params[:id])
  end

  def brand_params
    params.require(:brand).permit(:name)
  end
end
