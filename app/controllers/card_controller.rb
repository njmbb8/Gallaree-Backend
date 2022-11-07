class CardController < ApplicationController
    def index
        user = User.find(cookies.signed[:user_id])
        if user
            cards = user.cards.where.not(archived: true)
            render json: cards, status: :ok
        else
            render json: {error: "you are not logged in"}, status: :forbidden
        end
    end

    def destroy
        user = User.find(cookies.signed[:user_id])
        if user
            card = user.cards.find(params[:id])
            if card
                Stripe::PaymentMethod.detach(card[:stripe_id])
                card.update(archived: true)
                render json: card, status: :ok
            else
                render json: { error: 'invalid card id or that is not your card'}, status: :forbidden
            end
        else
            render json: { error: 'You are not signed in' }, status: :unauthorized
        end
    end

    def create
        user = User.find(cookies.signed[:user_id])
        if user
            card = user.cards.create(card_params)
            if card
                render json: card, status: :created
            else
                render json: { error: 'could not save card' }, status: :unprocessable_entity
            end
        else
            render json: {error: 'you are not signed in'}, status: :unauthorized
        end
    end

    private

    def card_params
        params.require(:card).permit(
            :stripe_id,
            :last4,
            :exp_month,
            :exp_year,
            :brand
        )
    end
end