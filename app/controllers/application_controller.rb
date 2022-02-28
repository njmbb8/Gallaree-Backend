class ApplicationController < ActionController::API
    include ActionController::Cookies

    before_action :set_current_user
    def set_current_user
        if cookies[:user_id]
            Current.user = User.find_by(id: cookies[:user_id])
        end
    end

    def authorize
        if Current.user.nil?
            return render json: { error: "Not Authorized" }, status: :unauthorized
        end
    end
end
