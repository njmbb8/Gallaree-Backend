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
        if @order_item
            if @order_item.order_id == cookies[:order_id]
                @order_item.destroy
                render json: Order.find(cookies[:order_id]), status: :ok
            else
                render json: { error: "item not in order" }, status: :unauthorized
            end
        else
            render json: { error: "order item not found" }, status: :not_found
        end
    end

    private

    def order_item_params
        params.permit(:arts_id)
    end
end
