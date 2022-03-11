class OrderItemsController < ApplicationController
    def create
        @order_item = OrderItem.new(order_items_params)
        @order = Order.find(cookies[:order_id])
        @order_item.order_id = @order.id 
        if @order_item.save
            render json: @order, status: :created
        else
            render json: { error: "failed to add item to order" }, status: :unprocessable_entity
        end
    end

    private

    def order_items_params
        params.permit(:art_id)
    end
end
