class ItemsController < ApplicationController
  before_action :authenticate_user!          # все должны быть залогинены
  before_action :authenticate_admin!, only: [:create, :update, :destroy]
  before_action :set_item, only: [:show, :update, :destroy]

  # GET /items
  def index
    if params[:q].present?
      @items = Item.where("name ILIKE ? OR description ILIKE ?", "%#{params[:q]}%", "%#{params[:q]}%")
    else
      @items = Item.all
    end
    render json: @items
  end

  # GET /items/:id
  def show
    render json: @item
  end

  # POST /items
  def create
    @item = Item.new(item_params)
    if @item.save
      render json: @item, status: :created
    else
      render json: @item.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /items/:id
  def update
    if @item.update(item_params)
      render json: @item
    else
      render json: @item.errors, status: :unprocessable_entity
    end
  end

  # DELETE /items/:id
  def destroy
    @item.destroy
    head :no_content
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:name, :description, :price).tap do |whitelisted|
      # Validate price is a positive number
      if whitelisted[:price].present?
        price = whitelisted[:price].to_f
        if price <= 0
          raise ActionController::ParameterMissing, :price
        end
      end
    end
  end
end