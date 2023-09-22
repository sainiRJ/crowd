require_relative "../../lib/json_web_token"
require 'securerandom'

class UsersController < ApplicationController
    before_action :authenticate_user, only: [:index, :accept_friend_request, :decline_friend_request, :send_friend_request]


    def new
        @user = User.new
    end

    def create
        @user= User.new(user_params)
        @email = @user.email
        session[:user] = @user
        mailOTP = SecureRandom.random_number(1_000_000).to_s.rjust(6, '0')
        puts mailOTP
        session[:mailOTP] = mailOTP
       if ::UserMailer.send_otp(@email, mailOTP).deliver_now
        redirect_to user_verify_path
       end
    end
def postVerify
    def verify
    end
        if session[:mailOTP] == params[:mailOTP]
            user = User.new(session[:user])
            if user.save
                puts "user save success"
                session.delete(:mailOTP)
                session.delete(:user)
                flash[:success] = "Yor are create registration successfully"
                redirect_to login_path

            else
                flash[:danger] = user.errors.full_messages
                redirect_to new_path
            end
        else
            flash[:warning] = "Invalid OTP. Please try again."
            redirect_to profile_path
        end
end
    def login
        def login_form

        end
        email = params[:email]
        password = params[:password]
        @user = User.find_by(email: email)
        if @user && @user.authenticate(password)
            payload={ user_id: @user.id}
            token = ::JsonWebToken.encode(payload)
            session[:token] = token
            flash[:success] = "you are login successfully"
            redirect_to index_path
        end
    end

    def send_friend_request
        friend = User.find_by(id: params[:id])
    
        if friend.nil?
          flash[:error] = "User not found."
          redirect_back(fallback_location: root_path)
          return
        end
    
        unless @current_user.friend_requests_sent
          @current_user.friend_requests_sent = []
        end
    
        unless friend.friend_requests_received
          friend.friend_requests_received = []
        end
    
        unless @current_user.friend_requests_sent.include?(friend.id)
          @current_user.friend_requests_sent << friend.id
          friend.friend_requests_received << @current_user.id
          @current_user.save
          friend.save
          flash[:success] =  'Friend request sent!'
          redirect_to index_path
        else
          flash[:error] = "Friend request already sent."
          redirect_back(fallback_location: root_path)
        end
      end

      def accept_friend_request
        friend = User.find_by(id: params[:id])
    
        if friend.nil?
          flash[:error] = "User not found."
          redirect_back(fallback_location: root_path)
          return
        end
    
        unless @current_user.friends
          @current_user.friends = []
        end
    
        unless friend.friends
          friend.friends = []
        end
    
        if @current_user.friend_requests_received.include?(friend.id)
          @current_user.friends << friend.id
          friend.friends << @current_user.id
    
          # Remove friend from friend_requests_received
          @current_user.friend_requests_received.delete(friend.id)
          
          # Remove current_user from friend_requests_sent
          friend.friend_requests_sent.delete(current_user.id)
    
          @current_user.save
          friend.save
          redirect_to user_path(friend), notice: 'Friend request accepted!'
        else
          flash[:error] = "No pending friend request from this user."
          redirect_back(fallback_location: root_path)
        end
      end
    

  def decline_friend_request
    friend = User.find(params[:id])
    @current_user.friend_requests_received.delete(friend.id)
    friend.friend_requests_sent.delete(@current_user.id)
    @current_user.save
    friend.save
    redirect_to user_path(friend), notice: 'Friend request declined.'
  end


    
    def index
        @users = User.where.not(id: @current_user.id)
        @user = @current_user
    end

    
  def show
    @user = User.find(params[:id])
    @rooms = Room.public_rooms
    @users = User.all_except(@current_user)
    @room = Room.new
    @message = Message.new
    @room_name = get_name(@user, @current_user)
    @single_room = Room.where(name: @room_name).first || Room.create_private_room([@user, @current_user], @room_name)
    @messages = @single_room.messages

    render "rooms/index"
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
      def get_name(user1, user2)
        users = [user1, user2].sort
        "private_#{users[0].id}_#{users[1].id}"
      end 

    def user_params 
        params.require(:user).permit(:name, :mobile_number, :email, :gender, :password, :password_confirmation, :bithday)
    end 
end
