class OrderController < ApplicationController
    def show
        @order = Order.find(params[:id])
        if @order
            render json: @order, status: :ok
        else
            render json: { error: "order not found" }, status: :not_found
        end
    end

    def index
        render json: Order.all, status: :ok
    end

    def update
        order = Order.find(cookies[:order_id])
        if order
            if order.update(order_params)
                render json: order, status: :ok
            else
                render json: {error: "could not update order"}, status: :unprocessable_entity
            end
        else
            render json: {error: "could not find order"}, status: :not_found
        end
    end

    private

    def order_params
        params.permit(:user_id, :order_status_id, :tracking, :shipping, :billing)
    end
end
