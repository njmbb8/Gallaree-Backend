class PaymentIntentController < ApplicationController
    def create
        @payment_intent = Stripe::PaymentIntent.create(
            amount: Order.find(params[:order_id]).order_items.sum { |item| item.art.price * item.quantity },
            currency: 'usd',
            automatic_payment_methods: {
                enabled: true
            }
        )
    end
end
