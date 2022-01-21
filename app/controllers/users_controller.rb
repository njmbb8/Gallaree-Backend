class UsersController < ApplicationController
    # rescue_from ActiveRecord::RecordInvalid with: :return_unprocessable
    def create
        user = User.create(user_params)
        if user.valid?
            render json: user, status: :created
        else
            render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
    end

    private

    def user_params
        params.permit(:email, :firstname, :lastname, :addr1, :addr2, :city, :state, :zip, :password, :password_confirmation)
    end

    # def return_unprocessable(error)
    #     render json: 
    # end
end
