class SessionsController < ApplicationController
  def new
    @title = "Sign in"
  end
  
  def create
    user = User.authen(params[:session][:email],
                       params[:session][:password])
    
    if user.nil?
      flash.now[:error] = "Invalid email/password combination"
      render :new
    else
      sign_in(user)
      redirect_to user_path(user)
    end
  end
  
  def destroy
  end
  
end
