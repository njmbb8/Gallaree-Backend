class OrderMailer < ApplicationMailer
    def ordered
        @order = params[:order]
        @subtotal = '%.2f' % (@order.order_items.sum { |item| item.art.price * item.quantity }).round(2)
        @stripe_fees = '%.2f' % ((@subtotal.to_f * 0.029) + 0.30).round(2)
        @total = @subtotal.to_f + @stripe_fees.to_f
        mail to: @order.user.email, subject: "Your order ##{@order.id} has been placed!"
    end

    def shipped
        @order = params[:order]

        mail to: @order.user.email, subject: "Your order ##{@order.id} has shipped!"
    end

    def failed
        @order = params[:order]

        mail to: @order.user.email, subject: "Your order id#: #{@order.id} was not able to complete"
    end
end