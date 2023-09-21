class RoomsController < ApplicationController
  before_action :authenticate_user

  def create
    @room = Room.create(name: params["room"]["name"])
  end

  def index
    @room = Room.new
    # @current_user = current_user
    redirect_to '/signin' unless @current_user
    @rooms = Room.public_rooms
    @users = User.all_except(@current_user)
  end

  def show
    @message = Message.new
    @current_user = current_user
    @single_room = Room.find(params[:id])
    @rooms = Room.public_rooms
    @users = User.all_except(@current_user)
    @room = Room.new
    @messages = @single_room.messages
  
    render "index"
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
