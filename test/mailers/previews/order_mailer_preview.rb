class OrderMailerPreview < ActionMailer::Preview
    def failed
        OrderMailer.with(order: Order.second_to_last).failed
    end

    def ordered
        OrderMailer.with(order: Order.second_to_last).ordered
    end
end