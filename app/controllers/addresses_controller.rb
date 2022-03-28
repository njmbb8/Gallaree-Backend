class AddressesController < ApplicationController
    before_action :check_ownership, only: [:update, :destroy]
    
    def create
        @user = User.find(cookies[:user_id])
        if @user
            @address = @user.addresses.new(address_params)
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
        if @address.update(address_params)
            render json: @address, status: :ok
        else
            render json: { error: "could not update address"}, status: :unprocessable_entity
        end
    end

    def destroy
        @address.destroy
        head :ok
    end

    private

    def check_ownership
        @address = Address.find(params[:id])
        if @address
            render json: {error: "address does not belong to user"}, status: :unauthorized unless @address.user.id == cookies[:user_id].to_i
        else
            render json: {error: "address not found"}, status: :not_found
        end
    end

    def address_params
        params.permit(:address_line1, :address_line2, :city, :postal_code, :country, :state, :shipping, :billing)
    end
end
