class StatusesController < ApplicationController
    def index
        statuses = Status.all
        render json: statuses
    end
end
