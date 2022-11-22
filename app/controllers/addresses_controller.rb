class AddressesController < ApplicationController    
    def index
        @user = User.find(cookies.signed[:user_id])
        if @user
            if @user.admin
                render json: Address.all, status: :ok
            else
                @addresses = @user.addresses.where(archived: false)
                render json: @addresses, status: :ok
            end
        else
            render json: {error: 'you are not signed in'}, status: :unauthorized
        end
    end

    def create
        user = User.find(cookies.signed[:user_id])
        if user
            new_address = user.address.new(address_params)
            new_address[:archived] = false

            if new_address.save
                if address_params[:shipping] || address_params[:billing]
                    stripe_data = {}
                    if address_params[:shipping]
                        user.addresses.where(shipping: true).first.update(shipping: false)
                        stripe_data[:shipping][:address] = {
                            line1: new_address[:line1],
                            line2: new_address[:line2],
                            city: new_address[:city],
                            state: new_address[:state],
                            postal_code: new_address[:postal_code],
                            country: "USA"
                        }
                    end
                    if address_params[:billing]
                        user.addresses.where(billing: true).first.update(billing: false)
                        stripe_data[:address] = {
                            line1: new_address[:line1],
                            line2: new_address[:line2],
                            city: new_address[:city],
                            state: new_address[:state],
                            postal_code: new_address[:postal_code],
                            country: "USA"
                        }
                    end
                    Stripe::Customer.update(user.stripe_id, stripe_data)
                end
                render json: new_address, status: :created
            else
                render json: {error: "Address could not be saved"}, status: :unprocessable_entity
            end
            render json: user, status: :created
        else
            render json: {error: 'You are not logged in'}, status: :unauthorized
        end
    end

    def update
        user = User.find(cookies.signed[:user_id])
        if user
            address = user.addresses.find(params[:id])
            if address
                if address_params[:billing] != address[:billing] || address_params[:shipping] != address[:shipping]
                    stripe_data = {}
                    if address[:billing] && !address_params[:billing]
                        user.addresses.where(archived: false, billing: false).last.update(billing: true)
                        stripe_data[:address] = user.addresses.where(archived: false).last
                    elsif !address[:billing] && address_params[:billing]
                        user.addresses.where(billing: true, archived: false).update_all(billing: false)
                        stripe_data[:address] = address
                    elsif address[:shipping] && !address_params[:shipping]
                        user.addresses.where(archived: false, shipping: false).last.update(shipping: true)
                        stripe_data[:shipping][:address] = user.addresses.where(archived: false, shipping: false).last
                    elsif !address[:shipping] && address_params[:shipping]
                        user.addresses.where(shipping: true, archived: false).update_all(shipping: false)
                        stripe_data[:address] = address
                    end
                    Stripe::Customer.update(user.stripe_id, stripe_data)
                end
                address.update(address_params)
                render json: address, status: :ok
            else
                render json: {error: 'could not find address'}, status: :not_found
            end
        else
            render json: {error: 'you are not logged in'}, status: :unauthorized
        end
    end

    def destroy
        user = User.find(cookies.signed[:user_id])
        if user
            address = user.addresses.find(params[:id])
            if address
                updated_addresses = []
                if address[:billing]
                    billing_addr = user.addresses.where(archived: false, billing: false).last
                    billing_addr.update(billing: true)
                    updated_addresses.push(billing_addr)
                end
                if address[:shipping]
                    shipping_addr = user.addresses.where(archived: false, shipping: false).last
                    shipping_addr.update(shipping: true)
                    updated_addresses.push(shipping_addr)
                end
                address.update(archived: true)
                render json: updated_addresses, status: :ok
            else
                render json: {error: "could not find address"}, status: :not_found
            end
        else
            render json: {error: "you are not signed in"}, status: :ok
        end
    end

    private

    def address_params
        params.require(:address).permit(:city, :line1, :line2, :postal_code, :state, :billing, :shipping)
    end
end
