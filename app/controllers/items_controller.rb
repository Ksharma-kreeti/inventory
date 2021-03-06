class ItemsController < ApplicationController
  before_action :item, except: [:index, :new, :create, :add_parent, :item_render]
  before_action :find_item_by_id, only: [:change_parent, :item_render]

  def index
    @items = Item.includes(:brand, :category, :issues, :checkouts)
    @items = @items.not_erased.active if params[:status] != "Discarded"
    @items = @items.filter_by_category(params[:category]) if params[:category].present?
    @items = @items.filter_by_brand(params[:brand]) if params[:brand].present?
    @items = @items.filter_by_parent(params[:parent]) if params[:parent].present?
    @items = @items.filter_by_status(params[:status]) if params[:status].present?
    @items = @items.paginate(page: params[:page])
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)

    if request.xhr?
      @item.save
    elsif @item.save
      redirect_back(fallback_location: root_path, flash: { success: t('create') })
    else
      render 'new'
    end
  end

  def update
    if request.xhr?
      @item.update(item_params)
    elsif @item.update(item_params)
      redirect_back(fallback_location: root_path, flash: { success: t('update') })
    else
      render 'edit'
    end
  end

  def show
    @item_histories = @item.item_histories.order_descending.paginate(page: params[:item_histories_page])
    @checkouts      = @item.checkouts.order_descending.paginate(page: params[:checkouts_page])
    @issues         = @item.issues.order_descending.paginate(page: params[:issues_page])
  end

  def reallocate
    @item.reallocate(reallocate_employee_params["employee_id"])
    redirect_back(fallback_location: root_path, flash: { success: t('reallocate') })
  end

  def destroy
    @item.update(parent_id: nil, working: false, deleted_at: Time.zone.now, employee_id: nil)
    redirect_to items_path, flash: { success: t('destroy.success') }
  end

  def discard
    @item.update(parent_id: nil, working: false, discarded_at: Time.zone.now, employee_id: nil)
    redirect_to items_path, flash: { success: t('discard') }
  end

  def remove_item
    @item.update(parent_id: nil)
    redirect_to item_path
  end

  def update_parent
    parent = Item.find_by(id: item_params["parent_id"])

    if @item.change_parent(parent)
      redirect_to item_path
    else
      flash[:alert] = t('update_parent_fail')
      render :change_parent
    end
  end

  def add_child
    child = Item.find_by(id: item_params["parent_id"])

    if @item.add_child(child)
      redirect_to item_path
    else
      flash[:alert] = t('add_child_fail')
      render :add_item
    end
  end

  def approve
    @item.approve_item(current_user)
  end

  def reject
    @item.reject_item(current_user)
  end

  private

  def item
    @item ||= Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:model_number, :category_id, :brand_id, :serial_number, :purchase_on, :vendor_id, :working, :employee_id, :parent_id,
                                 :warranty_expires_on, :note, documents_attributes: [:title, :attachment])
  end

  def reallocate_employee_params
    params.require(:item).permit(:employee_id)
  end

  def find_item_by_id
    @item = Item.find_by(id: params[:id])
  end
end
