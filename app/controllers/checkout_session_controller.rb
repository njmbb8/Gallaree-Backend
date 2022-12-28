class CheckoutSessionController < ApplicationController

    wrap_parameters false

    def create
        user = User.find(cookies.signed[:user_id])
        order = user.orders.last
        if user
            session_options = {
                success_url: "#{Rails.configuration.front_end}/success",
                cancel_url: request.headers[:referer],
                mode: 'payment',
                client_reference_id: order[:id],
                currency: 'usd',
                customer: user[:stripe_id],
                line_items: order.order_items.map{|item| {price: item.art[:stripe_price], quantity: item[:quantity]}},
            }
            if address_params[:address]
                session_options[:payment_intent_data] = {
                    shipping: {
                        address: address_params
                    }
                }
                user.addresses.create(address_params)
            else
                ship_addr = user.addresses.find_by(shipping: true)
                session_options[:payment_intent_data] = {
                    shipping: {
                        name: "#{user[:firstname]} #{user[:lastname]}",
                        address: {
                            line1: ship_addr[:line1],
                            line2: ship_addr[:line2],
                            city: ship_addr[:city],
                            state: ship_addr[:state],
                            postal_code: ship_addr[:postal_code]
                        }
                    }
                }
            end
            session = Stripe::Checkout::Session.create(session_options)
            render json: {sessionId: session[:id]}, status: :ok
        else
            render json: {error: 'You are not signed in'}, status: :unauthorized
        end
    end

    private

    def address_params
        params.permit(:line1, :line2, :city, :state, :postal_code)
    end
end