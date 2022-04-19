class OrderItemsController < ApplicationController
    before_action :check_ownership, only: [:update, :destroy]
    
    def create
        @order = User.find(cookies.signed[:user_id]).orders.last
        if @order
            if @order.order_items.find_by(art_id: params[:art_id])
                order_item = @order.order_items.find_by(art_id: params[:art_id])
                if order_item.quantity + params[:quantity].to_i > Art.find(params[:art_id]).quantity
                    render json: {error: 'quantity in order exceeds quantity available'}, status: :unprocessable_entity
                elsif order_item.quantity + params[:quantity].to_i < 0
                    render json: {error: 'can not add negative amounts'}, status: :unprocessable_entity
                else
                    order_item.update(quantity: order_item.quantity + params[:quantity].to_i)
                    render json: @order, status: :accepted
                end
            else
                @order_item = @order.order_items.new(art_id: params[:art_id], quantity: params[:quantity])
                if params[:quantity] < 0
                    render json: {error: "can not add negative amount of items"}, status: :unprocessable_entity
                else
                    if @order_item.save
                        render json: @order, status: :created
                    else
                        render json: { error: 'Unable to add item to order' }, status: :unprocessable_entity
                    end
                end
            end
        else
            render json: {error: "Order does not exist"}, status: :not_found
        end
    end

    def update
        if params[:quantity].to_i < 0
            render json: {error: "can not set quantity to negative"}, status: :unprocessable_entity
        elsif params[:quantity].to_i > @order_item.quantity
            render json: {error: "can not set quantity larger than stock"}
        else
            @order_item.quantity = params[:quantity]
            if @order_item.save
                render json: @order, status: :ok
            else
                render json: {error: 'Unable to update item' }, status: :unprocessable_entity
            end
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
