class MessagesController < ApplicationController
  before_action :authenticate_user

    def create
        # @current_user = current_user
        @message = @current_user.messages.create(content: msg_params[:content], room_id: params[:room_id])
      end
    
      private
    
      def msg_params
        params.require(:message).permit(:content)
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
