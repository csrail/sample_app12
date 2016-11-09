module SessionsHelper
  
  # Logs in given user
  def log_in(user)
    session[:user_id] = user.id
  end
  
  # Remembers a user by/in a persistent session
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
  
  def current_user?(user)
    user == current_user
  end
  
  # Returns the current user logged in (if any)
  # Returns the user corresponding to the user_id session or remember_token cookie
  # Assigns user found via session or cookie to @current_user which is available for use in the controller or view
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end
  
  # Returns true if user is logged in - false otherwise
  def logged_in?
    !current_user.nil?
  end
  
  # Forgets a persistent session (a cookie dedicated to remember)
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
  
  # Manually logs out the current user
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end
  
  # Redirects to stored location (or to the default)
  def redirects_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end
  
  # Stores the URL trying to be accessed
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
