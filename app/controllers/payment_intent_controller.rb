class PaymentIntentController < ApplicationController

    wrap_parameters false

    def index
        user = User.find(cookies.signed[:user_id])
        render json: user, serializer: CheckoutInfoSerializer, status: :ok 
    end

    def create
        user = User.find(cookies.signed[:user_id])
        shipping_address = user.addresses.find(intent_params[:shipping_id])
        @order = user.orders.last
        @payment_intent = Stripe::PaymentIntent.create(
            amount: calculate_total,
            currency: 'usd',
            confirm: true,
            customer: user[:stripe_id],
            metadata: {order_id: @order.id},
            off_session: false,
            payment_method: intent_params[:payment_method_id],
            payment_method_types: ['card'],
            receipt_email: user[:email],
            setup_future_usage: 'on_session',
            shipping: {
                name: "#{user.firstname} #{user.lastname}",
                address: {
                    line1: shipping_address[:line1],
                    line2: shipping_address[:line2],
                    city: shipping_address[:city],
                    state: shipping_address[:state],
                    postal_code: shipping_address[:postal_code]
                }
            },
            return_url: "#{Rails.configuration.front_end}/order/#{@order.id}"
        )
        order.update(
            payment_intent: @payment_intent[:id], 
            place_time: Time.now, 
            shipping_id: shipping_address.id, 
            billing_id: user.addresses.find_by(billing: true)[:id]
        )
        render json: { id: @payment_intent[:id], client_secret: @payment_intent[:client_secret]}, status: :ok
    end

    private

    def calculate_total
        sum = @order.order_items.sum {|item| item.art.price * item.quantity} * 100
        sum_with_percentage = sum + (0.029 * sum)
        (sum_with_percentage + 30).ceil
    end

    def intent_params
        params.permit(
            :payment_method_id,
            :shipping_id
        )
    end
end