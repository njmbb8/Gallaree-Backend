class UsersController < ApplicationController
    def create
        @user = User.new(email: params[:email], password: params[:password], password_confirmation: params[:password_confirmation])
        if @user.save
            customer_id = Stripe::Customer.create({
                address: {
                    line1: params[:billingAddr1],
                    line2: params[:billingAddr2],
                    city: params[:billingCity],
                    state: params[:billingState],
                    country: params[:billingCountry],
                    postal_code: params[:billingZip]
                },
                email: @user.email,
                name: "#{params[:firstname]} #{params[:lastname]}",
                phone: params[:phone],
                shipping: {
                    address: {
                        city: params[:sameAsShipping] ? params[:billingCity] : params[:shippingCity],
                        country: params[:sameAsShipping] ? params[:billingCountry] : params[:shippingCountry],
                        line1: params[:sameAsShipping] ? params[:billingAddr1] : params[:shippingAddr1],
                        line2: params[:sameAsShipping] ? params[:billingAddr2] : params[:shippingAddr2],
                        postal_code: params[:sameAsShipping] ? params[:billingZip] : params[:shippingZip],
                        state: params[:sameAsShipping] ? params[:billingState] : params[:shippingState]
                    },
                    name: "#{params[:firstname]} #{params[:lastname]}",
                    phone: params[:phone]
                }
            })
            @user.update(stripe_id: customer_id)
            @order = Order.create!(:user_id => @user.id, :status => 1)
            @user.send_confirmation_email!
            cookies.permanent[:user_id] = {
                value: @user.id,
                domain: :all
            }
            render json: @user, status: :created
        else
            render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def show
        @user = User.find(cookies.signed[:user_id])
        if @user
            render json: @user, status: :ok
        else
            render json: { errors: "Not Authorized" }
        end
    end

    private

    def user_params
        params.require(:user).permit(
            :email, :firstname, :lastname, :password, :password_confirmation,
            addresses_attributes: [:id, :address_line1, :address_line2, :city, :state, :postal_code, :country]
        )
    end
end
