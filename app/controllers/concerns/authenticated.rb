require 'mojang/auth/yggdrasil'

module Authenticated
  
  def authenticate_user!
    if !user_signed_in?
      redirect_to controller: :sessions, action: :new, from: request.fullpath
    end
  end
  
  def authenticate_user
    clear_session
    
    Mojang::Auth::Yggdrasil.authenticate(
        params.require(:username), 
        params.require(:password)) do |token, profile|
        
      user = Profile.create_with(username: profile['name']).find_or_create_by(uuid: profile['id']) do |user|
        user.username = profile['name']
      end
      
      session[:user_id] = user.id
    end
    
    user_signed_in?
  end
  
  def verify_access_token
    toke = params[:accessToken]
    params.delete(:accessToken)
    
    if !toke
      return head :unauthorized
    end
    
    if !Mojang::Auth::Yggdrasil.validate(toke, false)
      head :unauthorized
    end
  end
  
  def user_signed_in?
    if !session.key?(:user_id)
      clear_session
      return false
    end
    
    true
  end
  
  def clear_session
    @current_user = nil
    session.delete(:user_id)
  end
  
  def current_user
    if @current_user.nil? && user_signed_in?
      @current_user = Profile.where(id: session[:user_id]).first
    end
    
    @current_user
  end
end
