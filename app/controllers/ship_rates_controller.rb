class ShipRatesController < ApplicationController
    before_action :pre_flight_checks, only: [:show]

    def show
        packages = [
            {
                :id => 0,
                :service => "ONLINE",
                :zip_origination => "25301",
                :zip_destination => Address.find(@order[:shipping_id]).postal_code,
                :container => '',
                :width => 0,
                :length => 0,
                :height => 0,
                :value => 0,
                :pounds => 0,
                :ounces => 0,
                :machinable => true
            }
        ]
        
        @order.order_items.each do |item|
            item.quantity.times do
                height = packages.last[:height] + item.art.height
                width = packages.last[:width] >= item.art.width ? packages.last[:width] : item.art.width
                length = packages.last[:length] >= item.art.length ? packages.last[:length] : item.art.length
                weight = packages.last[:pounds] + item.art.weight
                value = packages.last[:value] + item.art.price
    
                if weight > 70 || 2 * width + 2 * height + length >= 108
                    packages.push({
                        :id => packages.length,
                        :service => "ONLINE",
                        :zip_origination => "25301",
                        :zip_destination => Address.find(@order[:shipping_id]).postal_code,
                        :container => '',
                        :width => item.art.width,
                        :length => item.art.length,
                        :height => item.art.height,
                        :value => item.art.price,
                        :pounds => item.art.weight,
                        :ounces => 0,
                        :machinable => true
                    })
                else
                    packages.last[:length] = length
                    packages.last[:height] = height
                    packages.last[:width] = width
                    packages.last[:pounds] = weight
                    packages.last[:weight] = value
                end
            end
        end
    
        usps = Usps::Client.new({
            user_id: Rails.application.credentials.usps[:username]
        })
        
        rates = usps.rate_v4({
            :rate_v4_request => {
                :revision => 2,
                :packages => packages
            }
        })
    
        render json: rates, status: :ok
    end

    private

    def pre_flight_checks
        render json: {error: 'You are not signed in'}, status: :unauthorized if cookies.signed[:user_id].nil?
        user = User.find(cookies.signed[:user_id])
        render json: {error: 'This is not your order'}, status: :forbidden if user.nil?
        @order = user.orders.find(params[:id])
        render json: {error: 'Could not locate the order'}, status: :not_found if @order.nil?
        render json: {error: 'Please Select an address'}, status: :unprocessable_entity if @order.shipping_id.nil?
    end
end
