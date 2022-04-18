class OrderItemsController < ApplicationController
    before_action :check_ownership, only: [:update, :destroy]
    
    def create
        @order = User.find(cookies.signed[:user_id]).orders.last
        if @order
            if @order.order_items.find_by(art_id: params[:art_id])
                order_item = @order.order_items.find_by(art_id: params[:art_id])
                order_item.update(quantity: order_item.quantity + params[:quantity].to_i)
                render json: @order, status: :accepted
            else
                @order_item = @order.order_items.new(art_id: params[:art_id], quantity: params[:quantity])
                if @order_item.save
                    render json: @order, status: :created
                else
                    render json: { error: 'Unable to add item to order' }, status: :unprocessable_entity
                end
            end
        else
            render json: {error: "Order does not exist"}, status: :not_found
        end
    end

    def update
        @order_item.quantity = params[:quantity]
        if @order_item.save
            render json: @order, status: :ok
        else
            render json: {error: 'Unable to update item' }, status: :unprocessable_entity
        end
    end

    def destroy
        @order_item.destroy
        render json: @order, status: :ok
    end

    private

    def check_ownership
        @user = User.find(cookies.signed[:user_id])
        @order = @user.orders.last
        @order_item = OrderItem.find(params[:id])
        if @order_item
            render json: { error: "item not in order" }, status: :unauthorized unless @order_item.order_id == @order.id
        else
            render json: { error: "order item not found" }, status: :not_found
        end
    end

    def order_item_params
        params.permit(:arts_id)
    end
end
