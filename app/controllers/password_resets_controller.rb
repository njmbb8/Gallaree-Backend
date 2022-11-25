class PasswordResetsController < ApplicationController
    rescue_from ActiveSupport::MessageVerifier::InvalidSignature, with: :invalid_token

    def update
        user = User.find_signed!(params[:token], purpose: 'password_reset')
        if user.update(password_params)
            head :accepted
        end
    end

    def create
        user = User.find_by(email: params[:email])
        if user.present?
            PasswordMailer.with(user: user).reset.deliver_later
            head :accepted
        end
    end

    def invalid_token
        render json: { error: 'Your token has expired, try resetting again' }, status: :unauthorized
    end

    private
    def password_params
      params.permit(:password, :password_confirmation)
    end
end