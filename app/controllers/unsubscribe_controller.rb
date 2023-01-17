class UnsubscribeController < ApplicationController
    def update
        @user = User.find_signed(params[:id], purpose: 'unsubscribe')
        if @user.update(unsubscribe: DateTime.current)
            head :ok
        else
            head :unprocessable_entity
        end
    end
end
