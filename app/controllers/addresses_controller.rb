class AddressesController < ApplicationController    
    def create
        user = User.find(cookies.signed[:user_id])
        if user
            Stripe::Customer.update(user.stripe_id, address_params.to_h)
            render json: user, status: :created
        else
            render json: {error: 'You are not logged in'}, status: :unauthorized
        end
    end

    private

    def address_params
        params.require(:addresses).permit(:address => [:city, :country, :line1, :line2, :postal_code, :state], :shipping => [:name, :phone, :address => [:city, :country, :line1, :line2, :postal_code, :state]])
    end
end
