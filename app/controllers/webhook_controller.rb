class WebhookController < ApplicationController
    def create
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

        intent = event[:data][:object]
        order = Order.find(intent[:metadata][:order_id])

        case event['type']
        when 'payment_intent.succeeded'
            order.order_items.each do |item|
                item.art.update(quantity: item.art.quantity - item.quantity)
            end
            order.update(status: 'Ready To Ship')
            order.user.order.create!(
                status: 'New'
            )
        when 'payment_intent.processing'
            order.update(status: 'Processing Payment')
        when 'payment_intent.payment_failed'
            order.update(status: 'Payment Failed', details: intent['last_payment_error']['message'])
        when 'payment_intent.canceled'
            order.order_items.each do |item|
                item.art.update(quantity: item.art.quantity - item.quantity)
            end
            order.update(status: 'Canceled')
        end
    
        head :ok
    end
end
