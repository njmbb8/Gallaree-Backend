class UsersController < ApplicationController
    # rescue_from ActiveRecord::RecordInvalid with: :return_unprocessable
    def create
        user = User.create(user_params)
        if user.valid?
            user.send_confirmation_email!
            cookies.permanent[:user_id] = {
                value: user.id,
                domain: :all
            }
            render json: user, status: :created
        else
            render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def show
        user = User.find(cookies[:user_id])
        if user
            render json: user
        else
            render json: { errors: "Not Authorized" }
        end
    end

    private

    def user_params
        params.permit(
            :email, :firstname, :lastname, :password, :password_confirmation, :admin,
            addresses: [:address_line1, :address_line2, :city, :state, :postal_code, :country]
        )
    end

    # def return_unprocessable(error)
    #     render json: 
    # end
end
