class SessionsController < ApplicationController  
  def new
  end
    
  def create
    @user_placeholder = User.find_by(email: params[:session][:email].downcase)
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        params[:session][:remember_me] == '1' ? remember(@user_placeholder) : forget(user)
        redirects_back_or user
        #redirect_to @user #which is actually user_url(user) >> /users/:id url
      else
        message = "Account not activated. "
        message << "Check your email for the activation link"
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end
  
  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
