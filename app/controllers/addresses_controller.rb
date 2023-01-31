class AddressesController < ApplicationController    
    before_action :user_signed_in, only: [:index, :create, :update, :destroy]
    def index
        if @user.admin
            render json: Address.all, status: :ok
        else
            @addresses = @user.addresses.where(archived: false)
            render json: @addresses, status: :ok
        end
    end

    def create
        new_address = @user.addresses.new(address_params)
        new_address[:archived] = false
        if @user.addresses.where(archived: false, shipping: true).count == 0
            new_address[:shipping] = true
        end
        if @user.addresses.where(archived: false, billing: true).count == 0 
            new_address[:billing] = true
        end
        if new_address.save
            if address_params[:shipping] || address_params[:billing]
                stripe_data = {}
                if address_params[:shipping]
                    @user.addresses.where(shipping: true).first.update(shipping: false)
                    stripe_data[:shipping] = {
                        name: "#{@user.firstname} #{@user.lastname}",
                        address: {
                            line1: new_address[:line1],
                            line2: new_address[:line2],
                            city: new_address[:city],
                            state: new_address[:state],
                            postal_code: new_address[:postal_code],
                            country: "USA"
                        }
                    }
                else
                    new_address.update(shipping: false)
                end
                if address_params[:billing]
                    @user.addresses.where(billing: true).first.update(billing: false)
                    stripe_data[:address] = {
                        line1: new_address[:line1],
                        line2: new_address[:line2],
                        city: new_address[:city],
                        state: new_address[:state],
                        postal_code: new_address[:postal_code],
                        country: "USA"
                    }
                else
                    new_address.update(billing: false)
                end
                Stripe::Customer.update(@user.stripe_id, stripe_data)
            else
                new_address.update(shipping: false, billing: false)
            end
            render json: @user.addresses.where(archived: false), status: :created and return
        else
            render json: {error: "Address could not be saved"}, status: :unprocessable_entity
        end
        render json: @user, status: :created
    end

    def update
        address = @user.addresses.find(params[:id])
        if address
            if address_params[:billing] != address[:billing] || address_params[:shipping] != address[:shipping]
                stripe_data = {}
                if address[:billing] && !address_params[:billing]
                    new_billing = @user.addresses.where(archived: false, billing: false).last
                    new_billing.update(billing: true)
                    stripe_data[:address] = stripe_friendly_address(new_billing)
                elsif !address[:billing] && address_params[:billing]
                    @user.addresses.where(billing: true, archived: false).update_all(billing: false)
                    stripe_data[:address] = stripe_friendly_address(address)
                end

                if address[:shipping] && !address_params[:shipping]
                    new_shipping = user.addresses.where(archived: false, shipping: false).last 
                    new_shipping.update(shipping: true)
                    stripe_data[:shipping] = {name: "#{@user[:firstname]} #{@user[:lastname]}", address: stripe_friendly_address(new_shipping)}
                elsif !address[:shipping] && address_params[:shipping]
                    @user.addresses.where(shipping: true, archived: false).update_all(shipping: false)
                    stripe_data[:shipping] = {name: "#{@user[:firstname]} #{@user[:lastname]}", address: stripe_friendly_address(address)}
                end
                Stripe::Customer.update(@user.stripe_id, stripe_data)
            end
            address.update(address_params)
            render json: @user.addresses.where(archived: false), status: :ok and return
        else
            render json: {error: 'could not find address'}, status: :not_found
        end
    end

    def destroy
        address = @user.addresses.find(params[:id])
        if address
            if address[:billing]
                billing_addr = @user.addresses.where(archived: false, billing: false).last
                billing_addr.update(billing: true)
            end
            if address[:shipping]
                shipping_addr = @user.addresses.where(archived: false, shipping: false).last
                shipping_addr.update(shipping: true)
            end
            address.update(archived: true)
            render json: @user.addresses.where(archived: false), status: :ok
        else
            render json: {error: "could not find address"}, status: :not_found
        end
    end

    private
    def user_signed_in
        render json: {error: "you are not signed in"}, status: :forbidden unless cookies.signed[:user_id]
        @user = User.find(cookies.signed[:user_id])
    end

    def stripe_friendly_address(address)
        return {
            line1: address.line1,
            line2: address.line2,
            city: address.city,
            state: address.state,
            postal_code: address.postal_code
        }
    end

    def address_params
        params.require(:address).permit(:city, :line1, :line2, :postal_code, :state, :billing, :shipping)
    end
end
