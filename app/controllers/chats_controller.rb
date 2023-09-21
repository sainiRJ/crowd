class ChatsController < ApplicationController
    before_action :authenticate_user
    def index
        @messages = Message.all
      end
    
      def create
        @message = @current_user.messages.build(content: params[:message][:content])
        if @message.save
          # Broadcast the message to all connected clients
          ActionCable.server.broadcast 'chat_channel', message: render_message(@message)
        end
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

    
      private
    
      def render_message(message)
        render(partial: 'message', locals: { message: message })
      end
end
