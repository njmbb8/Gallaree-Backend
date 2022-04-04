class OrderController < ApplicationController
    before_action :check_auth, only: [:show, :update]
    def show
        render json: @order, status: :ok
    end

    def index
        user = User.find(cookies[:user_id])
        if user
            if user.admin
                render json: Order.all, status: :ok
            else
                render json: {error: "You do not have access to other user's orders"}, status: :unauthorized
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

    def check_auth
        user = User.find(cookies[:user_id])
        @order = Order.find(params[:id])
        render json: {error: "you are not logged in"}, status: :unauthorized unless user
        render json: {error: "could not find order"}, status: :not_found unless @order
        render json: {error: "you do not have permission for this order"}, status: unauthorized unless user.admin || user.orders.last.id == @order.id
    end

    def order_params
        params.permit(:user_id, :order_status_id, :tracking, :shipping_id, :payment_intent)
    end
end
