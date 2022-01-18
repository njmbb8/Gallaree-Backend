class ArtsController < ApplicationController
    rescue_from ActiveRecord::RecordNotSaved, with: :show_errors

    def index
        render json: Art.all
    end

    def create
        art = Art.create!(art_params)
        render json: art, status: :created
    end

    private

    def show_errors(exception)
        pp exception
    end

    def art_params
        params.permit(:title, :description, :price, :status_id, :photo)
    end
end
