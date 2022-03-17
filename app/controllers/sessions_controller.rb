class SessionsController < ApplicationController
    def new
        @user = User.new
    end

    def create         
        @user = User.find_by_email params[:email]

        if @user && @user.authenticate(params[:password])
            session[:user_id] = @user.id
            puts session[:user_id]
            flash[:notice] = "welcome back Awesome Answer "
            redirect_to root_path
        else 
            flash.alert = "Wrong email or password"
            render 'new', status: 303
        end    
    end

    def destroy        
        session[:user_id] = nil
        flash[:notice] = "Successfully Logged out"
        redirect_to root_path
    end
end
