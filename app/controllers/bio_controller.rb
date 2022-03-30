class BioController < ApplicationController
    def index
        render json: Bio.last, status: :ok
    end

    def create
        bio = Bio.create!(bio_params)
        if bio
            render json: bio, status: :ok
        else
            render json: {error: "could not save bio"}, status: :unprocessable_entity
        end
    end

    private

    def bio_params
        params.permit(:artist_statement, :biography, :photo)
    end
end
