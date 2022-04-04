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
        event = nil
        begin
            sig_header = request.env['HTTP_STRIPE_SIGNATURE']
            payload = request.body.read
            event = Stripe::Webhook.construct_event(payload, sig_header, Rails.application.credentials.stripe[:endpoint_secret])
        rescue JSON::ParserError
            render json: {error: 'Invalid payload'}, status: :bad_request
            return false
        rescue Stripe::SignatureVerificationError
            render json: {error: 'Invalid signature'}, status: :bad_request
            return false
        end

        case event['type']
        when 'charge.succeeded'
            checkout_session = event['data']['object']
            mark_as_pending
            if checkout_session.status == 'succeeded'
                fulfill_order
            end
        when 'checkout.session.async_payment_succeeded'
            fulfill_order
        when 'checkout.session.async_payment_failed'
            #handle failed payments
        end
    
        head :ok
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