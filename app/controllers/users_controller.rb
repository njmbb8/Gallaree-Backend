class UsersController < ApplicationController
    def create
        @user = User.new(user_params)
        if @user.save
            @order = Order.create!(:user_id => @user.id, :status => 1)
            @user.send_confirmation_email!
            cookies.permanent[:user_id] = {
                value: @user.id,
                domain: :all
            }
            cookies.permanent[:order] = {
                value: @order.id,
                domain: :all
            }
            render json: @user, status: :created
        else
            render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def show
        @user = User.find(cookies[:user_id])
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
