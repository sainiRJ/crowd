class LikesController < ApplicationController
  before_action :find_post
  before_action :authenticate_user
  before_action :find_like, only: [:destroy]

  def create
    if already_liked?
      flash[:notice] = "You can't like more than once"
    else
      @post.likes.create(user_id: @current_user.id)
    end
    redirect_to post_path(@post)
  end

  def destroy
    if !(already_liked?)
      flash[:notice] = "Cannot unlike"
    else
      @like.destroy
    end
    redirect_to post_path(@post)
  end

  private
  def already_liked?
    Like.where(user_id: @current_user.id, post_id:
    params[:post_id]).exists?
  end

  def find_post
    @post = Post.find(params[:post_id])
  end

  def find_like
    @like = @post.likes.find(params[:id])
 end

  def authenticate_user
    token = session[:token]
    if token==nil
      flash[:error] = "please login first"
      redirect_to login_path
    else
      verify = ::JsonWebToken.decode(token)
      id = verify['user_id']
      @current_user = User.find_by(id: id)
    end
  end
end
