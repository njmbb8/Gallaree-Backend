class CheckoutSessionController < ApplicationController
    def create
        user = User.find(cookis.signed[:user_id])
        order = user.orders.last
        if user
            session = Stripe::Checkout::Session.create({
                success_url: `#{Rails.configuration[:front_end]}/success`,
                cancel_url: request.headers[:referer],
                mode: 'payment',
                client_reference_id: order[:id],
                currency: 'usd',
                customer: user[:stripe_id],
                line_items: order.order_items.map{|item| {price: item[:stripe_id], quantity: item[:quantity]}}
            })
            render json: {session_id: session[:id]}, status: :ok
        else
            render json: {error: 'You are not signed in'}, status: :unauthorized
        end
    end
end