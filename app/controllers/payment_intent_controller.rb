class PaymentIntentController < ApplicationController
    def create
        @payment_intent = Stripe::PaymentIntent.create(
            amount: User.find(cookies[:user_id]).orders.last.order_items.sum { |item| item.art.price * item.quantity },
            currency: 'usd',
            automatic_payment_methods: {
                enabled: true
            }
        )
        render json: { clientSecret: @payment_intent['client_secret'], payment_intent: @payment_intent[:id]}, status: :ok
    end

    def update
        order = Order.find(params[:id])
        if order
            if order.user_id == cookies[:user_id]
                Stripe::PaymentIntent.update(order.payment_intent, {
                    amount: order.order_items.sum {|item| item.art.price * item.quantity}
                })
                render json: order, status: :ok
            else
                render json: {error: "this order does not belong to you"}, status: :unauthorized
            end
        else
            render json: {error: "order not found"}, status: :not_found
        end

    end

    private
    def mark_as_pending
        order = Order.find_by(payment_intent: params[:data][:object][:payment_intent])
        if order
            order.order_status_id = 2
            order.order_items.each do |item|
                art = Art.find(item.art_id)
                art.quantity = art.quantity - item.quantity
                art.save
            end
            order.save
            user = order.user
            new_order = user.orders.new(order_status_id: 1)
            new_order.save
        end
    end

    def fulfill_order
        order = Order.find_by(payment_intent: params[:data][:object][:payment_intent])
        
        if order
            order.status = 3
            order.save
        end
    end
end