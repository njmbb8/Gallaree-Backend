class OrderItemsController < ApplicationController
    before_action :check_ownership, only: [:update, :destroy]
    
    def create
        @order = Order.find(cookies[:order_id])
        if @order
            @order_item = @order.order_items.new(arts_id: params[:arts_id])
            if @order_item.save
                render json: @order, status: :created
            else
                render json: { error: 'Unable to add item to order' }, status: :unprocessable_entity
            end
        else
            render json: {error: "Order does not exist"}, status: :not_found
        end
    end

    def update
        @order_item.quantity = params[:quantity]
        render json: Order.find(cookies[:order_id]), status: :ok
    end

    def destroy
        @order_item.destroy
        render json: Order.find(cookies[:order_id]), status: :ok
    end

    private

    def check_ownership
        @order_item = OrderItem.find(params[:id])
        if @order_item
            render json: { error: "item not in order" }, status: :unauthorized unless @order_item.order_id == cookies[:order_id].to_i
        else
            render json: { error: "order item not found" }, status: :not_found
        end
    end

    def order_item_params
        params.permit(:arts_id)
    end
end
