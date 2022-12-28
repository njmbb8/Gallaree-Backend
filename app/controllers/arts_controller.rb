class ArtsController < ApplicationController
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
                active: @art.status == "For Sale",
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
            })[:default_price]
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
                active: @art.status == "For Sale" && art_params[:quantity].to_i >= 0,
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
            art_params[:quantity].to_i <= 0 ? art_params[:status] = "Sold Out" : art_params[:status] = @art.status
            @art.update(art_params)
            Stripe::Product.update(
                @art.product_code,
                product
            )
            render json: @art, status: :ok
        else
            render json: { error: "Art not found" }, status: :not_found
        end
    end

    def destroy
        @art = Art.find(params[:id])
        if @art
            Stripe::Product.update(@art.product_code, {active: false})
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
        params.permit(:title, :description, :price, :status, :photo, :quantity, :length, :height, :width, :weight)
    end
end
