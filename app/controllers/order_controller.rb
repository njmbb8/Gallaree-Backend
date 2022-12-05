class OrderController < ApplicationController
    def show
        user = User.find(cookies.signed[:user_id])

        if user.admin
            order = Order.find(params[:id])
        else
            order = user.orders.find(params[:id])
        end

        render json: order, serializer: OrderSerializer, status: :ok
    end

    def index
        user = User.find(cookies.signed[:user_id])
        if user
            if user.admin
                render json: Order.where.not(status: 'New'), each_serializer: OrderListSerializer, status: :ok
            else
                render json: user.orders.where.not(status: 'New'), each_serializer: OrderListSerializer, status: :ok
            end
        else
            render json: {error: "you are not logged in"}, status: :unauthorized
        end
    end

    def update
        user = User.find(cookies.signed[:user_id])
        order = Order.find(params[:id])
        if user.admin
            if order.status != 'Shipped'
                if order.update(tracking: params.permit[:tracking], ship_time: Time.now, status: 'Shipped')
                    render json: order, status: :ok
                else
                    render json: { error: 'could not update order'}, status: :unprocessable_entity
                end
            else
                render json: { error: 'order already shipped'}, status: :not_modified
            end
        else
            render json: {error: "only admins can ship orders"}, status: :forbidden
        end
    end

    def destroy
        user = User.find(cookies.signed[:user_id])
        order = Order.find(params[:id])
        if user.admin || order.user.id == user.id
            if order.status == 'requires_payment_method' || order.status == 'requires_capture' || order.status == 'requires_confirmation' || order.status == 'requires_action' || order.status == 'processing'
                Stripe::PaymentIntent.cancel(order[:payment_intent])
            elsif user.admin
                Stripe::Refund.create({payment_intent: order[:payment_intent]})
                order.update(cancel_time: Time.now, status: 'Refunded')
            else
                render json: {error: 'order is not in a state to be canceled'}
            end
        else
            render json: {error: 'you do not have permission to edit this order'}
        end
    end

    private

    def order_params
        params.permit(:user_id, :order_status_id, :tracking, :shipping_id, :payment_intent, :tracking)
    end
end
