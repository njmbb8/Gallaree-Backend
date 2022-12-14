class SetupIntentController < ApplicationController
    def create
        user = User.find(cookies.signed[:user_id])
        if user
            @intent = Stripe::SetupIntent.create({
                customer: user.stripe_id,
                usage: 'on_session',
                payment_method_types:['card']
            })
            render json: {clientSecret: @intent[:client_secret]}, status: :created
        else
            render json: {error: "you are not logged in"}, status: :forbidden
        end
    end
end