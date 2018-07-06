class SessionsController < ApplicationController
  
  def new
    if user_signed_in?
      flash[:notice] = "You're already signed in."
      return redirect_to root_path
    end
  end
  
  def create
    if user_signed_in?
      flash[:notice] = "You're already signed in."
      return redirect_to root_path
    end
    
    if authenticate_user
      redirect_to params[:from]
    else
      flash[:notice] = "Authentication failed"
      redirect_to controller: :sessions, action: :new, from: params[:from]
    end
  end
  
  def destroy
    if !user_signed_in?
      flash[:notice] = "You're already signed out."
    else
      clear_session
    end
    
    return redirect_to root_path
  end
end
