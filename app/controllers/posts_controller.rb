class PostsController < ApplicationController
    before_action :authenticate_user
    def new 
        @post = Post.new
    end

    def create
        @post = authenticate_user.posts.build(post_params)
        if @post.save
            @post.file = url_for(@post.file)
            @post.save
            flash[:success] = "profile upload successfully"
            redirect_to user_post_path
            else
                flash[:error] = @profile.errors.full_messages
                redirect_to user_post_path
        end
    end

    def show
      @posts = Post.all

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

    def post_params
        params.require(:post).permit(:title, :file)
    end

end
