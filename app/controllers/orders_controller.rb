class OrdersController < ApplicationController
  before_action :authenticate_user!

  # GET /orders - list user's orders
  def index
    @orders = current_user.orders.order(created_at: :desc)
    render json: @orders, include: { order_descriptions: { include: :item } }
  end

  # GET /orders/:id - show specific order
  def show
    @order = current_user.orders.find(params[:id])
    render json: @order, include: { order_descriptions: { include: :item } }
  end

  # POST /orders - create new order (checkout)
  def create
    order_items = params[:order_items] # Array of { item_id, quantity }

    if order_items.blank? || order_items.empty?
      return render json: { error: 'Cart is empty' }, status: :unprocessable_entity
    end

    # Calculate total amount
    total_amount = 0
    order_descriptions_attributes = []

    order_items.each do |item_data|
      item = Item.find_by(id: item_data[:item_id])
      if item.nil?
        return render json: { error: "Item with id #{item_data[:item_id]} not found" }, status: :not_found
      end

      quantity = item_data[:quantity].to_i
      if quantity <= 0
        return render json: { error: 'Quantity must be greater than 0' }, status: :unprocessable_entity
      end

      total_amount += item.price * quantity
      order_descriptions_attributes << {
        item_id: item.id,
        quantity: quantity
      }
    end

    @order = Order.new(
      user_id: current_user.id,
      amount: total_amount,
      order_descriptions_attributes: order_descriptions_attributes
    )

    if @order.save
      render json: @order, include: { order_descriptions: { include: :item } }, status: :created
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end
end
