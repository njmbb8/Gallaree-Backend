class ArtsController < ApplicationController
    rescue_from ActiveRecord::RecordNotSaved, with: :show_errors

    def index
        render json: Art.order(:created_at).reverse_order
    end

    def create
        art = Art.create!(art_params)
        render json: art, status: :created
    end

    def update
        art = Art.find(params[:id])
        if art
            art.update(art_params)
            render json: art
        else
            render json: { error: "Art not found" }, status: :not_found
        end
    end

    def destroy
        art = Art.find(params[:id])
        if art
            art.destroy
            head :no_content
        else
            render json: { error: "Art not found" }, status: :not_found
        end
    end

    private

    def show_errors(exception)
        pp exception
    end

    def art_params
        params.permit(:title, :description, :price, :status_id, :photo)
    end
end
