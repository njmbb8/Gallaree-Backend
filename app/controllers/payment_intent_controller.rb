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