class SearchController < ApplicationController
    def index
        @users = User.all
        @profile = Profile.all
    
        if params[:search]
          @users = @users.where("name LIKE ?", "%#{params[:search]}%")
        end
      end
end
