class FriendshipsController < ApplicationController

  before_action :authenticate_user
  def new
  end

  def create
    friend = User.find(params[:friend_id])
    @friendship = @current_user.friendships.build(friend_id: friend.id, status: :pending)
    if @friendship.save
      flash[:success] = "Friend request sent!"
    else
      flash[:error] = "Unable to send friend request."
    end
    redirect_to users_path
  end

  def update
    @friendship = Friendship.find(params[:id])
    if params[:accept]
      @friendship.update(status: :accepted)
      flash[:success] = "Friend request accepted!"
    else
      @friendship.update(status: :declined)
      flash[:error] = "Friend request declined."
    end
    redirect_to current_user
  end

  def show
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
