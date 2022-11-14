class UsersController < ApplicationController

    wrap_parameters false

    def create
        @user = User.new(
            email: user_params[:email], 
            firstname: user_params[:firstname], 
            lastname: user_params[:lastname], 
            password: user_params[:password], 
            password_confirmation: user_params[:password_confirmation]
        )
        if @user.save
            customer_id = Stripe::Customer.create({
                address: {
                    line1: user_params[:billingAddr1],
                    line2: user_params[:billingAddr2],
                    city: user_params[:billingCity],
                    state: user_params[:billingState],
                    country: 'USA',
                    postal_code: user_params[:billingZip]
                },
                email: @user.email,
                name: "#{user_params[:firstname]} #{user_params[:lastname]}",
                phone: user_params[:phone],
                shipping: {
                    address: {
                        city: user_params[:sameAsShipping] ? user_params[:billingCity] : user_params[:shippingCity],
                        country: 'USA',
                        line1: user_params[:sameAsShipping] ? user_params[:billingAddr1] : user_params[:shippingAddr1],
                        line2: user_params[:sameAsShipping] ? user_params[:billingAddr2] : user_params[:shippingAddr2],
                        postal_code: user_params[:sameAsShipping] ? user_params[:billingZip] : user_params[:shippingZip],
                        state: user_params[:sameAsShipping] ? user_params[:billingState] : user_params[:shippingState]
                    },
                    name: "#{user_params[:firstname]} #{user_params[:lastname]}",
                    phone: user_params[:phone]
                }
            })[:id]
            @user.update(stripe_id: customer_id)
            @order = Order.create!(:user_id => @user.id, :status => 1)
            # @user.send_confirmation_email!
            cookies.permanent.signed[:user_id] = @user.id
            render json: @user, status: :created
        else
            render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def show
        if cookies.signed[:user_id]
            user = User.find(cookies.signed[:user_id])
            render json: user, status: :ok
        else
            render json: { error: "You are not logged in"}, status: :unauthorized
        end
    end

    private

    def user_params
        params.permit(
            :email, :firstname, :lastname, :password, :password_confirmation,
            :billingAddr1, :billingAddr2, :billingCity, :billingState, :billingZip,
            :sameAsShipping, :shippingAddr1, :shippingAddr2, :shippingCity, :shippingState, :shippingZip,
            :phone
        )
    end
end
