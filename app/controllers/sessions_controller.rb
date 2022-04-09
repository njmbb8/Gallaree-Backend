class SessionsController < ApplicationController
    def create
        user = User.find_by(email: params[:email])
        if user&.authenticate(params[:password])
            cookies.permanent.signed[:user_id] = user.id
            render json: user, status: :created
        else
            render json: { error: "Invalid username or password" }, status: :unauthorized
        end
    end

    def destroy
        cookies.delete :user_id
        head :no_content
    end
end 