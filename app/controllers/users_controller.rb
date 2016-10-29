class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    
    # @user = User.new(params[:user]) #takes the user hash as argument
    # equivalent to:
    # @user = User.new(name: "Foo Bar", 
    #                  email: "foo@invalid",
    #                  password: "foo",
    #                  password_confirmation: "bar")
    
    if @user.save
      log_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to user_url(@user)
    else
      render 'new'
    end
  end
  
  
  private
  
  def user_params
    params.require(:user).permit(:name, 
                                 :email,
                                 :password,
                                 :password_confirmation)
  end
  
  # In the present instance, we want to require the params hash 
  # to have a :user attribute (object??), and we want to permit the 
  # name, email, password, and password confirmation attributes 
end
