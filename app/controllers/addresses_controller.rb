class AddressesController < ApplicationController
    before_action :check_ownership, only: [:update, :destroy]
    
    def create
        @user = User.find(cookies.signed[:user_id])
        if @user
            @address = @user.addresses.new(address_params)
            if @address.shipping || @user.addresses.empty?
                set_default
            end
            if @address.save
                render json: @address, status: :ok
            else
                render json: { error: "Could not save address" }, status: :unprocessable_entity
            end
        else
            render json: { error: "could not find user" }, status: :not_found
        end
    end
    
    def update
        if @address.shipping == false && address_params[:shipping] == "true"
            set_default
        end
        if @address.update(address_params)
            render json: @address, status: :ok
        else
            render json: { error: "could not update address"}, status: :unprocessable_entity
        end
    end

    def destroy
        @address.update(archived: true)
        if @address.user.orders.last.shipping_id == @address.id
            @address.user.orders.last.update(shipping_id: @address.user.addresses.find_by(shipping: true).id)
        end
        if @address.shipping
            @address.user.addresses.where(:archived => false).first.update(shipping: true)
        end
        head :ok
    end

    private
    def set_default
        @address.user.addresses.map {|address| address.update(shipping: false)}
        @address.update(shipping: true)
    end

    def check_ownership
        @address = Address.find(params[:id])
        if @address
            render json: {error: "address does not belong to user"}, status: :unauthorized unless @address.user.id == cookies.signed[:user_id].to_i
        else
            render json: {error: "address not found"}, status: :not_found
        end
    end

    def address_params
        params[:postal_code] = params[:postal_code].to_i
        params.permit(:address_line1, :address_line2, :city, :postal_code, :country, :state, :shipping, :billing)
    end
end
