class ShipRatesController < ApplicationController
    def show
        if cookies.signed[:user_id]
            user = User.find(cookies.signed[:user_id])
            if user
                order = Order.find(params[:id])
                if order
                    packages = [
                        {
                            :id => 0,
                            :service => "ONLINE",
                            :zip_origination => "25301",
                            :zip_destination => Address.find(order[:shipping_id]).postal_code,
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
                    
                    order.order_items.each do |item|
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
                                    :zip_destination => Address.find(order[:shipping_id]).postal_code,
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
            end

        else
            render json: {error: "you are not signed in"}, status: :unauthorized
        end
    end
end
