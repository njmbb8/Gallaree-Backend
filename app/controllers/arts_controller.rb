class ArtsController < ApplicationController
    before_action :authorize, except: [:index]

    def index
        render json: Art.order(:created_at).reverse_order
    end

    def create
        art_params.to_h => {title:, description:, price:, status:, quantity:, length:, height:, width:, weight:, photo:}

        image = add_watermark(art_params[:photo])

        @art = Art.new({
            title: title,
            description: description,
            price: price,
            status: status,
            quantity: quantity,
            length: length,
            height: height,
            width: width,
            weight: weight
        })
        @art.photo.attach(io: StringIO.new(image.write_to_buffer(".jpg")), filename: "test-#{ Time.current.to_i }.jpg", content_type: "image/jpg")
        if @art.save
            Stripe::Product.create({
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
            }).to_h=>{id:, default_price:}
            @art.update(product_code: id, stripe_price: default_price )
            recipients = User.where(admin: false)
            recipients.each{|recipient| ArtMailer.with(recipient: recipient, art: @art).notify.deliver_now}
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
            if art_params[:photo] != @art.photo
                image = add_watermark(art_params[:photo])
                @art.photo.attach(io: StringIO.new(image.write_to_buffer(".jpg")), filename: "test-#{ Time.current.to_i }.jpg", content_type: "image/jpg")
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

    def authorize
        render json: {error: "you are not signed in"}, status: :forbidden if !cookies.signed[:user_id]
        @user = User.find(cookies.signed[:user_id])
        render json: {error: "you are not authorized"}, status: :unauthorized if !@user.admin
    end

    def add_watermark(photo)
        image = Vips::Image.new_from_file photo.to_path

        watermark = Vips::Image.text "Shai Prince Art", width: 200, dpi: 200, font: "sans bold"
        watermark = watermark.rotate(-45)
        watermark = (watermark * 0.3).cast(:uchar)
        watermark = watermark.gravity :centre, 200, 200
        watermark = watermark.replicate 1 + image.width / watermark.width, 1 + image.height / watermark.height
        watermark = watermark.crop 0, 0, image.width, image.height

        overlay = (watermark.new_from_image [255, 128, 128]).copy interpretation: :srgb
        overlay = overlay.bandjoin watermark
        image = image.composite overlay, :over

        return image
    end
end
