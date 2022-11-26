class PaymentIntentController < ApplicationController
    def create
        user = User.find(cookies.signed[:user_id])
        shipping_address = user.addresses.find(intent_params[:shipping_id])
        @order = user.orders.last
        @payment_intent = Stripe::PaymentIntent.create(
            amount: calculate_total,
            currency: 'usd',
            automatic_payment_methods:{
                enabled: false
            },
            confirm: true,
            customer: user[:stripe_id],
            off_session: false,
            payment_mathod: intent_params[:payment_method],
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
            }

        )
        render json: { id: payment_intent[:id], client_secret: @payment_intent[:client_secret]}, status: :ok
    end

    def update
        @order = Order.find(params[:id].to_i)
        address = Address.find(@order.shipping_id)
        if @order
            if @order.user_id == cookies.signed[:user_id]
                Stripe::PaymentIntent.update(@order.payment_intent, {
                    amount: calculate_total,
                    shipping: {
                        address: {
                            city: address.city,
                            country: address.country,
                            line1: address.address_line1,
                            line2: address.address_line2,
                            postal_code: address.postal_code,
                            state: address.state
                        },
                        name: "#{@order.user.firstname} #{@order.user.lastname}"
                    }
                })
                render json: @order, status: :ok
            else
                render json: {error: "this order does not belong to you"}, status: :unauthorized
            end
        else
            render json: {error: "order not found"}, status: :not_found
        end
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