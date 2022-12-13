class CommentsController < ApplicationController

  wrap_parameters false

  before_action :authorize, except: [:create]

  def create
    user = User.find(cookies.signed[:user_id])
    if user
      comment = user.comments.new(comment_params)
      comment.archived = false
      if comment.save
        render json: comment, status: :ok
      else
        render json: {error: "unable to save comment"}, status: :unprocessable_entity
      end
    else
      render json: {error: "you are not signed in or are have not confirmed your account"}
    end
  end

  def update
    if @comment.update(comment_params)
      render json: @comment, status: :ok
    else
      render json: {error: "comment could not be updated"}, status: :unprocessable_entity
    end
  end

  def destroy
    if @comment.update(archived: true)
      head :ok
    else
      render json: {error: "comment could not be removed"}
    end
  end

  private

  def comment_params
    params.permit(:body, :blog_id)
  end

  def authorize
    @user = User.find(cookies.signed[:user_id])
    @comment = @user.comments.find(params[:id])
    render json: {error: "You are not authorized or signed in"}, status: :forbidden if @user.nil? || !@user.admin
    render json: {error: "Comment does not exist"}, status: :not_found if @comment.nil?
  end
end
