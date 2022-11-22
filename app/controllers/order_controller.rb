class OrderController < ApplicationController
    def show
        render json: @order, status: :ok
    end

    def index
        user = User.find(cookies.signed[:user_id])
        if user
            if user.admin
                render json: Order.all, each_serializer: OrderListSerializer, status: :ok
            else
                render json: user.orders, status: :ok
            end
        else
            render json: {error: "you are not logged in"}, status: :unauthorized
        end
    end

    def update
        if @order.update(order_params)
            render json: @order, status: :ok
        else
            render json: {error: "could not update order"}, status: :unprocessable_entity
        end
    end

    private

    def order_params
        params.permit(:user_id, :order_status_id, :tracking, :shipping_id, :payment_intent)
    end
end
