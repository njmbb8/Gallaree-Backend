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
end
