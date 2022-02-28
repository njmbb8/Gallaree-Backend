class PasswordsController < ApplicationController
    before_action :authorize

    def update
        if Current.user.update(password_params)
            head :accepted
        else
            render json: { error: 'password and confirm password must match' }, status: :bad_request
        end
    end

    private

    def password_params
        params.require(:user).permit(:password, :password_confirmation)
    end
end