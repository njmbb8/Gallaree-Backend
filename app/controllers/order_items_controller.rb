class OrderItemsController < ApplicationController
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

    def destroy
        @order_item = OrderItem.find(params[:order_item_id])
        @order = Order.find(@order_item.order.id)
        if @order_item
            @order_item.destroy
            head :ok
        else
            render json: { error: "Could not remove item from cart" }, status: :unprocessable_entity
        end
    end

    private

    def order_item_params
        params.permit(:arts_id)
    end
end