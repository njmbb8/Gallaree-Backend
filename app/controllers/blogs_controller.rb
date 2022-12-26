class BlogsController < ApplicationController

  before_action :authorize_for_post, except: [:show, :index]
  before_action :find_blog, except: [:index, :create]

  wrap_parameters false

  def index
    render json: Blog.all, status: :ok, each_serializer: BlogListSerializer, Serializer: BlogListSerializer
  end

  def show
    render json: @blog, status: :ok
  end

  def create
    blog = @user.blogs.new(blog_params)
    if blog.save
      recipients = User.where.not(id: @user.id)
      recipients.each {|recipient| BlogPostMailer.with(recipient: recipient, post: blog).notify.deliver_now}
      render json: blog, status: :ok
    else
      render json: {error: "could not save blog post"}, status: :unprocessable_entity
    end
  end

  def update
    if @blog.update(blog_params)
      render json: @blog, status: :ok
    else
      render json: {error: "unable to update blog"}, status: :unprocessable_entity
    end
  end

  def destroy
    if @blog.destroy
      head :ok
    else
      render json: {error: "could not delete post"}, status: :unprocessable_entity
    end
  end
end

private

def authorize_for_post
  @user = User.find(cookies.signed[:user_id])
  render json: {error: "you are not signed in or do not have permission to edit blogs"}, status: :forbidden if @user.nil? || !@user.admin
end

def find_blog
  @blog = Blog.find(params[:id])
  render json: {error: "unable to locate blog"}, status: :not_found if @blog.nil?
end

def blog_params
  params.permit(:title, :body, :photo)
end