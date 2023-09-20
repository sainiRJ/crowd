require_relative "../../lib/json_web_token"
require 'securerandom'

class ProfilesController < ApplicationController
  before_action :authenticate_user

  def new
    @profile = Profile.new
  end

  def create

    @profile = @current_user.build_profile(image_params)
   
      
  if @profile.save
    @profile.profile_photo = url_for(@profile.file)
    @profile.cover_photo = url_for(@profile.video_file)
    @profile.save
 
      flash[:success] = "profile upload successfully"
      redirect_to profile_path
    else
      flash[:error] = @profile.errors.full_messages
      redirect_to profile_path
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

    def image_params
      params.require(:profile).permit(:file, :video_file)
  end
end
