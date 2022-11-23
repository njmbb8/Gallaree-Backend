class OrderItemsController < ApplicationController
    
    def create
        @order = User.find(cookies.signed[:user_id]).orders.last
        if @order
            if @order.order_items.find_by(art_id: order_item_params[:art_id])
                @order_item = @order.order_items.find_by(art_id: order_item_params[:art_id])
                if (@order_item[:quantity] + order_item_params[:quantity]) <= @order_item.art[:quantity]
                    if @order_item.update(quantity: @order_item[:quantity]+order_item_params[:quantity])
                        render json: @order_item, status: :ok
                    else
                        render json: {error: "could not update cart"}, status: :unprocessable_entity
                    end
                else
                    render json: {error: "Trying to add too many items"}, status: :unprocessable_entity
                end
            else
                @order_item = @order.order_items.new(order_item_params)
                if @order_item[:quantity] <= @order_item.art[:quantity]
                    if @order_item.art[:status] != 'For Sale'
                        if @order_item.save
                            render json: @order_item, status: :ok
                        else
                            render json: {error: "unable to add item to cart"}, status: :unprocessable_entity
                        end
                    else
                        render json: {error: "item not for sale"}
                    end
                else
                    render json: {error: "you are adding too many items"}
                end
            end
        else
            render json: {error: "Order does not exist"}, status: :not_found
        end
    end

    def update
        @order = User.find(cookies.signed[:user_id]).orders.last
        if @order
            @order_item = @order.order_items.find(params[:id])
            if @order_item
                if @order_item[:quantity] <= @order_item.art[:quantity]
                    if @order_item.update(order_item_params)
                        render json: @order_item, status: :ok
                    else
                        render json: {error: 'could not update item'}, status: :unprocessable_entity
                    end
                else
                    render json: {error: "trying to add too many items"}, status: :unprocessable_entity
                end
            else
                render json: {error: "order item not found"}, status: :not_found
            end
        else
            render json: {error: "order does not exist"}, status: :not_found
        end
    end

    def destroy
        @user = User.find(cookies[:user_id])
        if @user
            @order = @user.orders.last
            if @order
                @order_item = @order.order_items.find(params[:id])
                if @order_item
                    @order_item.destroy
                    head :ok
                else
                    render json: {error: "could not find order item"}, status: :not_found
                end
            else
                render json: {error: "order could not be found"}, status: :not_found
            end
        else
            render json: {error: "you are not signed in"}, status: :unauthorized
        end
    end

    private
    def order_item_params
        params.permit(:art_id, :quantity)
    end
end
