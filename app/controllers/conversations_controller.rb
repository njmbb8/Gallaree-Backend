class ConversationsController < ApplicationController
    before_action :authorize, only: [:update]

    def index
        user = User.find(cookies.signed[:user_id])
        if user.admin
            render json: Conversation.all, status: :ok, each_serializer: ConversationIndexSerializer
        else
            render json: {error: "You are not signed in"}
        end
    end

    def show
        @conversation.messages.where(read: nil).where.not(user_id: @user.id).update_all(read: DateTime.current)
        render json: @conversation, status: :ok, serializer: ConversationSerializer
    end

    def create
        if cookies.signed[:user_id]
            user = User.find(cookies.signed[:user_id])
            if user
                byebug
                message = user.conversation.messages.new({
                    body: message_params
                })
                if message.save
                    render json: message, status: :ok
                else
                    render json: { error: "could not save message" }, status: :unprocessable_entity
                end
            else
                render json: {error: "invalid user id"}
            end
        else
            conversation_params => { body:, recipient_email:, recipient_name:, recipient_phone: }
            conversation = Conversation.new({
                recipient_email: recipient_email,
                recipient_phone: recipient_phone,
                recipient_name: recipient_name
            })
            if conversation.save
                message = conversation.messages.new({body: body})
                if message.save
                    render json: message, status: :ok
                else
                    render json: {error: "could not save message"}, status: :ok
                end
            else
                render json: {error: "could not save conversation"}, status: :unprocessable_entity
            end
        end
    end

    def update
        message = @conversation.message.new({
            user_id: @user.id,
            body: message_params
        })
        if message.save
            render json: message, status: :ok
        else
            render json: { error: "message could not be saved" }, status: :unprocessable_entity
        end
    end

    private

    def authorize
        render json: { error: "you are not signed in" }, status: :unauthorized unless cookies.signed[:user_id]
        @user = User.find(cookies.signed[:user_id])
        @conversation = Conversation.find(params[:id])
        render json: { error: "conversation does not exist" }, status: :not_found unless @conversation
        render json: { error: "this is an A-B conversation, C yo way out" }, status: :forbidden unless @user.admin || @user.id == conversation.sender_id
    end

    def conversation_params
         params.permit(:recipient_email, :recipient_phone, :recipient_name, :body)
    end

    def message_params
        params.permit(:body)
    end
end
