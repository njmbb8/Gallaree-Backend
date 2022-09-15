class ArtsController < ApplicationController
    rescue_from ActiveRecord::RecordNotSaved, with: :show_errors

    def index
        render json: Art.order(:created_at).reverse_order
    end

    def create
        @art = Art.new(art_params)
        if @art.save
            id = Stripe::Product.create({
                default_price_data:{
                    currency: 'usd',
                    unit_amount: @art.price * 100
                },
                active: @art.status_id == 2,
                images: [polymorphic_url(@art.photo)],
                package_dimensions:{
                    height: @art.height,
                    length: @art.length,
                    width: @art.width,
                    weight: @art.weight
                },
                shippable: true,
                tax_code: 'txcd_99999999',
                name: @art.title,
                description: @art.description
            })[:id]
            @art.update(product_code: id)
            render json: @art, status: :created
        else
            render json: { error: "Art did not save" }, status: :unprocessable_entity
        end
    end

    def update
        @art = Art.find(params[:id])
        if @art
            product = {
                active: @art.status_id == 2,
                images: [polymorphic_url(@art.photo)],
                package_dimensions:{
                    height: @art.height,
                    length: @art.length,
                    width: @art.width,
                    weight: @art.weight
                },
                name: @art.title,
                description: @art.description
            }
            if @art.price != params[:price].to_i
                product[:default_price] = Stripe::Price.create({
                    currency: 'usd',
                    unit_amount: params[:price],
                    product: @art.product_code
                })
            end
            @art.update(art_params)
            Stripe::Product.update(
                @art.product_code,
                product
            )
            render json: @art
        else
            render json: { error: "Art not found" }, status: :not_found
        end
    end

    def destroy
        @art = Art.find(params[:id])
        if @art
            @art.destroy
            head :ok
        else
            render json: { error: "Art not found" }, status: :not_found
        end
    end

    private

    def show_errors(exception)
        pp exception
    end

    def art_params
        params.permit(:title, :description, :price, :status_id, :photo, :quantity, :length, :height, :width, :weight)
    end
end
